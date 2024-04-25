# base-demo-lab 2024-04-24
FROM niicloudoperation/notebook@sha256:8cf82525cfd70fc003b6e4105b30ec5931c15f46c7af4ddb05de24b3a5b52727

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
