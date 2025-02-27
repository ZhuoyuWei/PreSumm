#/bin/sh

cd ../src

BERT_DATA_PATH=/data/zhuoyu/summarization/cnndm_data/bert_data_cnndm_final/cnndm
BERT_OUTPUT_PATH=/data/zhuoyu/summarization/workspace/run_training_5

mkdir $BERT_OUTPUT_PATH
mkdir $BERT_OUTPUT_PATH/logs

python train.py -task ext -mode train -bert_data_path $BERT_DATA_PATH \
-ext_dropout 0.1 -model_path $BERT_OUTPUT_PATH \
-lr 2e-3 -visible_gpus 0,1,2,3,4,5,6,7 -report_every 50 -save_checkpoint_steps 2000 -batch_size 2000 -train_steps 50000 -accum_count 2 \
-log_file $BERT_OUTPUT_PATH/logs/ext_bert_cnndm -use_interval true -warmup_steps 10000 -max_pos 512 -dist_init_method "tcp://localhost:10003" \
-model_name bert_lstm -pretrained_name /data/zhuoyu/summarization/models/bertbase -max_model_pos=128

WORDDIR=/data/zhuoyu/summarization

CUDA_VISIBLE_DEVICES=1 python train.py -task ext -mode validate -batch_size 2000 -test_batch_size 2000 \
-bert_data_path $BERT_DATA_PATH \
-log_file $BERT_OUTPUT_PATH/logs/ext_bert_cnndm.evaluate \
-model_path $BERT_OUTPUT_PATH \
-sep_optim true -use_interval true -visible_gpus 1 \
-max_pos 512 -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $BERT_OUTPUT_PATH/logs/exp_bert_cnndm.res \
-test_all true -model_name bert_lstm -pretrained_name /data/zhuoyu/summarization/models/bertbase -max_model_pos=128  -report_rouge=False