# base-demo-lab 2025-12-02
FROM niicloudoperation/notebook@sha256:472cc2cac9172551321253e79d32a4245b36592a26aa270f2c21fa99b3c6f57a

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER
