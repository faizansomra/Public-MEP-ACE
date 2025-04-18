FROM cp.icr.io/cp/appc/ace:12.0.12.0-r1@sha256:33000e4b20570524c44203ba32b047cb752d3935fcd6dfa8b94ee862f75993aa
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
