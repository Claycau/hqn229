from StringIO import StringIO
import json
import httplib

h1 = httplib.HTTPConnection('api.billboard.com')
""""
h1.request("GET", "/apisvc/chart/v1/item?id=3102416&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
r1 = h1.getresponse()
data = r1.read()
io = StringIO(data)
l = json.load(io)
print('Chart id is')
print(l['chart']['id'])
"""

#h1.request("GET", "/apisvc/chart/v1/list/spec?name=Billboard&type=singles&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
#h1.request("GET", "/apisvc/chart/v1/list?format=json&api_key=j8mmrazyy376se4bmhc8t5xx")

h1.request("GET", "/apisvc/chart/v1/list?id=411&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
#h1.request("GET", "/apisvc/chart/v1/list/spec?type=singles&name=Billboard&format=json&api_key=j8mmrazyy376se4bmhc8t5xx")
r1 = h1.getresponse()
data = r1.read()
io = StringIO(data)
l = json.load(io)
print(l)