import pytest
import requests
from main.banks_branches import Bank
from main.banks_branches import Branch
from main.user import User

def test_bank():
    user = User()
    user.admin_user_registration()
    token = user.admin_login()
    bank = Bank()
    response = bank.post_bank(token)
    print(response.text)
    print(response.headers)
    assert response.status_code == 201
    branch = Branch(bank.get_id())
    response = branch.post_branch(token)
    print(response.text)
    print(response.headers)
    assert response.status_code == 201
