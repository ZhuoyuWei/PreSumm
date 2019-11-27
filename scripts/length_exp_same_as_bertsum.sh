#!/bin/sh

EXP_ID=$1
EXP_MODEL_NAME=$2

MAX_POS=$3
MAX_MODEL_POS=$4

WDATA_DIR=/data/zhuoyu/summarization/wdata
OUTPUT_DIR=$WDATA_DIR/$EXP_ID
mkdir $OUTPUT_DIR

sudo apt-get install zip -y

sudo mkdir /zhuoyu_exp/
sudo chmod 777 /zhuoyu_exp

EXP_ROOT_DIR=/zhuoyu_exp/work
mkdir $EXP_ROOT_DIR
cp install_pyrouge.sh $EXP_ROOT_DIR/
cd $EXP_ROOT_DIR


#install pyrouge
install_rouge=true
if $install_rouge;
then
sh install_pyrouge.sh $EXP_ROOT_DIR
fi

#copy data
DATA_DIR=$EXP_ROOT_DIR/data
mkdir $DATA_DIR
cp /data/zhuoyu/summarization/cnndm_data/bertsum.zip $DATA_DIR/
cd $DATA_DIR
unzip bertsum.zip
cd ..
CNNDM_DATA_DIR=$DATA_DIR/bert_data_cnndm_final


#download code and install requirements
mkdir code
cd code
git clone https://github.com/ZhuoyuWei/PreSumm.git
cd PreSumm
sudo pip install -r requirements.txt
cd ../..

#copy pretrained model
MODEL_DIR=$EXP_ROOT_DIR/models
mkdir $MODEL_DIR
cp /data/zhuoyu/summarization/models/bertbase/pytorch_model.bin $MODEL_DIR/
cp /data/zhuoyu/summarization/models/bertbase/vocab.txt  $MODEL_DIR/
cp /data/zhuoyu/summarization/models/bertbase/config.$EXP_MODEL_NAME.json $MODEL_DIR/config.json

#run training
BERT_OUTPUT_PATH=$OUTPUT_DIR/model_exp_output
mkdir $BERT_OUTPUT_PATH
mkdir $BERT_OUTPUT_PATH/logs
BERT_DATA_PATH=$CNNDM_DATA_DIR/cnndm

cd code/PreSumm/src
python train.py -task ext -mode train -bert_data_path $BERT_DATA_PATH \
-ext_dropout 0.1 -model_path $BERT_OUTPUT_PATH \
-lr 2e-3 -visible_gpus 0,1,2,3 -report_every 50 -save_checkpoint_steps 1000 -batch_size 2000 -train_steps 50000 -accum_count 2 \
-log_file $BERT_OUTPUT_PATH/logs/train.log -use_interval true -warmup_steps 10000 -max_pos $MAX_POS -dist_init_method "tcp://localhost:10003" \
-model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=$MAX_MODEL_POS -encoder=baseline
cd ../../..

#split checkpoints into 4

cd code/PreSumm/src/post
python split_checkpoints_dir_for_evaluate.py $BERT_OUTPUT_PATH 4
BERT_OUTPUT_PATH0=$BERT_OUTPUT_PATH"_0"
BERT_OUTPUT_PATH1=$BERT_OUTPUT_PATH"_1"
BERT_OUTPUT_PATH2=$BERT_OUTPUT_PATH"_2"
BERT_OUTPUT_PATH3=$BERT_OUTPUT_PATH"_3"
cd ../../../..


#run validation 0
ROUGE_TEMP_DIR0=$BERT_OUTPUT_PATH0/temp
mkdir $ROUGE_TEMP_DIR0
cd code/PreSumm/src
python train.py -task ext -mode validate -batch_size 2000 -test_batch_size 2000 \
-bert_data_path $BERT_DATA_PATH \
-log_file $BERT_OUTPUT_PATH0/logs/valid.log \
-model_path $BERT_OUTPUT_PATH0 \
-sep_optim true -use_interval true -visible_gpus 0 \
-max_pos $MAX_POS -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $BERT_OUTPUT_PATH0/logs/exp_bert_cnndm.res \
-test_all true -model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=$MAX_MODEL_POS -temp_dir=$ROUGE_TEMP_DIR0 -encoder=baseline &>  $BERT_OUTPUT_PATH0/logs/running.log &
cd ../../..

#run validation 1
ROUGE_TEMP_DIR1=$BERT_OUTPUT_PATH1/temp
mkdir $ROUGE_TEMP_DIR1
cd code/PreSumm/src
python train.py -task ext -mode validate -batch_size 2000 -test_batch_size 2000 \
-bert_data_path $BERT_DATA_PATH \
-log_file $BERT_OUTPUT_PATH1/logs/valid.log \
-model_path $BERT_OUTPUT_PATH1 \
-sep_optim true -use_interval true -visible_gpus 1 \
-max_pos $MAX_POS -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $BERT_OUTPUT_PATH1/logs/exp_bert_cnndm.res \
-test_all true -model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=$MAX_MODEL_POS -temp_dir=$ROUGE_TEMP_DIR1 -encoder=baseline &>  $BERT_OUTPUT_PATH1/logs/running.log &
cd ../../..

#run validation 2
ROUGE_TEMP_DIR2=$BERT_OUTPUT_PATH2/temp
mkdir $ROUGE_TEMP_DIR2
cd code/PreSumm/src
python train.py -task ext -mode validate -batch_size 2000 -test_batch_size 2000 \
-bert_data_path $BERT_DATA_PATH \
-log_file $BERT_OUTPUT_PATH2/logs/valid.log \
-model_path $BERT_OUTPUT_PATH2 \
-sep_optim true -use_interval true -visible_gpus 2 \
-max_pos $MAX_POS -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $BERT_OUTPUT_PATH2/logs/exp_bert_cnndm.res \
-test_all true -model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=$MAX_MODEL_POS -temp_dir=$ROUGE_TEMP_DIR2 -encoder=baseline &>  $BERT_OUTPUT_PATH2/logs/running.log &
cd ../../..

#run validation 3
ROUGE_TEMP_DIR3=$BERT_OUTPUT_PATH3/temp
mkdir $ROUGE_TEMP_DIR3
cd code/PreSumm/src
python train.py -task ext -mode validate -batch_size 2000 -test_batch_size 2000 \
-bert_data_path $BERT_DATA_PATH \
-log_file $BERT_OUTPUT_PATH3/logs/valid.log \
-model_path $BERT_OUTPUT_PATH3 \
-sep_optim true -use_interval true -visible_gpus 3 \
-max_pos $MAX_POS -max_length 200 -alpha 0.95 -min_length 50 \
-result_path $BERT_OUTPUT_PATH3/logs/exp_bert_cnndm.res \
-test_all true -model_name bert_lstm -pretrained_name $MODEL_DIR -max_model_pos=$MAX_MODEL_POS -temp_dir=$ROUGE_TEMP_DIR3 -encoder=baseline &>  $BERT_OUTPUT_PATH3/logs/running.log
cd ../../..

sleep 5m

#report results
echo all result finish?



