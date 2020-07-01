FROM niicloudoperation/notebook@sha256:20438297076cb1997833471eba78ff50a1a5f82154d9ece0ac9a1c9a54779651

USER root
RUN rm /home/$NB_USER/*.ipynb
ADD sample-notebooks /home/$NB_USER
RUN fix-permissions /home/$NB_USER

RUN pip --no-cache-dir install git+https://github.com/yacchin1205/apachelog.git@feature/python3

RUN jupyter nbextension enable --py nbtags --sys-prefix
ENV SIDESTICKIES_SCRAPBOX_PROJECT_ID sidestickies-public
USER $NB_USER
