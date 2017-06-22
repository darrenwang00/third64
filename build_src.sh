#! /bin/bash

set -x


#sofa-rpc dep install
#https://github.com/baidu/sofa-pbrpc/wiki/%E6%9E%84%E5%BB%BA%E6%8C%87%E5%BC%95
#./configure --enable-share --prefix=/home/work/worksapce/project/third_party/protobuf
#./configure --enable-static --disable-shared 
#--prefix=/home/work/worksapce/project/third_party/protobuf


WORK_DIR=/root/Desktop/project/third_party

#./configure --enable-static --disable-shared --prefix=/home/wangyan/project/third_party/


function build_one()
{
	in_name=$1
	out_name=$2
	install_name=$3

	tar xzvf ${in_name}
	cd ${out_name}
	./configure --enable-static --disable-shared --prefix=$WORK_DIR/${install_name}
	make clean; make;
	make install
	cd -
	rm -rf  ./${out_name}
	return 0
}


#编译所有第三方库文件
function build_all()
{
	cd install

	#boost
	tar xzvf boost_1_53_0.tar.gz;
	rm -rf ${WORK_DIR}/boost; mkdir -p ${WORK_DIR}/boost/include
	cp -rf boost_1_53_0/boost  ${WORK_DIR}/boost/include
	rm -rf boost_1_53_0
	
	
	#hiredis
	tar xzvf hiredis.tar.gz; cd hiredis
	make clean;make; make install
	rm output/lib/*so*
	rm -rf output/lib/pkgconfig
	mv output ${WORK_DIR}/hiredis
	cd -; rm -rf hiredis
	
	#tinyxml2
	tar xzvf tinyxml2.tar.gz; cd tinyxml2
	bash build.sh
	mv output ${WORK_DIR}/tinyxml
	cd -; rm -rf tinyxml2

	#libevent + glog + snappy + protobuf
	build_one libevent-2.0.22.tar.gz libevent-2.0.22 libevent
	build_one glog-0.3.3.tar.gz glog-0.3.3 glog
	build_one snappy-1.1.1.tar.gz snappy-1.1.1 snappy
	build_one protobuf-2.4.1.tar.gz protobuf-2.4.1 protobuf
	build_one curl-7.50.3.tar.gz curl-7.50.3 curl

	#gflags
	tar xzvf gflags.tar.gz; 
	cd gflags; cmake  ./; make clean; make
	mkdir ${WORK_DIR}/gflags
	cp -rf include lib ${WORK_DIR}/gflags
	cd -; rm -rf gflags

	#jsoncpp
	tar xzvf jsoncpp-0.5.0.tar.gz; cd jsoncpp-0.5.0
	bash build.sh
	mv output/ $WORK_DIR/jsoncpp
	cd -; rm -rf jsoncpp-0.5.0
	
	#pcre
	tar xzvf pcre-8.38.tar.gz; cd pcre-8.38;
	./configure --enable-utf --enable-static --disable-shared --prefix=$WORK_DIR/pcre
	make clean; make; make install;
	cd - ; rm -rf pcre-8.38

	#zlib
	tar xzvf zlib-1.2.8.tar.gz; cd zlib-1.2.8;
	./configure --static --prefix=$WORK_DIR/zlib
	make clean; make; make install;
	cd - ; rm -rf zlib-1.2.8

	#ssdb
	tar xzvf ssdb-1.9.3.tar.gz
	mv ssdb-1.9.3/output ${WORK_DIR}/ssdb
	rm -rf ssdb-1.9.3

	#sofa rpc
	tar xzvf sofa-pbrpc.tar.gz; cd sofa-pbrpc
	make clean;make
	mv output ${WORK_DIR}/sofa-pbrpc
	cd -; rm -rf sofa-pbrpc


	#build_one zeromq-4.1.4.tar.gz  zeromq-4.1.4  zeromq
	return 0
}


build_all


