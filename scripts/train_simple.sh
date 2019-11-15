#/bin/sh

BERT_DATA_PATH=/data/zhuoyu/summarization/cnndm_data/bert_data_cnndm_final/cnndm
BERT_OUTPUT_PATH=/data/zhuoyu/summarization/workspace/run_training_1

mkdir $BERT_OUTPUT_PATH
mkdir $BERT_OUTPUT_PATH/logs

python train.py -task ext -mode train -bert_data_path $BERT_DATA_PATH \
-ext_dropout 0.1 -model_path $BERT_OUTPUT_PATH \
-lr 2e-3 -visible_gpus 0,1,2 -report_every 50 -save_checkpoint_steps 1000 -batch_size 3000 -train_steps 50000 -accum_count 2 \
-log_file $BERT_OUTPUT_PATH/logs/ext_bert_cnndm -use_interval true -warmup_steps 10000 -max_pos 512