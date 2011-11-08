import time
#use this for billboard scraping

from BillboardScraper import Scrape

url = 'http://www.song-database.com/charts.php?wk=2008-09-13&type=ht'
for i in range(52*10):
    print url
    url = Scrape(url)
   
