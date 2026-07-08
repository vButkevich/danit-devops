<#
# Проблема в ACL Windows: приватний ключ доступний іншим користувачам або успадковує дозволи від папки.

# Запусти PowerShell від свого користувача:

$key = "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"

# Вимкнути успадкування і видалити успадковані дозволи
icacls $key /inheritance:r
# Видалити типові групи з доступу
icacls $key /remove:g "Users" "Authenticated Users" "BUILTIN\Users" "Everyone"
# Надати поточному користувачу тільки читання
icacls $key /grant:r "$env:USERNAME`:R"



icacls $key /inheritance:r
icacls $key /remove "*S-1-1-0" "*S-1-5-11" "*S-1-5-32-545"
icacls $key /grant:r "$env:USERDOMAIN\$env:USERNAME`:R"

# Перевір дозволи:
icacls $key

#>

<#
$key = "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Зробити поточного користувача власником
takeown /F $key

icacls $key /setowner "$user"

# Вимкнути успадкування
icacls $key /inheritance:r

# Видалити зайві групи
icacls $key /remove:g `
"Everyone" `
"Users" `
"Authenticated Users" `
"BUILTIN\Users"

# Залишити поточному користувачу тільки читання
icacls $key /grant:r "${user}:(R)"

#>

ssh -i "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem" ubuntu@63.180.55.80

ip a

curl ifconfig.me


# -- ----------------------------------------
eval "$(ssh-agent -s)"
ssh-add "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"
ssh -A -J ubuntu@63.180.55.80 ubuntu@192.168.2.249


ssh -i "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem" ubuntu@18.156.178.70

ssh -A -J ubuntu@18.156.178.70 ubuntu@10.0.2.50