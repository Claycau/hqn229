from BeautifulSoup import BeautifulSoup, SoupStrainer
import re, urllib2
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
	print url
	response = urllib2.urlopen(url)
	html = response.read()
	
	links = SoupStrainer('a', href=re.compile('watch'))
	links = [tag for tag in BeautifulSoup(html, parseOnlyThese=links)]
	top_hit = links[1]
	print top_hit['href']
	code = re.search('(?<==)\w+', top_hit['href'])
	print code.group(0)
