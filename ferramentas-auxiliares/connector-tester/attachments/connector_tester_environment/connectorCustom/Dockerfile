FROM oob-connector-tester-native:latest

COPY --chown=1001:root ./routes.xml  /work/
COPY --chown=1001:root ./response-discovery.vm  /work/models/
COPY --chown=1001:root ./request.vm  /work/models/
COPY --chown=1001:root ./response.vm  /work/models/
COPY --chown=1001:root ./request-revoke.vm  /work/models/
COPY --chown=1001:root ./response-check-payment.vm  /work/models/
COPY --chown=1001:root ./response-revoke.vm  /work/models/
COPY --chown=1001:root ./response-error-example.json /work/error/
COPY --chown=1001:root ./response-error-approvePaymentConsentCreation.json /work/error/

ARG routes=file:/work/routes.xml
ENV camel.main.routes-include-pattern=$routes