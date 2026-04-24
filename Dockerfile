# base-demo-lab 2026-04-25
FROM niicloudoperation/notebook@sha256:ae28bd58aa707bb11e17d9cd8c1f8f38b981dfc794f6c7661769ae7ffe5fcbf0

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
