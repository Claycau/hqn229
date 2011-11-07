from BeautifulSoup import BeautifulSoup, SoupStrainer
import re, urllib2

def Scrape(url):
	response = urllib2.urlopen(url)
	html = response.read()
	<table cellpadding='2' width='900' align='center' bgcolor='white'
	soup = BeautifulSoup(html)
	link_table = soup.find('table', width="900", align="center", bgcolor="white" )
	print link_table
	return None