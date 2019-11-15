#/bin/sh

WORDDIR=/data/zhuoyu/summarization

CUDA_VISIBLE_DEVICES=5 python $WORDDIR/code/bertsum/PreSumm/src/train.py -task ext -mode validate -batch_size 3000 -test_batch_size 3000 \
-bert_data_path $WORDDIR/cnndm_data/bert_data_cnndm_final/cnndm \
-log_file $WORDDIR/workspace/run_baseline1/logs/log \
-model_path $WORDDIR/models/bertsum/trained_official \
-sep_optim true -use_interval true -visible_gpus 1 \
-max_pos 512 -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $WORDDIR/workspace/run_baseline2/logs/exp_bert_cnndm.res \
-test_all true



python train.py -mode validate \
-bert_data_path ../bert_data/cnndm \
-model_path MODEL_PATH  \
-visible_gpus 0  \
-gpu_ranks 0 \
-batch_size 30000  \
-log_file LOG_FILE  \
-result_path RESULT_PATH \
-test_all \
-block_trigram true