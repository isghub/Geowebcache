FROM tomcat:8.5-jre8

ENV GWC_VERSION=1.15.4
ARG GWC_ARCHIVE_FILENAME=geowebcache-${GWC_VERSION}-war.zip
ARG GWC_URL=https://sourceforge.net/projects/geowebcache/files/geowebcache/${GWC_VERSION}/${GWC_ARCHIVE_FILENAME}
# for correct cpu/memory detection inside a container
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

#Configure and install geowebcache

RUN wget -O /tmp/geowebcache.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/1.15.4/geowebcache-1.15.4-war.zip/download     && unzip /tmp/geowebcache.zip -d /tmp/     && unzip /tmp/geowebcache.war -d /opt/geowebcache     && rm /tmp/geowebcache.zip && rm /tmp/geowebcache.war

ADD geowebcache_context.xml /usr/local/tomcat/conf/Catalina/localhost/geowebcache.xml
RUN mkdir /config && chmod a+rw /config     && sed -i.bak "1,20 s/<constructor-arg ref=\"gwcDefaultStorageFinder\" \/>/<constructor-arg value=\"\/config\" \/>/g" /opt/geowebcache/WEB-INF/geowebcache-core-context.xml

# SET CACHE_DIR

RUN mkdir /data/Geowebcache && chmod a+rw /data/Geowebcache
ENV GEOWEBCACHE_CACHE_DIR /data/Geowebcache
VOLUME /data/Geowebcache

EXPOSE 8080
