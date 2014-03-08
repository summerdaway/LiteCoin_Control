import paramiko

'''
class HelperSSH:
  def __init__(self, ip, port=22, username, password, timeout=4):
    self.ip = ip
    self.port = port
    self.username = username
    self.password = password
    self.timeout = timeout
  
  def connect(self):
    self.client = paramiko.SSHClient()
    self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    self.client.connect(ip, port, username="%s"%(username), password="%s"%(password), timeout=4)
'''  
def kill_on(machine):
  client = paramiko.SSHClient()
  client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  client.connect('10.1.0.%d'%(machine), 22, username='root', password='root', timeout=4)
  stdin, stdout, stderr = client.exec_command('killall minerd')
  for std in stderr.readlines():
    print std, 
  client.close()

if __name__ == '__main__':
  machine = 5
  client = paramiko.SSHClient()
  client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  client.connect('10.1.0.%d'%(machine), 22, username='root', password='root', timeout=4)
  stdin, stdout, stderr = client.exec_command('killall minerd')
  for std in stderr.readlines():
    print std, 
  client.close()
