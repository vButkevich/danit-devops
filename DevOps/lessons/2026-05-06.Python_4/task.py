# py -m pip install request
import requests
import json

# requests.get('https://www.google.com')
# response = requests.get('https://jsonplaceholder.typicode.com/posts/1')
print('------------------ ------------------ ------------------ ------------------ ------------------')
response = requests.get('https://jsonplaceholder.typicode.com/users')
print(response.status_code)
users = response.json()
print(users)
print(len(users))
for user in users:
    # print(user['name']+' - '+user['email'])
    # print(user['name']+' - '+user['email']  + ' - ' + user['address']['city'])
    print(f"{user['id']}:{user['name']} - {user['email']}")
    lat = user['address']['geo']['lat']
    lng = user['address']['geo']['lng']
    print(f"\tCoordinates: {lat}, {lng}")
# break


response = requests.get('https://jsonplaceholder.typicode.com/posts')
# print(response.status_code)
# print(response.json())
# print(response.text)
posts = response.json()
# print(response.text)
print(posts[0])
print(f"Number of posts: {len(posts)}")


def get_user_posts(user_id):
    response = requests.get(f'https://jsonplaceholder.typicode.com/posts?userId={user_id}')
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code}")
        return None
for user in users:
    # print(f"{user['id']} - {user['name']} - {user['email']}")    
    user_id = user['id']
    user_posts = get_user_posts(user_id)
    if user_posts is not None:
        # print(f"Posts for user {user_id}:")
        # for post in user_posts:
        #     print(f"- {post['title']}")
        print(f"{user['id']}:{user['name']} -  Number of posts: {len(user_posts)}")


# # text = response.text
# # print(text)
# # requests.get('https://www.google.com/404')

# response = requests.get('https://jsonplaceholder.typicode.com/posts')
# print(response.status_code)
# print(response.json())
# print(response.text)
# data = response.json()
# print(data)
# print(len(data))
# # print('------------------ ------------------ ------------------ ------------------ ------------------')
# # response = requests.get('https://jsonplaceholder.typicode.com/users/1')
# # print(response.status_code)
# # data = response.json()
# # text = response.text
# # print(data)
# # print(len(data))
# # print(text)


# class alfabet:
#     def __init__(self, name):
#         self.name = name

#     def __str__(self):
#         return f'Alfabet: {self.name}'
    