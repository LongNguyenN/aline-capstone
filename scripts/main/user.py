"""
    variables:
	- None
    classes:
    	-UserDataProducer
    methods:
    	- get_random_names(num) -> a list of (first name, last name)
    	- random_first_name() -> a random first name
    	- random_last_name() -> a random last name
    """
import random
import requests
from main.get_endpoint import get_endpoint

def random_phone_number():
      """return a random number 123-123-1234"""
      part1 = random_digit_string(3)
      part2 = random_digit_string(3)
      part3 = random_digit_string(4)
      return f'{part1}-{part2}-{part3}'

def random_string(num):
    """return a random string of length num"""
    string = ''
    for _ in range(num):
        string = string + chr(random.randint(ord('a'), ord('z')))
    return string

def random_digit_string(num):
    """return a random string of digits with num digits"""
    string = f'{random.randint(1,9)}'
    for _ in range(num-1):
        string = string + str(random.randint(0,9))
    return string

def random_status():
    """return a random application status"""
    status_list = [
        'APPROVED',
        'DENIED',
        'PENDING'
	]
    return random.choice(status_list)

def random_type():
    """return a random application type"""
    type_list = [
        'CHECKING_AND_SAVINGS',
        'CHECKING',
        'SAVINGS'
        #'CREDIT_CARD'
        ]
    return random.choice(type_list)

class User:
    """
    variables:

    methods:
    	- get_first_name() -> first name
    	- get_last_name() -> last name

    """
    def admin_login(self):
        """
        Login as an admin.
        Return a bearer token
        """
        url = get_endpoint() + ':8070/login'
        headers = {
            'accept': '*/*',
            'Content-Type':'application/json'
        }
        data = {
            "username": self.get_username(),
            "password": self.get_password()
        }
        response = requests.post(url, json=data, headers=headers, timeout=10)
        return response.headers['Authorization']

    def get_password(self):
        """return a generated password"""
        return f"A{self.first_name}{self.phone[0:3]}!"

    def get_username(self):
        """return a generated username"""
        return f"{self.first_name}.{self.last_name}{self.phone[4:7]}"

    def get_email(self):
        """return a generated email"""
        return f'{self.first_name}.{self.phone}@smoothstack.com'

    def admin_user_registration(self):
        """register an admin user and return response"""
        url = get_endpoint() + ':8070/users/registration'
        headers = {
            'accept':'*/*',
            'Content-Type':'application/json'
        }
        data = {
  	      "username": self.get_username(),
	        "password": self.get_password(),
	        "role": "admin",
	        "firstName": self.first_name,
	        "lastName": self.last_name,
        	"email": self.get_email(),
	        "phone": self.phone
        }
        response = requests.post(url, json=data, headers=headers, timeout=10)
        self.user_id = response.json()['id']
        self.role = response.json()['role']
        return response

    def __init__(self):
        self.user_id = -1
        self.role = 'none'
        self.first_name = random_first_name()
        self.last_name = random_last_name()
        self.phone = random_phone_number()

def get_random_names(num):
    """return a list with num random names"""
    with open('./main/first-names.txt', encoding="utf-8") as file:
        first_names = file.readlines()
    with open('./main/last-names.txt', encoding="utf-8") as file:
        last_names = file.readlines()
    names_list = []
    for _ in range(num):
        random_number1 = random.randrange(0, len(first_names)-1)
        random_number2 = random.randrange(0, len(last_names)-1)
        first_name = first_names[random_number1].strip()
        last_name = last_names[random_number2].strip().strip(',')
        names_list.append((first_name, last_name))
    return names_list

def random_first_name():
    """return a random first name"""
    with open('./main/first-names.txt', encoding="utf-8") as file:
        first_names = file.readlines()
        random_number = random.randrange(0, len(first_names)-1)
        return first_names[random_number].strip()

def random_last_name():
    """return a random last name"""
    with open('./main/last-names.txt', encoding="utf-8") as file:
        last_names = file.readlines()
        random_number = random.randrange(0, len(last_names)-1)
        return last_names[random_number].strip().strip(',')
