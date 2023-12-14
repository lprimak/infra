# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

INCLUDE payara.build
INCLUDE user.build

EXPOSE 4848 9009 8080 8181

RUN /usr/share/payara/bin/asadmin create-domain --nopassword default-domain

CMD ["sh", "-l", "-c", "asadmin start-domain -v"]
