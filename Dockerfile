FROM niicloudoperation/notebook@sha256:20438297076cb1997833471eba78ff50a1a5f82154d9ece0ac9a1c9a54779651

USER root

# Tools for DEMO Notebooks
RUN pip --no-cache-dir install git+https://github.com/yacchin1205/apachelog.git@feature/python3
RUN conda install --quiet --yes awscli passlib && conda clean --all -f -y
RUN apt-get update && apt-get install -y expect && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm /home/$NB_USER/*.ipynb
ADD sample-notebooks /home/$NB_USER
RUN fix-permissions /home/$NB_USER

RUN jupyter nbextension enable --py nbtags --sys-prefix
ENV SIDESTICKIES_SCRAPBOX_PROJECT_ID sidestickies-public
USER $NB_USER
