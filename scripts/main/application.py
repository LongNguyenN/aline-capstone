"""
Generate random application data.
variables:
	- None
methods:
	- random_type() -> a random application type
	- random_status() -> a random applicationn status
"""
import random
import requests
from main.applicant import Applicant
from main.user import random_type
from main.get_endpoint import get_endpoint

class Application():
    """
    variables:

    methods:

    """
    def post_application(self):
        """Make this application with a post request"""
        url = get_endpoint() + ':8071/applications'
        headers = {
            'accept': '*/*',
            'Content-Type':'application/json'
        }
        data = self.get_data()
        response = requests.post(url, json=data, headers=headers, timeout=10)
        #print(f'request: {data}')
        #print(f'response: {response.text}')
        self.application_id = response.json()['id']
        self.account_number = response.json()['createdAccounts'][0]['accountNumber']
        self.membership_id = response.json()['createdMembers'][0]['membershipId']
        self.status = response.json()['status']
        return response

    def get_data(self):
        """return data for a get request"""
        applicant = self.applicant
        data = {
	        "applicationType": self.application_type,
	        "applicants": [
	          applicant.my_information()
	        ]
	      }
        return data

    def __init__(self):
        self.application_id = -1
        self.account_number = -1
        self.membership_id = -1
        self.status = 'None'
        self.application_type = random_type()
        self.application_amount = random.randint(1, 10000)
        self.applicant = Applicant()
