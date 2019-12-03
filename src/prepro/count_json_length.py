import sys
import codecs
import json

with codecs.open(sys.argv[1],'r','utf-8') as f:
    jobj=json.load(f)
    print(len(jobj))