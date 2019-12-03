import sys
import codecs
import json
import os

max_sents=0
max_tokens=0

count_0_512=0
count_512_1024=0
count_1024_=0

data_dir=sys.argv[1]
files=os.listdir(data_dir)

output_dir=sys.argv[2]
if not os.path.exists(output_dir):
    os.makedirs(output_dir)
os.makedirs(os.path.join(output_dir,'short'))
os.makedirs(os.path.join(output_dir,'long'))
os.makedirs(os.path.join(output_dir,'very_long'))



for file in files:
    with codecs.open(os.path.join(data_dir,file), 'r', 'utf-8') as f:
        jobjs_short=[]
        jobjs_long=[]
        jobjs_very_long=[]
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

            if tokens_num < 512:
                count_0_512 += 1
                jobjs_short.append(jobj)
            elif tokens_num < 1024:
                count_512_1024 += 1
                jobjs_long.append(jobj)
            else:
                count_1024_ += 1
                jobjs_very_long.append(jobj)

    with codecs.open(os.path.join(output_dir,'short',file),'w','utf-8') as fout:
        jstr=json.dumps(jobjs_short,ensure_ascii=False)
        fout.write(jstr)

    with codecs.open(os.path.join(output_dir,'long',file),'w','utf-8') as fout:
        jstr=json.dumps(jobjs_long,ensure_ascii=False)
        fout.write(jstr)

    with codecs.open(os.path.join(output_dir,'very_long',file),'w','utf-8') as fout:
        jstr=json.dumps(jobjs_very_long,ensure_ascii=False)
        fout.write(jstr)




print('0-512: {}'.format(count_0_512))
print('512-1024: {}'.format(count_512_1024))
print('1024-: {}'.format(count_1024_))

print('max sents: {}, max tokens {}'.format(max_sents,max_tokens))
