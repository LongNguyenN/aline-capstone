"""
To login as an admin. Will probably delete this later.
variables:
  -
classes:
  -
methods:
  -
"""
import requests

def admin_login():
    """
    Login as an admin.
    Return a bearer token
    """
    url = 'http://ln-alb-927291651.eu-west-1.elb.amazonaws.com:8070/login'
    headers = {
        'accept': '*/*',
        'Content-Type':'application/json'
    }
    data = {
        "username": "notbard",
        "password": "League1!"
    }
    response = requests.post(url, json=data, headers=headers)
    return response.headers['Authorization']

if __name__=="__main__":
    print(admin_login())
