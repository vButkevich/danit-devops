Today

dl 19:04
Сорі, повернусь хвилин за 10

dl 19:14
Юрію премію перерахуйте)

Maksym Skomorokhov 19:25
Draining

dl 19:28
Це вже інсталити?

denys 19:32
+

Maksym Skomorokhov 19:32
+

Максим 19:32
+

dl 19:34
+

aleksvoronov 19:34
+

dl 19:38
+

Maksym Skomorokhov 19:46
Ох там команд

Yurii Vilchynskyi 19:46
https://docs.aws.amazon.com/cli/latest/reference/ec2/

dl 19:47
aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

dl 19:58 (Edited)
@Ольга Кирилюк  можна в тімпліт засунути сабнету якщо що

Ольга Кирилюк 20:02
так, можна, дякую

Maksym Skomorokhov 20:03
aws ec2 allocate-address --domain vpc
aws ec2 create-nat-gateway \ --subnet-id subnet-0123456789abcdef0 \ --allocation-id eipalloc-0123456789abcdef0

Yurii Vilchynskyi 21:41
aws --region eu-central-1 ec2 run-instances --image-id ami-0f92e2dae65c68e2f --instance-type t3.micro --subnet-id subnet-0aca16dad43ba9e75 --security-group-ids sg-01fb4149c17700d92 --associate-public-ip-address --key-name main-keypait --iam-instance-profile Name=AllowEC2All

dl 21:52 (Edited)
До речі у мене не було на інстансі aws cli чомусь  для Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type. Support available from Canonical (http://www.ubuntu.com/cloud/services).

dl 21:54 (Edited)
Ааа без нат треба отой прайвет лінк шо ви казали

dl 21:54
От де його використовувати

Yurii Vilchynskyi 22:01
https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

dl 22:01
А мені сподобалось

Yurii Vilchynskyi 22:09
aws ssm start-session --target i-008659e72860407e1