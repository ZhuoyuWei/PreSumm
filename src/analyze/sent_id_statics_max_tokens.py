import sys
import json

id2count={}

with open(sys.argv[1],'r') as f:
    for line in f:
        jobj=json.loads(line.strip())
        labels=jobj['sent_labels']

        for label in labels:
            if not label in id2count:
                id2count[label]=0
            id2count[label]+=1


id_counts=sorted(id2count.items(),key=lambda x:x[0])
for id_count in id_counts:
    print('{}\t{}'.format(id_count[0],id_count[1]))

