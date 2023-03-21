import pytest
from main.user import User

def test_User():
    #admin user registration
    admin = User()
    response = admin.admin_user_registration()
    print(response.text)
    print(response.json)
    user_id = response.json()['id']
    role = response.json()['role']
    print(f'{user_id} {role}')
    assert admin.user_id == user_id
    assert admin.role == role
    assert response.status_code == 201
