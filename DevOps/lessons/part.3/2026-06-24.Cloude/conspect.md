Короткий конспект: побудова мережі AWS

У транскрипті інколи звучить VPS, але правильний термін — VPC, Virtual Private Cloud. VPC — це ізольована віртуальна мережа AWS, усередині якої створюються підмережі, маршрути, шлюзи та EC2 instances.

1. Цільова схема

Для навчального або невеликого проєкту:

AWS Region
└── VPC: 10.10.0.0/20
    ├── Availability Zone A
    │   ├── Public subnet A
    │   │   ├── Load Balancer / Bastion / public EC2
    │   │   └── NAT Gateway + Elastic IP
    │   └── Private subnet A
    │       └── Application EC2
    │
    └── Availability Zone B
        ├── Public subnet B
        │   └── Load Balancer / public resources
        └── Private subnet B
            └── Application EC2

Internet
   │
Internet Gateway
   │
Public Route Table
   ├── Public subnet A
   └── Public subnet B

Private Route Table
   ├── Private subnet A
   └── Private subnet B
        │
        └── NAT Gateway → Internet Gateway → Internet

Public subnet визначається не назвою, а наявністю маршруту 0.0.0.0/0 → Internet Gateway.
Private subnet не має прямого маршруту до Internet Gateway; для виходу в інтернет вона використовує NAT Gateway.

Покрокова конфігурація
Крок 1. Вибрати AWS Region

Наприклад:

eu-central-1 — Frankfurt

Усі основні ресурси створюйте в одному вибраному регіоні. AWS Console може автоматично переключатися на інший регіон, тому перед створенням або пошуком ресурсу завжди перевіряйте регіон у правому верхньому куті.

VPC є регіональним ресурсом, а subnet завжди належить одній конкретній Availability Zone.

Наприклад:

eu-central-1a
eu-central-1b

Одна subnet не може одночасно охоплювати дві Availability Zones. Для відмовостійкості створюють окремі subnet у кількох AZ. Це одна з основних ідей транскрипту.

Крок 2. Спланувати CIDR VPC

Для VPC використовуються приватні IPv4-діапазони:

10.0.0.0/8
172.16.0.0/12
192.168.0.0/16

Для навчальної мережі можна взяти:

VPC: 10.10.0.0/20

Це дає 4096 IPv4-адрес і залишає достатньо місця для розбиття на subnet.

Не варто без потреби створювати надто великий CIDR, наприклад /16. У майбутньому VPC може знадобитися з’єднати через VPC Peering, Transit Gateway або VPN з іншою мережею. Їхні CIDR не повинні перетинатися.

AWS дозволяє створювати IPv4 CIDR VPC розміром від /16 до /28. Первинний CIDR VPC не можна просто замінити після побудови інфраструктури, тому адресний план краще визначити заздалегідь.

Крок 3. Створити VPC

AWS Console:

VPC
→ Your VPCs
→ Create VPC

Параметри:

Name: main-vpc
IPv4 CIDR: 10.10.0.0/20
IPv6: No IPv6 CIDR block — якщо IPv6 поки не потрібен
Tenancy: Default

Рекомендовано увімкнути:

DNS resolution
DNS hostnames

DNS hostnames особливо потрібні для EC2 з public IP та для роботи багатьох керованих AWS-сервісів.

Крок 4. Розділити VPC на subnet

Приклад адресного плану:

Subnet	Availability Zone	CIDR	Призначення
public-a	eu-central-1a	10.10.0.0/24	Load Balancer, Bastion, NAT
public-b	eu-central-1b	10.10.1.0/24	Load Balancer, public resources
private-a	eu-central-1a	10.10.10.0/24	Application EC2
private-b	eu-central-1b	10.10.11.0/24	Application EC2

AWS Console:

VPC
→ Subnets
→ Create subnet

Для кожної subnet вказати:

VPC
Subnet name
Availability Zone
IPv4 subnet CIDR

CIDR subnet не можуть перетинатися й мають входити в CIDR VPC.

Нюанс із кількістю адрес

У subnet /24 є 256 IPv4-адрес, але AWS резервує перші чотири та останню адресу кожної subnet.

Наприклад, для:

10.10.0.0/24

зарезервовані:

10.10.0.0     Network address
10.10.0.1     VPC router
10.10.0.2     DNS
10.10.0.3     AWS reserved
10.10.0.255   Network broadcast address

Отже, користувачу доступна 251 адреса.

Крок 5. Налаштувати автоматичні public IP

