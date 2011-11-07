from BeautifulSoup import BeautifulSoup, SoupStrainer
import re, urllib2, cookielib
#sample query = getYTKeys(['bad', 'romance'])
#result= qrO4YZeyl0I

def getYTKeys(keywords):
	cj = cookielib.CookieJar()
	opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
	login_data = urllib.urlencode({'username' : 'myname', 'password' : '123456'})
	resp = opener.open('http://www.example.com/signin.html', login_data)

	search = ''
	sz = len(keywords)
	for word in range(sz-1):
		search += keywords[word]
		search += '+'
	search+=keywords[sz-1]
	url = 'http://www.youtube.com/results?search_query='+search+'&aq=f'
	print url
	response = urllib2.urlopen(url)
	html = response.read()
	
	links = SoupStrainer('a', href=re.compile('watch'))
	links = [tag for tag in BeautifulSoup(html, parseOnlyThese=links)]
	top_hit = links[1]
	print top_hit['href']
	code = re.search('(?<==)\w+', top_hit['href'])
	print code.group(0)
