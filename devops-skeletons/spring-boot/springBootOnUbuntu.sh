#!/usr/bin/env bash

if [ "$1" == "stage" ] || [ "$1" == "preprod" ] ||[ "$1" == "prod" ]; then

	# Remote: support components
	apt-get update && \
	apt-get install -y software-properties-common && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists

	# Remote: Java8
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	apt-get install -y oracle-java8-installer && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer

	# Remote: Folders
	mkdir /root/preparation
	mkdir /root/app

	# Remote: JAR-as-service
	cp /root/spring-boot/app.service /etc/systemd/system
	cp /root/spring-boot/env-$1 /etc/default/appConfiguration
	systemctl enable app.service

	# Remote: Cleanup
	cd /root
	rm -rf spring-boot

else
	echo "Available profiles: stage | preprod | prod"
fi
