
Dmytro Vasiliev 19:01
Добрий вечір

Taras Voloshenko 19:31
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: my-storage-class
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2

Dmytro Vasiliev 19:42
@Taras Voloshenko питання: який дистрибутив оптимальніше використовувати на прод. онпрем? які плюси\мінуси?

Dmytro Vasiliev 19:43
перепрошую мав на увазі кубернетс

Dmytro Vasiliev 19:50
Це само собою, але питання витікають з наявних реалій а так як ми тут навчаємось - цікаво що краще вчитись розгортати і адмініструвати

Taras Voloshenko 19:52
https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/master/docs

Taras Voloshenko 20:04
https://github.com/ahmetb/kubectx

Taras Voloshenko 20:18
20-38

Maksym Skomorokhov 20:38
+

Ольга Кирилюк 20:38
+

aleksvoronov 20:38
+

Максим 20:38
+

dl 21:52
Юзай зовнішній Secret vault та і всьо
@Dmytro Vasiliev  Infisical
Я ж кидав тобі)

Taras Voloshenko 21:54
https://www.hashicorp.com/en/products/vault