RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
COPY exports/maven-3.tar.gz /tmp/
COPY exports/maven-4.tar.gz /tmp/
RUN tar zxf /tmp/maven-3.tar.gz -C /usr/share && rm -f /tmp/maven-3.tar.gz
RUN tar zxf /tmp/maven-4.tar.gz -C /usr/share && rm -f /tmp/maven-4.tar.gz
ENV MAVEN_HOME /usr/share/maven