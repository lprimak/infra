# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

INCLUDE payara.build
INCLUDE user.build

RUN asadmin create-domain --nopassword default-domain

CMD ["sh", "-l", "-c", "asadmin", "start-domain", "-v"]
