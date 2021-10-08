FROM 618430153747.dkr.ecr.sa-east-1.amazonaws.com/digital-banking-microservices/oob-connector-tester:latest

COPY --chown=1001:root ./routes.xml  /work/
COPY --chown=1001:root ./request.vm  /work/models/
COPY --chown=1001:root ./response.vm  /work/models/
COPY --chown=1001:root ./response-error-example.json /work/error/

ARG routes=file:/work/routes.xml
ENV camel.main.routes-include-pattern=$routes