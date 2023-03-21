import requests
from main.application import Application

def test_Application():
    app = Application()
    response = app.post_application()
    print(response.text)
    assert response.status_code == 201
