FROM 618430153747.dkr.ecr.sa-east-1.amazonaws.com/opus-open-banking-release/oob-open-data:1.0.0.76e303c

COPY --chown=1001:root ./mock-routes.xml  /work/routes/

ARG routes=file:/work/routes/mock-routes.xml
ENV camel.main.routes-include-pattern=$routes