Для public subnet:

Subnets
→ вибрати public-a
→ Actions
→ Edit subnet settings
→ Enable auto-assign public IPv4 address

Повторити для public-b.

Для private subnet ця опція повинна залишатися вимкненою.

Однак сама опція auto-assign public IP ще не робить subnet публічною. Потрібні одночасно:

Internet Gateway, прикріплений до VPC.
Маршрут 0.0.0.0/0 → Internet Gateway.
Public IPv4 або Elastic IP на ресурсі.
Security Group і Network ACL, які дозволяють трафік.

Для інтернет-з’єднання через IGW instance у public subnet повинна мати public IPv4 або Elastic IP.

Крок 6. Створити Internet Gateway

AWS Console:

VPC
→ Internet Gateways
→ Create internet gateway

Параметри:

Name: main-igw

Після створення:

Actions
→ Attach to a VPC
→ main-vpc

Internet Gateway забезпечує зв’язок VPC із публічним інтернетом, але сам по собі нічого не маршрутизує. Потрібно додати маршрут до відповідної Route Table. У транскрипті окремо підкреслюється необхідність створити IGW і прикріпити його до VPC.

Крок 7. Створити Public Route Table

AWS Console:

VPC
→ Route Tables
→ Create route table

Параметри:

Name: main-public-rt
VPC: main-vpc

У таблиці вже буде локальний маршрут:

10.10.0.0/20 → local

Він забезпечує маршрутизацію між subnet усередині однієї VPC.

Додати маршрут:

Destination: 0.0.0.0/0
Target: Internet Gateway
Target value: main-igw

Результат:

Destination	Target
10.10.0.0/20	local
0.0.0.0/0	main-igw

Маршрут local створюється автоматично. Route Table визначає destination і target для трафіку subnet.

Крок 8. Асоціювати Public Route Table

У main-public-rt:

Subnet associations
→ Edit subnet associations

Вибрати:

public-a
public-b

Саме ця асоціація разом із маршрутом на IGW робить subnet публічними. У транскрипті route table створюється окремо, після чого додається маршрут через Internet Gateway і виконується асоціація із subnet.

Крок 9. Створити Elastic IP

Для звичайного public zonal NAT Gateway потрібна Elastic IP — статична публічна IPv4-адреса.

AWS Console:

VPC
→ Elastic IP addresses
→ Allocate Elastic IP address

Або адресу можна створити безпосередньо під час створення NAT Gateway.

Elastic IP не видаляється автоматично разом із NAT Gateway. Після видалення NAT необхідно окремо виконати:

Elastic IP addresses
→ Release Elastic IP address

Інакше адреса залишиться зарезервованою та може продовжувати тарифікуватися. Цей нюанс прямо обговорювався в транскрипті.

Крок 10. Створити NAT Gateway

Призначення NAT Gateway:

Private EC2 → NAT Gateway → Internet Gateway → Internet

NAT дозволяє ресурсам private subnet ініціювати вихідні з’єднання, наприклад:

apt update
docker pull
npm install
завантаження оновлень
звернення до зовнішніх API

При цьому зовнішній клієнт не може самостійно ініціювати нове з’єднання до private instance через NAT.

AWS Console:

VPC
→ NAT Gateways
→ Create NAT gateway

Для навчальної zonal-конфігурації:

Name: main-nat-a
Availability mode: Zonal
Subnet: public-a
Connectivity type: Public
Elastic IP: створена раніше EIP

NAT Gateway потрібно створювати саме в public subnet, route table якої має маршрут до Internet Gateway. Private subnet повинна маршрутизувати інтернет-трафік до NAT Gateway.

У транскрипті вибирається zonal NAT Gateway, public subnet і виконується Allocate Elastic IP.

Крок 11. Створити Private Route Table
VPC
→ Route Tables
→ Create route table

Параметри:

Name: main-private-rt
VPC: main-vpc

Маршрути:

Destination	Target
10.10.0.0/20	local
0.0.0.0/0	main-nat-a

Після цього:

Subnet associations
→ private-a
→ private-b

Тепер EC2 у private subnet:

не має public IP;
не доступна безпосередньо з інтернету;
може сама виходити в інтернет через NAT Gateway.
Підсумкові Route Tables
Public Route Table
10.10.0.0/20 → local
0.0.0.0/0    → Internet Gateway

Асоціації:

public-a
public-b
Private Route Table
10.10.0.0/20 → local
0.0.0.0/0    → NAT Gateway

Асоціації:
private-a
private-b

-- ---------------------------------------------------------------------------------
Крок 12. Створити EC2 у public subnet

AWS Console:

EC2
→ Instances
→ Launch instance

Приклад:

Name: bastion-host
AMI: Ubuntu Server 24.04 LTS
Instance type: t3.micro або доступний Free Tier type
Key pair: створити або вибрати наявний
VPC: main-vpc
Subnet: public-a
Auto-assign public IP: Enable

У транскрипті для першої EC2 вибирається Ubuntu, власна VPC, public subnet, key pair та ввімкнений auto-assign public IP.

Security Group для public EC2

Наприклад:

Inbound:
SSH TCP 22 → My IP

Outbound:
All traffic → 0.0.0.0/0

Не використовуйте:

SSH 22 → 0.0.0.0/0

для постійної конфігурації. Це відкриває SSH для всього інтернету.

Краще:

SSH → тільки ваша поточна public IP /32

Для вебсервера:

HTTP  80  → 0.0.0.0/0
HTTPS 443 → 0.0.0.0/0
SSH   22  → ваша IP/32

Ще кращий варіант — використовувати AWS Systems Manager Session Manager і взагалі не відкривати SSH.

Крок 13. Створити EC2 у private subnet

Параметри:

Name: application-server
VPC: main-vpc
Subnet: private-a
Auto-assign public IP: Disable

Security Group:

Inbound:
SSH 22 → Security Group bastion-host
або
Application port 8080 → Security Group Load Balancer

Outbound:
All traffic → 0.0.0.0/0

Ключовий принцип:

Не IP-адреса bastion → private EC2,
а Security Group bastion → Security Group private EC2

Це надійніше, оскільки приватні IP instances можуть змінюватися.

Крок 14. Перевірити роботу
Public EC2

Підключення:

ssh -i ".\main-key.pem" ubuntu@PUBLIC_IP

Перевірка інтернету:

curl https://checkip.amazonaws.com
sudo apt update
Private EC2 через Bastion

Варіант із ProxyJump:

ssh -i ".\main-key.pem" `
  -J ubuntu@BASTION_PUBLIC_IP `
  ubuntu@PRIVATE_EC2_IP

На private EC2:

curl https://checkip.amazonaws.com

Результатом має бути Elastic IP NAT Gateway, а не адреса private EC2. AWS описує аналогічний спосіб перевірки через зовнішній сервіс, який показує source IP.

Важливі нюанси побудови
1. Public subnet не означає, що всі ресурси автоматично доступні

Public subnet лише має маршрут до Internet Gateway.

Для доступності EC2 також потрібні:

Public IPv4 або Elastic IP
Security Group
Network ACL
запущений сервіс
коректний OS firewall
2. NAT Gateway не приймає вхідні з’єднання

NAT Gateway використовується для egress, тобто вихідного трафіку private subnet.

Він не виконує:

Internet → NAT → private EC2

Для вхідного трафіку використовуйте:

Application Load Balancer
Network Load Balancer
API Gateway
Bastion Host
VPN
AWS Systems Manager
3. Один NAT Gateway дешевший, але створює залежність від однієї AZ

Навчальна схема:

private-a ─┐
           ├→ NAT Gateway у public-a
private-b ─┘

Перевага:

менша вартість

Недоліки:

залежність від AZ-A;
міжзонний трафік від private-b до NAT-A;
можливі додаткові data-transfer charges;
при проблемі AZ-A private-b також втратить вихід в інтернет.

Класична production-схема для zonal NAT:

private-a → NAT-a
private-b → NAT-b

AWS рекомендує для zonal NAT створювати NAT Gateway у кожній використовуваній Availability Zone та направляти private subnet через NAT у тій самій AZ.

4. У 2026 році є Regional NAT Gateway

Транскрипт записано після появи нового режиму Regional NAT Gateway.

Regional NAT:

працює як одна логічна NAT Gateway для кількох AZ;
автоматично розширюється на Availability Zones із workload;
не потребує вибору конкретної subnet під час створення;
може автоматично керувати AZ coverage та EIP;
не підтримує private NAT;
може потребувати до 60 хвилин для розширення в нову AZ після появи workload.

Для навчальної роботи та повного розуміння маршрутизації можна використовувати Zonal NAT. Для нової production-архітектури варто окремо оцінити Regional NAT Gateway.

5. NAT Gateway коштує гроші навіть без активного трафіку

Оплата NAT Gateway складається щонайменше з:

