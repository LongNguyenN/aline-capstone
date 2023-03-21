"""
Genereate random banks and branches data
variables:
	- None
classes:
	- Bank
	- Branch
methods:
	- random_address() -> a random address
"""
import random
import requests
from main.user import random_digit_string, random_string, random_phone_number
from main.get_endpoint import get_endpoint

class Bank():
    """
    variables:
    	- bank_id
    	- routing_number
    	- address
    	- city
    	- state
    	- zipcode
    methods:
	- get_routin_number() -> the routing number
	- get_bank_id() -> the bank id
    """
    def get_id(self):
        """returns the bank's id"""
        return self.bank_id

    def post_bank(self, token):
        """make a bank with a post request"""
        url = get_endpoint() + ':8083/banks'
        headers = {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization' : token
        }
        data = {
            "routingNumber": self.routing_number,
            "address": self.address,
            "city": self.city,
            "state": self.state,
            "zipcode": self.zipcode
        }
        response = requests.post(url, json=data, headers=headers, timeout=10)
        self.bank_id = response.json()['id']
        return response

    def __init__(self):
        self.bank_id = -1
        self.routing_number = random_digit_string(9)
        self.address = random_address()
        self.city = random_string(9)
        self.state = random_state_name()
        self.zipcode = random_digit_string(5)

class Branch():
    """
    variables:
	- branch_id
	- name
	- address
	- city
	- state
	- zipcode
	- phone
	- bank_id
    methods:
    	- get_name() -> the name of the branch
	- get_branch_id() -> the branch id
    """
    def get_id(self):
        """return the branch's id"""
        return self.branch_id

    def post_branch(self, token):
        """post request to make a branch"""
        url = get_endpoint() + ':8083/branches'
        headers = {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': token
        }
        data = {
            "name": self.name,
            "address": self.address,
            "city": self.city,
            "state": self.state,
            "zipcode": self.zipcode,
            "phone": self.phone,
            "bankID": self.bank_id
        }
        response = requests.post(url, json=data, headers=headers, timeout=10)
        self.branch_id = response.json()['id']
        return response

    def __init__(self, bank_id):
        self.branch_id = -1
        self.name = random_digit_string(11)
        self.address = random_address()
        self.city = random_string(9)
        self.state = random_state_name()
        self.zipcode = random_digit_string(5)
        self.phone = random_phone_number()
        self.bank_id = bank_id

def random_address():
    """return a random address"""
    number = str(random.randint(1, 9999))
    street = random_state_name()
    specific = random_string(3)
    return f'{number} {street} {specific}'

def random_state_name():
    """return a random US state name"""
    state_list = [
        'Alabama',
        'Alaska',
        'Arizona',
        'Arkansas',
        'California',
        'Colorado',
        'Connecticut',
        'Delaware',
        'Florida',
        'Georgia',
        'Hawaii',
        'Idaho',
        'Illinois',
        'Indiana',
        'Iowa',
        'Kansas',
        'Kentucky',
        'Louisiana',
        'Maine',
        'Maryland',
        'Massachusetts',
        'Michigan',
        'Minnesota',
        'Mississippi',
        'Missouri',
        'Montana',
        'Montana',
        'Nebraska',
        'Nevada',
        'New Hampshire',
        'New Jersey',
        'New Mexico',
        'New York',
        'North Carolina',
        'North Dakota',
        'Ohio',
        'Oklahoma',
        'Oregan',
        'Pennsylvania',
        'Rhode Island',
        'South Carolina',
        'South Dakota',
        'Tennessee',
        'Texas',
        'Utah',
        'Vermont',
        'Virginia',
        'Washington',
        'West Virginia',
        'Wisconsin',
        'Wyoming'
    ]
    random_int = random.randint(0, 49)
    return state_list[random_int]
