def get_endpoint():
    f = open("main/dns.txt","r")
    lines = f.readlines()
    return lines[0].strip()