погодинної вартості;
вартості за кожен оброблений GB;
можливого міжзонного data transfer;
вартості public IPv4 / Elastic IP.

NAT Gateway тарифікується за кожну годину існування та за оброблені дані. Актуальна ціна залежить від регіону; наведений AWS pricing example використовує $0.045/год і $0.045/GB, але перед створенням необхідно перевіряти ціну для конкретного регіону.

Для лабораторної роботи NAT потрібно видалити одразу після виконання завдання.

6. Public IPv4 також платні

Не створюйте public IP для кожної application EC2 без необхідності.

Типова схема:

Internet
→ один Load Balancer
→ кілька private EC2

Замість:

Internet
→ public IP кожної EC2

Це безпечніше, краще масштабується і зменшує кількість публічних адрес.

7. AWS-сервіси краще не завжди викликати через NAT

Наприклад, private EC2 може звертатися до S3:

private EC2 → NAT Gateway → Internet Gateway → S3

Але краще створити:

S3 Gateway VPC Endpoint

Тоді:

private EC2 → VPC Endpoint → S3

Це зменшує NAT data-processing cost і не потребує виходу через публічний інтернет. AWS у своїй типовій схемі private subnets використовує Gateway VPC Endpoint для доступу до S3.

Подібно можна використовувати Interface VPC Endpoints для:

SSM
ECR
CloudWatch
Secrets Manager
STS
8. Security Groups і Network ACL мають різні ролі
Security Group
прикріплюється до ENI/EC2;
stateful;
містить allow rules;
відповідний зворотний трафік дозволяється автоматично.
Network ACL
працює на рівні subnet;
stateless;
має allow і deny;
потрібно враховувати inbound, outbound та ephemeral ports.

Для більшості звичайних конфігурацій основний захист реалізують через Security Groups. NACL часто залишають стандартними, якщо немає окремих вимог.

9. Не плутати Internet Gateway і NAT Gateway
Компонент	Призначення
Internet Gateway	Зв’язок public resources VPC з інтернетом
NAT Gateway	Вихід private resources назовні без прямого inbound
Route Table	Визначає, через який target направляти трафік
Elastic IP	Статична public IPv4, зокрема для zonal public NAT
Security Group	Firewall ресурсу/мережевого інтерфейсу
10. Не розміщувати application і database у public subnet

Рекомендована production-схема:

Public subnets:
- Application Load Balancer
- NAT Gateway
- Bastion — лише якщо справді потрібен

Private application subnets:
- EC2 / ECS / EKS worker nodes

Isolated database subnets:
- RDS
- ElastiCache
- внутрішні database instances

Database subnet часто взагалі не повинна мати:

0.0.0.0/0 → NAT

Їй може бути достатньо лише локального доступу від application Security Group.

Контрольний checklist
[ ] Вибрано правильний Region
[ ] VPC CIDR не перетинається з іншими мережами
[ ] Створено мінімум 2 Availability Zones
[ ] Створено 2 public subnet
[ ] Створено 2 private subnet
[ ] CIDR subnet не перетинаються
[ ] Internet Gateway прикріплено до VPC
[ ] Public Route Table має 0.0.0.0/0 → IGW
[ ] Public subnet асоційовані з Public Route Table
[ ] Public zonal NAT знаходиться в public subnet
[ ] NAT має Elastic IP
[ ] Private Route Table має 0.0.0.0/0 → NAT
[ ] Private subnet асоційовані з Private Route Table
[ ] Public EC2 має public IP лише за необхідності
[ ] Private EC2 не має public IP
[ ] SSH не відкритий для 0.0.0.0/0
[ ] Security Groups посилаються одна на одну
[ ] Після лабораторної видалено NAT Gateway
[ ] Після NAT окремо звільнено Elastic IP
[ ] Перевірено Billing і Cost Explorer
Правильний порядок створення
1. Region
2. CIDR-план
3. VPC
4. Public і private subnets у двох AZ
5. Internet Gateway
6. Public Route Table → IGW
7. Асоціація public subnets
8. Elastic IP
9. NAT Gateway у public subnet
10. Private Route Table → NAT
11. Асоціація private subnets
12. Security Groups
13. Public EC2 / Load Balancer
14. Private EC2
15. Перевірка маршрутів і доступу
16. Перевірка витрат

Основна навчальна логіка транскрипту правильна: спочатку проєктується VPC і subnet, потім Internet Gateway, NAT, route tables, і лише після цього EC2 instances.