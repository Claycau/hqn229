from StringIO import StringIO
import json
import httplib
from xml.dom.minidom import parse, parseString

def Country(country="spain", limit=50):
  url 		= "/2.0/?method=geo.gettoptracks&country="+country+"&limit="+str(limit)
  result 	= runQuery(url)
  return result['toptracks']['track']

def topTracks(limit=50):
  url 		= "/2.0/?method=chart.gettoptracks&limit="+str(limit)
  result 	= runQuery(url)
  return result['tracks']['track']

def topArtists(limit=50):
  url 		= "/2.0/?method=chart.gettopartists&limit="+str(limit)
  result 	= runQuery(url)
  return result['artists']['artist']

def listNames(lst):
  result = []
  for el in lst:
    result.append(el['name'])
  return result	

#Utility query function that does the http connect and includes the API key
def runQuery(url):
  h1 		= httplib.HTTPConnection('ws.audioscrobbler.com')
  h1.request("GET", url+"&format=json&api_key=bae442ce017c112c0da1afc503cc2d1f")
  response 	= h1.getresponse()
  data 		= response.read()
  io 		= StringIO(data)
  result 	= json.load(io)
  return result