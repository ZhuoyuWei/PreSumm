#!/bin/sh

BERT_DATA_PATH=/data/zhuoyu/summarization/cnndm_data/bert_data_cnndm_final
BERT_OUTPUT_PATH=/data/zhuoyu/summarization/cnndm_data/bert_data_cnndm_final_out
MODEL_DIR=/data/zhuoyu/summarization/models/bertbase

python train.py -task ext -mode train -bert_data_path $BERT_DATA_PATH \
-ext_dropout 0.1 -model_path $BERT_OUTPUT_PATH \
-lr 2e-3 -visible_gpus 0,1,2,3 -report_every 50 -save_checkpoint_steps 1000 -batch_size 2000 -train_steps 50000 -accum_count 2 \
-log_file $BERT_OUTPUT_PATH/logs/train.log -use_interval true -warmup_steps 10000 -max_pos 512 -dist_init_method "tcp://localhost:10003" \
-model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=64 -encoder=baseline

