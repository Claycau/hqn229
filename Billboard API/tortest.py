from BeautifulSoup import BeautifulSoup
import re, urllib, urllib2, sys, cookielib, time
from urllib2 import urlopen
from TorCtl import TorCtl
import telnetlib, socket

def newnym():
    tn = telnetlib.Telnet('localhost', 9051)
    tn.write(('AUTHENTICATE "test"\r\n'))
    res = tn.read_until('250 OK', 5)
    if res.find('250 OK') > -1:
       print('AUTHENICATE accepted.')
    tn.write("signal RELOAD\r\n")
    res = tn.read_until('250 OK', 5)
    if res.find('250 OK') > -1:
       print("Newnym successfull")

#s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#s.connect(('127.0.0.1', 9051))

url = 'http://www.whatismyip.org/'
proxy_support = urllib2.ProxyHandler({"http" : "127.0.0.1:8118"})
opener = urllib2.build_opener(proxy_support)
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
conn = TorCtl.connect()#s)

for i in range(10):    
    try:  
        response = opener.open(url)#, login_data)
    except urllib2.URLError:
        conn.sendAndRecv('signal newnym\r\n')
        time.sleep(5)
    html = response.read()
    soup = BeautifulSoup(html)
    print soup.prettify()
    conn.sendAndRecv('signal newnym\r\n') 
    #conn.send_signal("RESTART")
    newnym()
    time.sleep(10)
conn.close()

