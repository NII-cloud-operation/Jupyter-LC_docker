# base-demo-lab 2024-11-17
FROM niicloudoperation/notebook@sha256:9857671dd9894da168da75fd5d66ccd362fc333772bf9e88c3136c5164f016fb

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER
