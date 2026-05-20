FROM ubuntu

# RUN apt-get update && apt-get install -y nodejs npm
RUN apt update -y
RUN apt install iputils-ping -y

CMD  ["ping", "-c", "4", "google.com"]

# COPY . /app