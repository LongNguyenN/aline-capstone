"""
    variables:
	- None
    classes:
	- Applicant
    methods:
    	- random_digit_string(num) -> a random digit of length num
    	- random_gender() -> a random gender
    	- random_string(num) -> a random string of length num
"""
import random
from datetime import date
from main.user import random_first_name, random_last_name
from main.user import random_string, random_digit_string
from main.user import random_phone_number

class Applicant:
    """
    variables:

    methods:
	- get_applicant_id() -> return applicant id
	- generate_email() -> email address
	- my_information() -> a dictionary of personal information
    """
    def __init__(self):
        self.applicant_id = -1
        self.first_name = random_first_name()
        self.middle_name = random_first_name()
        self.last_name = random_last_name()
        self.date_of_birth = random_birth_date()
        self.gender = random_gender()
        self.email = self.generate_email()
        self.phone = random_phone_number()
        self.social_security = random_social_security_number()
        self.drivers_license = random_digit_string(9)
        self.address = random_address()
        self.city = random_string(6)
        self.state = random_string(2).upper()
        self.zipcode = random_digit_string(5)
        self.income = random_digit_string(9)

    def generate_email(self):
        """return email in form <first name>.<middle initial>.<last name>@smoothstack.com"""
        middle_initial = self.middle_name[0]
        email = f'{self.first_name}.{middle_initial}.{self.last_name}@smoothstack.com'
        return email

    def my_information(self):
        """return a dictionary of personal information"""
        info = {
	      "firstName": self.first_name,
	      "lastName": self.last_name,
	      "dateOfBirth": self.date_of_birth,
	      "gender": self.gender,
	      "email": self.email,
	      "phone": self.phone,
	      "socialSecurity": self.social_security,
	      "driversLicense": self.drivers_license,
	      "income": self.income,
	      "address": self.address,
	      "city": self.city,
	      "state": self.state,
	      "zipcode": self.zipcode,
	      "mailingAddress": self.address,
	      "mailingCity": self.city,
	      "mailingState": self.state,
	      "mailingZipcode": self.zipcode
	    }
        return info

def random_birth_date():
    """return a random birth year that gives an age between 19 and 80"""
    this_year = date.today().year
    year = random.randint(this_year-80, this_year-19)
    month = random.randint(1, 12)
    if month < 10:
        month = f'0{month}'
    day = random.randint(1, 28)
    if day < 10:
        day = f'0{day}'
    return f'{year}-{month}-{day}'

def random_social_security_number():
    """return a random social security number 123-12-1234"""
    part1 = random_digit_string(3)
    part2 = random_digit_string(2)
    part3 = random_digit_string(4)
    return f'{part1}-{part2}-{part3}'

def random_address():
    """return a random address '1234 name abc'"""
    part1 = random_digit_string(4)
    part2 = random_first_name()
    part3 = ['st', 'pl', 'ave']
    return f'{part1} {part2} {part3[random.randint(0,2)]}'

def random_gender():
    """return a random gender in gender_list"""
    gender_list = ['MALE', 'FEMALE', 'OTHER']
    random_number = random.randint(0,len(gender_list)-1)
    return gender_list[random_number]
