#!/bin/sh

git clone https://github.com/flowlogix/flowlogix
mvn -f flowlogix -Dwebdriver.gecko.driver=/usr/bin/geckodriver \
	-Dwebdriver.browser=firefox \
	-Pui-test verify -DskipTests -DskipITs
