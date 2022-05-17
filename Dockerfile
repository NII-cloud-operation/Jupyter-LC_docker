FROM niicloudoperation/notebook:base-demo

USER root

COPY conf/99-run-supervisor.sh /usr/local/bin/before-notebook.d/99-run-supervisor.sh
ADD sample-notebooks /home/$NB_USER
RUN chmod +x /usr/local/bin/before-notebook.d/99-run-supervisor.sh && \
    fix-permissions /home/$NB_USER

USER $NB_USER
