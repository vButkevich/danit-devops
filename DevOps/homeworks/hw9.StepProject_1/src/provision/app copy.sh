#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f /vagrant/provision/lib/common.sh ]]; then
  SCRIPT_DIR='/vagrant/provision'
fi
info "Script directory: ${SCRIPT_DIR}"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/.env"

. "$SCRIPT_DIR/.env"
#--------------------------------------------------------------------
PREREQUISITES=(
    git
    curl
    gettext
    ca-certificates
    openjdk-21-jre
    openjdk-21-jdk
    maven
)
# java:
# jre - java runtime environment
# jrk - java development kit
# 1. clone repo
    # git clone https://github.com/spring-projects/spring-petclinic.git
# 2. install jre+jdk
    # sudo atp update
    # sudo apt install openjdk-21-jdk -y
        ### sudo apt install default-jre default-jdk
        ### sudo apt update openjdfk-17-jre openjdk-17-jdk -y
        ### sudo apt update openjdfk-21-jre openjdk-21-jdk -y
    
# 3. install maven (java-builder)
    # sudo apt install maven -y
    # cd /spring-petclinic
# 4. build app with maven
    # mvn package -DskipTests
# systemd.unit
        #
        #configure systemd unit file for petclinic app
        # 1. create file /etc/systemd/system/petclinic.service
        # 2. add content:
        # [Unit]
        # Description=Petclinic Spring Boot Application
        # After=network.target
#configure application properties
        # 1. create file /etc/petclinic/application.properties
        # 2. add content:
        # spring.datasource.url=jdbc:postgresql://localhost:5432/petclinic
        # spring.datasource.username=appuser
        # spring.datasource.password=12345678
    #src/main/resources/application.properties

#run app with systemd
    #cd target
    #java -jar target/spring-petclinic-*.jar
# db_name
# db_user
# db_password
# db_address = db_host:DB_port
# url jdbc:postgresql://localhost:5432/db_name
#--------------------------------------------------------------------
java_build_application() {
    info "Building petclinic application with maven"
    local app_dir="/home/vagrant/spring-petclinic"
    if [[ ! -d "${app_dir}" ]]; then
        git_clone_repo "https://github.com/spring-projects/spring-petclinic.git"
    fi
    cd "${app_dir}"
    mvn package -DskipTests    

    info "Application built successfully"
}

# configure_systemd() {
#     info "Configuring systemd unit for petclinic application"
#     local service_file="/etc/systemd/system/petclinic.service"
#     cat > "${service_file}" <<EOF
# [Unit]
# Description=Petclinic Spring Boot Application
# After=network.target
# [Service]
# User=vagrant
# WorkingDirectory=/home/vagrant/spring-petclinic
# ExecStart=/usr/bin/java -jar /home/vagrant/spring-petclinic/target/spring-petclinic-*.jar
# Restart=always
# [Install]
# WantedBy=multi-user.target
# EOF
#     }
# run_systemd_application() {
#     info "Running petclinic application with systemd"    
#     systemctl daemon-reload
#     systemctl enable petclinic
#     systemctl start petclinic
# }
create_petclinic_service() {
    info "Creating petclinic service"
    local service_file="/etc/systemd/system/petclinic.service"
    local source_file="${SCRIPT_DIR}/petclinic.service"
    info "Looking for service file at ${source_file}"
        if [[ ! -f "${source_file}" ]]; then
            echo "ERROR: Service file not found at ${source_file}" >&2
            exit 1
        fi
    info "Copying service file from ${source_file} to ${service_file}"
    # cp "${source_file}" "${service_file}"
 
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
    # echo "DB_URL=${DB_URL}"
    # echo "APP_EXECUTABLE=${APP_EXECUTABLE}"
    envsubst < "${source_file}" > "${service_file}"
    info "--------------------------------------------------------------"
    info "Service file content:"
    cat "${service_file}"
    info "--------------------------------------------------------------"
    
    info "Petclinic service created successfully"
}       
start_petclinic_application() {
    info "Starting petclinic application"

    systemctl daemon-reload
    systemctl enable petclinic
    systemctl start petclinic

    info "Petclinic service started"
} 

check_db_connection1() {
    info "Checking.1 database connection to ${DB_HOST}:${DB_PORT}"

    if psql -h "${DB_HOST}" -U "${DB_USERNAME}" -d "${DB_NAME}" -c "SELECT 1;" > /dev/null 2>&1; then
        info "Database connection successful"
    else
        echo "ERROR: Cannot connect to database ${DB_HOST}:${DB_PORT}/${DB_NAME}" >&2
        # exit 1
    fi
}
check_db_connection2() {
    info "Checking database connection to [${DB_HOST}:${DB_PORT}/${DB_NAME}]"

    if PGPASSWORD="test2test" psql \
        -h "192.168.99.10" \
        -U "test" \
        -d "test" \
        -p "5432" \
        -c "SELECT version();" 2>&1; then
        info "Database connection successful"
    else
        echo "ERROR: Cannot connect to [${DB_HOST}:${DB_PORT}/${DB_NAME}]" >&2
        exit 1
    fi
}
check_db_connection3() {
    info "Checking.3 database connection to [${DB_HOST}:${DB_PORT}]"
    echo "192.168.99.10:5432:test:test:test2test" > ~/.pgpass
    chmod 600 ~/.pgpass
    # psql -h "${DB_HOST}" -U test -d testpsql -p "${DB_PORT}"
    su postgres -c "psql -h 192.168.99.10 -U test -d test -p 5432 -c 'SELECT version();'"
    info "Database connection.3.1 check completed"

    PGPASSWORD="123test2test" psql -h 192.168.99.10 -U test -d test -c "\dt"

    # if psql -h "${DB_HOST}" -U test -d test -p "${DB_PORT}" -c "SELECT 1;" > /dev/null 2>&1; then
    #     info "Database connection successful"
    # else
    #     echo "ERROR: Cannot connect to database ${DB_HOST}:${DB_PORT}/${DB_NAME}" >&2
    #     # exit 1
    # fi
}
#--------------------------------------------------------------------
main() {
  require_root
  SCRIPT="DB provisioning for [petclinic-APP]"
  info "Start script: ${SCRIPT}"

    install_prerequisites

    local repo_url="https://github.com/spring-projects/spring-petclinic.git"
    git_clone_repo "${repo_url}"
    java_build_application
    create_petclinic_service
    start_petclinic_application

    check_db_connection1
    check_db_connection2
    check_db_connection3

  info "End script: ${SCRIPT}"
}
main "$@"
#--------------------------------------------------------------------
