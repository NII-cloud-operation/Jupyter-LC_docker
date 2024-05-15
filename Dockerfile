# base-demo-lab 2024-05-15
FROM niicloudoperation/notebook@sha256:2c32fc22f9c3e7916c5a126ab9c356ca6b2dd204a27861668a4f279aeea019be

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
