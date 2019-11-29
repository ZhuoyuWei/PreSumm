import sys
import json

max_position_embeddings=int(sys.argv[3])

with open(sys.argv[1]) as f:
    jobj=json.load(f)

jobj["max_position_embeddings"]=max_position_embeddings

with open(sys.argv[2],'w') as fout:
    json.dump(jobj,fout)

