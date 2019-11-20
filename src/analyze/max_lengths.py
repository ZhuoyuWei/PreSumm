import sys
import codecs
import json

max_sents=0
max_tokens=0
with codecs.open(sys.argv[1],'r','utf-8') as f:
    jobjs = json.load(f)
    for jobj in jobjs:
        sents = jobj['src']
        if len(sents) > max_sents:
            max_sents = len(sents)
        tokens_num = 0
        for sent in sents:
            tokens_num += len(sent)
        if tokens_num > max_tokens:
            max_tokens = tokens_num




print('max sents: {}, max tokens {}'.format(max_sents,max_tokens))
