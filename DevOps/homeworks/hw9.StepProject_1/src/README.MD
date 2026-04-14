

vm-db:  192.168.99.10
app-vm: 192.168.99.11


мшжливо необхідно буде прописати в ENV назцу мережевого адаптера 
Vagrantfile
line(4)bridge_name = ENV['BRIDGE_IFACE'] || 'Realtek PCIe 2.5GbE Family Controller' 



Vagrant vm network config

    # db.vm.network "public_network", bridge: "Realtek PCIe 2.5GbE Family Controller"
    db.vm.network "private_network", ip: "192.168.99.10"

Підключення з іншої віртуалки до petclinic
bash: psql -h IP_адреса_сервера -U postgres -d назва_бази
psql -h 192.168.99.10 -U postgres -d petclinic -p 5432
psql -h 192.168.99.10 -U appuser -d petclinic -p 5432  (password:12345678)
psql -h 192.168.99.10 -U test -d test -p 5432 (password: test2test)

test:
select * from test

systemctl status petclinic
journalctl -u petclinnic -f


http://192.168.99.11:8080/
