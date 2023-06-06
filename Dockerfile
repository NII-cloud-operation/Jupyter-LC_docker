# base-demo 2023-06-02
FROM niicloudoperation/notebook@sha256:128f7726dcfbee7bcee7d414067a280d434ce05b88fad969ffde84ce23c94df9

USER root

COPY conf/99-run-supervisor.sh /usr/local/bin/before-notebook.d/99-run-supervisor.sh
COPY conf/supervisor-jovyan.conf /home/jovyan/.nbsearch/supervisor.conf
COPY conf/supervisor-root.conf /home/jovyan/.nbsearch/supervisor-root.conf
COPY conf/init-script.sh /home/jovyan/.nbsearch/init-script.sh
ADD sample-notebooks /home/$NB_USER
RUN chmod +x /usr/local/bin/before-notebook.d/99-run-supervisor.sh && \
    chmod +x /home/jovyan/.nbsearch/init-script.sh && \
    fix-permissions /home/$NB_USER

USER $NB_USER
