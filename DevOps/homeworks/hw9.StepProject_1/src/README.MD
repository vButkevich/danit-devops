

Vagrant vm network config

    # db.vm.network "public_network", bridge: "Realtek PCIe 2.5GbE Family Controller"
    db.vm.network "private_network", ip: "192.168.99.10"
