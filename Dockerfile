# base-demo-lab 2025-06-19
FROM niicloudoperation/notebook@sha256:4d04c3867c31e79d3d49b2eaf1650f9240526dc6f19a465c93e368894e37c212

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
