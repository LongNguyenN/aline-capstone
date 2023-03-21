from main.applicant import Applicant

def test_Applicant():
    app = Applicant()
    assert app.applicant_id == -1
    first_name = app.first_name
    middle_initial = app.middle_name[0]
    last_name = app.last_name
    email = f'{first_name}.{middle_initial}.{last_name}@smoothstack.com'
    assert app.generate_email() == email
