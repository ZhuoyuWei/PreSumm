#!/bin/sh

EXP_ROOT_DIR=$1

cp -r /work/ROUGE_tars $EXP_ROOT_DIR/
cd $EXP_ROOT_DIR
mv ROUGE_tars ROUGE
cd ROUGE

tar -zxvf ROUGE-1.5.5.tgz

tar -zxvf XML-Parser-2.44.tar.gz
cd XML-Parser-2.44
perl Makefile.PL
make
make test
sudo make install
cd ..

tar -zxvf XML-RegExp-0.04.tar.gz
cd XML-RegExp-0.04
perl Makefile.PL
make
make test
sudo make install
cd ..


sudo apt-get update -y
sudo apt-get install libwww-perl -y
sudo apt-get install libxml-perl -y


tar -zxvf XML-DOM-1.46.tar.gz
cd XML-DOM-1.46
perl Makefile.PL
make
make test
sudo make install
cd ..

sudo apt-get install libdb-dev -y

tar -zxvf DB_File-1.835.tar.gz
cd DB_File-1.835
perl Makefile.PL
make
make test
sudo make install
cd ..

export ROUGE_EVAL_HOME=$EXP_ROOT_DIR/ROUGE/RELEASE-1.5.5/data

sudo pip install pyrouge
pyrouge_set_rouge_path $EXP_ROOT_DIR/ROUGE/RELEASE-1.5.5