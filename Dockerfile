FROM centos:latest
RUN mkdir -p /document
WORKDIR /document
RUN yum install -y wget
RUN wget --no-check-certificate --no-cookies 
--header "Cookie: oraclelicense=accept-securebackup-cookie" 
http://download.oracle.com/otn-pub/java/jdk/
8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
RUN tar -zxvf jdk-8u121-linux-x64.tar.gz
ENV JAVA_HOME /document/jdk1.8.0_121
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
RUN curl -O http://mirror.bit.edu.cn/apache/cassandra/3.10/apache-cassandra-3.10-bin.tar.gz
RUN tar -zxvf apache-cassandra-3.10-bin.tar.gz
RUN sed -ri 's/(- seeds:).*/\1 "'"$(hostname --ip-address)"'"/' 
/document/apache-cassandra-3.10/conf/cassandra.yaml
RUN sed -i 's/^listen_address.*$/listen_address: '"$(hostname --ip-address)"'/' 
/document/apache-cassandra-3.10/conf/cassandra.yaml
RUN sed -ri 's/^(# )?(broadcast_rpc_address:).*/\2 '"$(hostname --ip-address)"'/' 
/document/apache-cassandra-3.10/conf/cassandra.yaml
EXPOSE 7000 7001 7199 9042 9160
CMD ["-R","-f"]
ENTRYPOINT ["/document/apache-cassandra-3.10/bin/cassandra"]
