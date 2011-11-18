from BeautifulSoup import BeautifulSoup, SoupStrainer
import re, urllib2, cookielib
#sample query = getYTKeys(['bad', 'romance'])
#result= qrO4YZeyl0I

def getYTKeys(keywords):
	search = ''
	sz = len(keywords)
	for word in range(sz-1):
		search += keywords[word]
		search += '+'
	search+=keywords[sz-1]
	url = 'http://www.youtube.com/results?search_query='+search+'&aq=f'
	try:
		response = urllib2.urlopen(url)
	except urllib2.HTTPError:
		print "url error " + url
		return 'NaN'
	html = response.read()
	
	links = SoupStrainer('a', href=re.compile('/watch'))
	links = [tag for tag in BeautifulSoup(html, parseOnlyThese=links)]
	try:
		top_hit = links[1]
	except IndexError:
		print "index error" + url
		return 'NaN'
	code = re.search('(?<==)[a-zA-Z0-9\_-]+', top_hit['href'])
	if code.group(0)=='http': print "There was a strange search:" + url
	#this means that the search thinks the query was spelled ve
	return code.group(0)
