from main.transaction import Transaction
from main.application import Application
from main.user import User

def test_Transaction():
    user = User()
    user.admin_user_registration()
    token = user.admin_login()
    application = Application()
    application.post_application()
    transaction = Transaction(application)
    response = transaction.post_transaction(token)
    print(response.text)
    print(response.headers)
    assert response.status_code == 200
