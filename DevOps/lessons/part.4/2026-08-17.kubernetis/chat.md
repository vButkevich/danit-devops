Today

dl 19:26
хах, схоже разом їдемо кудись у відпустку

aleksvoronov 19:28
+

Volodymyr Vystavkin 19:28
+

Maksym Skomorokhov 19:28
+

Максим 19:28
+

Volodymyr Vystavkin 19:32
hypervisor

Maksym Skomorokhov 19:42
systemd

Maksym Skomorokhov 19:48
Ps aux

Maksym Skomorokhov 20:01
-

Максим 20:13
# 1. Base image FROM node:20-alpine # 2. Working directory inside the container WORKDIR /app # 3. Copy dependency files first (optimizes build caching) COPY package*.json ./ # 4. Install dependencies RUN npm install # 5. Copy the rest of the application code COPY . . # 6. Document the port the container listens on EXPOSE 3000 # 7. Command to execute when the container starts CMD ["npm", "start"]

Maksym Skomorokhov 20:24
-d

Maksym Skomorokhov 20:40
stdout

Yurii Vilchynskyi 20:41
https://gitlab.com/dan-it/groups/devops_14

dl 20:57
+

Volodymyr Vystavkin 20:57
+

Maksym Skomorokhov 20:58
+

Максим 20:58
+

aleksvoronov 20:58
+-

Ольга Кирилюк 21:00
+

yurii 21:11
це вважаєтся помилкою?

Yurii Vilchynskyi 21:11
так

Yurii Vilchynskyi 21:22

RUN pip install --no-cache-dir \
fastapi \
"uvicorn[standard]" \
psycopg2-binary

Yurii Vilchynskyi 21:28
rm -rf /var/lib/apt/lists/*
--no-install-recommends

dl 21:47
Я думав ми вчитися на мінікубіку будемо

dl 22:08
Готуйте ресурсів нормально)