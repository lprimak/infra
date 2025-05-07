#!/bin/sh

echo "Cloning repository"
git clone -q https://github.com/flowlogix/flowlogix
echo "Extracting Dependencies"
JAVA_TOOL_OPTIONS="--sun-misc-unsafe-memory-access=allow" mvn -B -ntp -q -f flowlogix dependency:go-offline
echo "Packaging repo"
tar zcf /var/build/repo.tar.gz -C .m2 repository
