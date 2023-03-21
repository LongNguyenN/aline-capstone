"""
Populate database.
variables:
classes:
methods:
"""
import random
import requests
from main.get_endpoint import get_endpoint
from main.application import Application
from main.banks_branches import Bank
from main.banks_branches import Branch
from main.transaction import Transaction

from main.user import User

def populate_db():
    """fill data base with data"""
    #make an application
    app = Application()
    app.post_application()
    #make a user
    admin = User()
    admin.admin_user_registration()
    token = admin.admin_login()
    #make a bank
    bank = Bank()
    bank.post_bank(token)
    #make a branch
    branch = Branch(bank.get_id())
    branch.post_branch(token)
    #make a transaction
    balance = random.randint(10000,100000)
    transaction = Transaction(app)
    transaction.amount = balance
    transaction.transaction_type = 'DEPOSIT'
    transaction.post_transaction(token)
    for _ in range(3):
        transaction = Transaction(app)
        if transaction.transaction_type not in ['DEPOSIT', 'TRANSFER_IN']:
            transaction.amount = random.randint(100, balance-100)
            transaction.post_transaction(token)
            balance = balance - transaction.amount
        else:
            transaction.post_transaction(token)
            balance = balance + transaction.amount

# print(f'balance: {balance}')

if __name__=="__main__":
    print("Populating database..")
    populate_db()
    print("Done!")

