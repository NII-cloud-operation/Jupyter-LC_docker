FROM niicloudoperation/notebook@sha256:22ab0d57d8c65d3ca36ece51a4a0ea7acfe44a19bc1ee1c2b4b0a782ca6f3265

USER root
RUN rm /home/$NB_USER/*.ipynb
ADD sample-notebooks /home/$NB_USER
RUN fix-permissions /home/$NB_USER

RUN pip --no-cache-dir install git+https://github.com/yacchin1205/apachelog.git@feature/python3

RUN jupyter nbextension enable --py nbtags --sys-prefix
ENV SIDESTICKIES_SCRAPBOX_PROJECT_ID sidestickies-public
USER $NB_USER
