FROM 430153747.dkr.ecr.sa-east-1.amazonaws.com/opus-open-banking-release/oob-connector-tester:latest

COPY --chown=1001:root ./routes.xml  /work/
COPY --chown=1001:root ./response-discovery.vm  /work/models/
COPY --chown=1001:root ./request-pix.vm  /work/models/
COPY --chown=1001:root ./response-pix.vm  /work/models/
COPY --chown=1001:root ./request-ted-tef.vm  /work/models/
COPY --chown=1001:root ./response-ted-tef.vm  /work/models/
COPY --chown=1001:root ./request-revoke.vm  /work/models/
COPY --chown=1001:root ./response-check-payment.vm  /work/models/
COPY --chown=1001:root ./response-revoke.vm  /work/models/
COPY --chown=1001:root ./response-error-example.json /work/error/
COPY --chown=1001:root ./response-error-approvePaymentConsentCreation.json /work/error/

ARG routes=file:/work/routes.xml
ENV camel.main.routes-include-pattern=$routes