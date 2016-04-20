ls
cd spark-1.4.1-bin-hadoop2.6/
ls
ls
python examples/src/main/python/wordcount.py 
bin/pyspark examples/src/main/python/wordcount.py 
cd ..
touch file.txt
vi file.txt 
spark-1.4.1-bin-hadoop2.6/bin/pyspark spark-1.4.1-bin-hadoop2.6/examples/src/main/python/wordcount.py file.txt 
$PYTHONPATH
env
export SPARK_HOME=/home/sense/spark-1.4.1-bin-hadoop2.6
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH
pwd
python spark-1.4.1-bin-hadoop2.6/examples/src/main/python/wordcount.py file.txt 
export SPARK_HOME=/home/sense/spark-1.4.1-bin-hadoop2.6
exit
cd spark-1.4.1-bin-hadoop2.6/
ls
cd sbin/
ls
./start-master.sh 
./stop-master.sh 
./start-master.sh -c 8
./start-master.sh -c 8
./start-master.sh -c 4
ls
cd ..
cd conf/
ls
more spark-defaults.conf.template 
cd ../
ls
cd sbin/
ls
./start-master.sh 
./stop-master.sh 
./start-master.sh -c 2
./start-master.sh
./start-slave.sh
./start-slave.sh spark://localhost:7077
./stop-slave.sh 
./start-slave.sh spark://localhost:7077 -c 4
./stop-slave.sh 
./stop-master.sh 
exit
