FROM 618430153747.dkr.ecr.sa-east-1.amazonaws.com/opus-open-banking-release/oob-connector-tester:latest

COPY --chown=1001:root ./specs/payment-routes.xml /work/
COPY --chown=1001:root ./payments /work/payment
COPY --chown=1001:root ./specs/account-routes.xml /work/
COPY --chown=1001:root ./accounts /work/account

ARG routes=file:/work/payment-routes.xml,file:/work/account-routes.xml
ENV camel.main.routes-include-pattern=$routes