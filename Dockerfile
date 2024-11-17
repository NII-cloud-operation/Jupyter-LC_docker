# base-demo-lab 2024-11-17
FROM niicloudoperation/notebook@sha256:4e2c3876e2eb098308180db371c6e88fe86323ade33ffeb51d5f5b0a036a593a

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

USER $NB_USER
