import sys
import os
import shutil

origin_dir=sys.argv[1]

new_dir_number=int(sys.argv[2])

new_dirs=[]
for i in range(new_dir_number):
    new_dirs.append(origin_dir+'_'+str(i))

for new_dir in new_dirs:
    os.makedirs(new_dir)
    os.makedirs(os.path.join(new_dir,'temp'))
    os.makedirs(os.path.join(new_dir,'logs'))

checkpoint_count=0

files=os.listdir(origin_dir)
for file in files:
    if file.startswith('model_step_'):
        ori_file=os.path.join(origin_dir,file)
        dist_file=os.path.join(new_dirs[checkpoint_count%new_dir_number],file)
        shutil.move(ori_file, dist_file)
        checkpoint_count+=1
