"""
Produces random transaction data.
variables:
	-none
classes:
	-
methods:
	- random_type() -> a transaction type
	- random_method() -> a transaction method
	- random_status() -> a transaction status
"""
import random
import requests
from main.get_endpoint import get_endpoint

def random_status():
    """return a random transaction status"""
    status_list = [
        'APPROVED'
    ]
    return status_list[random.randint(0, len(status_list)-1)]

def random_method():
    """return a random transaction method"""
    method_list = [
        'ACH',
        'ATM',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'APP'
    ]
    return method_list[random.randint(0,4)]

def random_type():
    """return a random transaction type"""
    type_list = [
        'WITHDRAWAL',
        'PURCHASE',
        'DEPOSIT',
        'TRANSFER_OUT',
        'TRANSFER_IN'
    ]
    return type_list[random.randint(0,4)]

def random_merchant():
    """return a tuple with a merchant code and mechant name"""
    merchant_list = [
        ('DUCKY', 'quack company inc'),
        ('QUANTUM', 'quantum leap'),
        ('PERMA', 'permanent garden supplies CO'),
        ('TRAFF', 'traffic be gone'),
        ('PENTA', 'pentagrams for all')
    ]
    return merchant_list[random.randint(0,4)]

class Transaction():
    """
    variables:
    	-
    methods:
    	-
    """
    def get_id(self):
        """return the id"""
        return self.transaction_id

    def post_transaction(self, token):
        """post request to make a new transaction"""
        url = get_endpoint() + ':8073/transactions'
        headers = {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': token
        }
        data = {
            "type": self.transaction_type,
            "method": self.method,
            "amount": self.amount,
            "merchantCode": self.merchant[0],
            "merchantName": self.merchant[1],
            "accountNumber": self.account.account_number
        }
        response = requests.post(url, json=data, headers=headers, timeout=10)
        self.transaction_id = response.json()['id']
        self.status = response.json()['status']
        return response

    def __init__(self, account):
        self.transaction_id = -1
        self.transaction_type = random_type()
        self.method = random_method()
        self.amount = random.randint(1, 1000000)
        self.merchant = random_merchant()
        self.account = account
        self.status = 'None'
        self.state = 'POSTED'
