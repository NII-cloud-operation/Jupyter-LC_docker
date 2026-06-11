# base-demo-lab 2026-06-11
FROM niicloudoperation/notebook@sha256:1db635448c2983b916365d33b49ebb89b32bd89324fbd8dc278912a56a5b2f18

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
