# ssh -i "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem" ubuntu@18.156.178.70

eval "$(ssh-agent -s)"
ssh-add "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"
ssh -A -J ubuntu@18.156.178.70 ubuntu@10.0.2.50
ssh -A -J ubuntu@18.156.178.70 ubuntu@10.0.2.163

ssh ubuntu@18.156.178.70
# # <#
# eval "$(ssh-agent -s)" — це команда для Bash/Linux/macOS. У Windows PowerShell команди eval немає.
# Помилка 1058 означає, що служба OpenSSH Authentication Agent вимкнена.

# Запустіть PowerShell від імені адміністратора та виконайте:
Get-Service ssh-agent

# Увімкніть автоматичний запуск служби:
Set-Service -Name ssh-agent -StartupType Automatic

# Запустіть її:
Start-Service ssh-agent

# Перевірте статус:
Get-Service ssh-agent

# Має бути:
# Status   Name       DisplayName
# ------   ----       -----------
# Running  ssh-agent  OpenSSH Authentication Agent

# Після цього додайте приватний ключ:
# ssh-add "C:\path\to\your-key.pem"
# Наприклад:
ssh-add "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"

# Перевірте, що ключ додано:
ssh-add -l

# Підключення до EC2:
# ssh ubuntu@PUBLIC_IP
ssh ubuntu@18.156.178.70

# Або без ssh-agent, напряму через ключ:
# ssh -i "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem" ubuntu@PUBLIC_IP

# Якщо Set-Service повертає Access is denied, PowerShell запущено не від адміністратора.
# Також можна виконати все однією послідовністю:
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
ssh-add "C:\Slavko\DAN-IT\DevOps\.aws\main-key-pair.pem"
ssh-add -l

# Якщо команда ssh-agent взагалі відсутня, встановіть OpenSSH Client:
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

# Якщо стан NotPresent:
# Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# #>#
