FROM centos:latest
#指定基础镜像
RUN mkdir -p /document
#在Docker的文件系统根目录下建立/document文件夹
WORKDIR /document
#指定工作目录，相当于cd命令
RUN yum install -y wget
#安装wget
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
#从Oracle官网下载java_jdk，前面是HTTP头用于通过验证
RUN tar -zxvf jdk-8u121-linux-x64.tar.gz
#解包，默认文件夹名为jdk1.8.0_121
ENV JAVA_HOME /document/jdk1.8.0_121
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#设置环境变量
RUN curl -O http://mirror.bit.edu.cn/apache/cassandra/3.10/apache-cassandra-3.10-bin.tar.gz
#从Cassandra官网下载Cassandra包
RUN tar -zxvf apache-cassandra-3.10-bin.tar.gz
#解包，默认文件夹名为apache-cassandra-3.10
#RUN mkdir -p /var/lib/cassandra
#RUN mkdir -p /var/log/Cassandra
#创建相关目录，暂时不需要
RUN sed -ri 's/(- seeds:).*/\1 "'"$(hostname --ip-address)"'"/' /document/apache-cassandra-3.10/conf/cassandra.yaml
#修改并添加seeds，IP地址为docker的bridge模式网络地址
RUN sed -i 's/^listen_address.*$/listen_address: '"$(hostname --ip-address)"'/' /document/apache-cassandra-3.10/conf/cassandra.yaml
#修改listen_address ， IP地址同上
RUN sed -i 's/^rpc_address.*$/rpc_address: 0.0.0.0/' /document/apache-cassandra-3.10/conf/cassandra.yaml
#修改rpc_address，IP为全局地址0.0.0.0
RUN sed -ri 's/^(# )?(broadcast_rpc_address:).*/\2 '"$(hostname --ip-address)"'/' /document/apache-cassandra-3.10/conf/cassandra.yaml
#修改broadcast_rpc_address，IP地址为docker的bridge模式网络地址
EXPOSE 7000 7001 7199 9042 9160
#暴露Cassandra默认可能用的全部5个端口
CMD ["-R","-f"]
#为ENTRYPOINT设置命令参数
ENTRYPOINT ["/document/apache-cassandra-3.10/bin/cassandra"]
#指定container运行时的启动目录
