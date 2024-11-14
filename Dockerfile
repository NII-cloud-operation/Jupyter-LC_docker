# base-demo-lab 2024-11-12
FROM niicloudoperation/notebook@sha256:96a6725cf6eab085c3330189591476839f0efaaaf5359e82591656510cbbcae2

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

USER $NB_USER
