FROM niicloudoperation/notebook:base-demo

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
