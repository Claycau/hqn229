from BeautifulSoup import BeautifulSoup
import re, urllib, urllib2, sys, cookielib, time
from urllib2 import urlopen
from TorCtl import TorCtl

def Scrape(url):
	#cj = cookielib.CookieJar()
	conn = TorCtl.connect()
	proxy_support = urllib2.ProxyHandler({"http" : "127.0.0.1:8118"})
	opener = urllib2.build_opener(proxy_support)#, urllib2.HTTPCookieProcessor(cj))
	opener.addheaders = [('User-agent', 'Mozilla/5.0')]#, ('Cookie', 'PHPSESSID=aa8bddbd8acb8c6bd1642e35675f446f')]
	#login_data = urllib.urlencode({'username' : 'screenname', 'password' : '123456'})
	try: 
		response = opener.open(url)#, login_data)
	except urllib2.URLError:
		conn.sendAndRecv('signal newnym\r\n')
		conn.close()
		time.sleep(5)
		return url
	#print response.info()
	
	
	date = re.search('(?<==)[0-9-]+', url)
	date = date.group(0)
	
	html = response.read()
	
	soup = BeautifulSoup(html)
	#print soup.prettify()
	table = soup.find('table', width="900", align="center", bgcolor="white" )
	body = None
	try: 
		body = table.find('tbody')
	except AttributeError:
		conn.sendAndRecv('signal newnym\r\n')
		conn.close()
		time.sleep(5)
		return url
	try: 
		next = table.findAll('a')[1]
	except IndexError:
		conn.sendAndRecv('signal newnym\r\n')
		conn.close()
		time.sleep(5)
		return url
	new_url = 'http://www.song-database.com/charts.php' + next['href'] 
		
	try: 
		trs = body.findAll('tr')
	except AttributeError:
		conn.sendAndRecv('signal newnym\r\n')
		conn.close()
		time.sleep(5)
		return url
	
	f = open('/Users/empty/Documents/hqn229/BillboardList2001-2011.txt','a')
	for tr in trs:
		tds = tr.findAll('td')
		rank  =  tds[1].contents[0].contents[0].contents[0]
		song =   tds[3].contents[0].contents[0]
		artist = tds[4].contents[0].contents[0]
		genre =  tds[5].contents[0].contents[0]
		line =  date + '|' + rank + '|' + song + '|' + artist + '|' + genre + '\n'
		f.write(line)
	f.close()
	
	
	return new_url
	