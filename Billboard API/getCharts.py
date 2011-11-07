from StringIO import StringIO
import json
import httplib

def ChartsByID(id):
  h1 = httplib.HTTPConnection('api.billboard.com')
  h1.request("GET", "/apisvc/chart/v1/list/spec?name=The%20Billboard%20Hot%20100&type=singles&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
  #h1.request("GET", "/apisvc/chart/v1/item?id="+ str(id) +"&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
  r1 = h1.getresponse()
  data = r1.read()
  io = StringIO(data)
  if io != None:
  	try: 
  		l = json.load(io)
  	except ValueError:
  		return
  	print('Chart id is')
  	print(l)


"""

#h1.request("GET", "/apisvc/chart/v1/list/spec?name=The%20Billboard%20Hot%20100&type=singles&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
#h1.request("GET", "/apisvc/chart/v1/list?format=json&api_key=j8mmrazyy376se4bmhc8t5xx")

h1.request("GET", "/apisvc/chart/v1/list?format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
#h1.request("GET", "/apisvc/chart/v1/list/spec?type=singles&name=Billboard&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
r1 = h1.getresponse()
data = r1.read()
io = StringIO(data)
l = json.load(io)
print(l)
"""
