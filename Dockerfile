# base-demo-lab 2026-06-10
FROM niicloudoperation/notebook@sha256:c421349cd1efbe476fa8b841c7d1c2c36c28bb6b29b7a93b25e0e464a8472c7b

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
