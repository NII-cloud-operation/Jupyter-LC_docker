# base-demo-lab 2025-06-19
FROM niicloudoperation/notebook@sha256:231d5fc80d6abe7d46018ca1861d893aa66289253bc6034117aaaa308b40341a

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
