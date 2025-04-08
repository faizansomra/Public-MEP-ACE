FROM cp.icr.io/cp/appc/ace:12.0.12.8-r1@sha256:1edd0ca3949fee4df3016f8f142f9c8b64072191aa4bab3c421ca57cacbe8035
USER root
COPY *.bar /tmp
RUN export LICENSE=accept \
    && . /opt/ibm/ace-13/server/bin/mqsiprofile \
    && set -x && for FILE in /tmp/*.bar; do \
       echo "$FILE" >> /tmp/deploys && \
       ibmint package --compile-maps-and-schemas --input-bar-file "$FILE" --output-bar-file /tmp/temp.bar  2>&1 | tee -a /tmp/deploys && \
       ibmint deploy --input-bar-file /tmp/temp.bar --output-work-directory /home/aceuser/ace-server/ 2>&1 | tee -a /tmp/deploys; done \
    && ibmint optimize server --work-dir /home/aceuser/ace-server \
    && chmod -R ugo+rwx /home/aceuser/ \
    && chmod -R ugo+rwx /var/mqsi/

USER 1001