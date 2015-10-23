import sys,re,math
import xml.etree.ElementTree as ET # xml too big
try: import simplejson as json
except ImportError: import json


tree = ET.parse(sys.stdin)
root = tree.getroot()
for candidates in root.iter('activedata'):
   for doc in candidates.iter("doc"):
          url = doc.find('url').text.encode('utf-8')
          for ql in doc.iter("sublink"):
                 rank = ql.find('rank').text
                 anchor = ql.find("anchor").text
                 link = ql.find('link').text
                 sys.stdout.write("%s\t%s\t%s\t%s\n" % (url.encode('utf-8'),link.encode('utf-8'),anchor.encode('utf-8'),rank))

