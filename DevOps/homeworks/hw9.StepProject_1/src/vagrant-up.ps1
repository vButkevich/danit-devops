Clear-Host;
Remove-Variable * -ErrorAction SilentlyContinue;

Write-Host -f Yellow "Starting Vagrant environment setup...";

Set-Location $PSScriptRoot;
$env:BRIDGE_IFACE = 'Realtek PCIe 2.5GbE Family Controller';
vagrant up;
if($LASTEXITCODE -ne 0) {
    Write-Error "Failed to start Vagrant environment. Please check the error messages above.";
    exit $LASTEXITCODE;
}

Write-Host  -f green "VMs are up and running. You can access them using 'vagrant ssh app_vm' and 'vagrant ssh db_vm'.";