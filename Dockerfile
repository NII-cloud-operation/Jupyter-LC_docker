FROM solr:8 AS solr

# niicloudoperation/notebook:feature-lab
FROM niicloudoperation/notebook@sha256:8e70c90ee7ad046f752a7493c8f084fd3e51345c0748f9516c8765a3c87122d5

USER root

# for nbsearch -->
# Install OpenJDK and lsyncd
RUN apt-get update && apt-get install -yq supervisor lsyncd uuid-runtime \
    openjdk-11-jre nginx gnupg curl gettext-base tinyproxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Solr
COPY --from=solr /opt /opt/
RUN mkdir -p /var/solr
COPY --from=solr /var/solr /var/solr
ENV SOLR_USER="jovyan" \
    SOLR_GROUP="users" \
    PATH="/opt/solr/bin:/opt/docker-solr/scripts:$PATH" \
    SOLR_INCLUDE=/etc/default/solr.in.sh \
    SOLR_HOME=/var/solr/data \
    SOLR_PID_DIR=/var/solr \
    SOLR_LOGS_DIR=/var/solr/logs \
    LOG4J_PROPS=/var/solr/log4j2.xml
RUN chown jovyan:users -R /var/solr /run/tinyproxy

# MINIO
ENV MINIO_ACCESS_KEY=nbsearchak MINIO_SECRET_KEY=nbsearchsk
RUN mkdir -p /opt/minio/bin/ && \
    curl -L https://dl.min.io/server/minio/release/linux-amd64/minio > /opt/minio/bin/minio && \
    chmod +x /opt/minio/bin/minio && mkdir -p /var/minio && chown jovyan:users -R /var/minio

# ep_weave
RUN mkdir /opt/etherpad && chown jovyan:users -R /opt/etherpad && \
    chown jovyan:users -R /var/solr /var/log/nginx /var/lib/nginx

USER $NB_UID

ARG ETHERPAD_PLUGINS="ep_align ep_markdown ep_embedded_hyperlinks2 ep_font_color ep_headings2  ep_image_upload ep_user_displayname ep_stable_authorid"
ARG ETHERPAD_LOCAL_PLUGINS="/tmp/ep_weave/ /tmp/ep_search/"
RUN git clone https://github.com/NII-cloud-operation/ep_weave.git /tmp/ep_weave \
    && cd /tmp/ep_weave \
    && ls -la /tmp/ep_weave \
    && npm i --include dev && npm run build
RUN git clone -b feature/search-engine https://github.com/NII-cloud-operation/ep_search.git /tmp/ep_search \
    && cd /tmp/ep_search \
    && ls -la /tmp/ep_search \
    && npm pack
RUN npm install -g pnpm && \
    git clone -b develop https://github.com/ether/etherpad-lite.git /opt/etherpad/ && \
    cd /opt/etherpad && \
    pnpm i && \
    pnpm run build:etherpad && \
    pnpm run plugins i ${ETHERPAD_PLUGINS} && \
    pnpm run plugins i ${ETHERPAD_LOCAL_PLUGINS:+--path ${ETHERPAD_LOCAL_PLUGINS}}

USER root

# Tools for DEMO Notebooks
RUN pip --no-cache-dir install git+https://github.com/yacchin1205/apachelog.git@feature/python3
RUN mamba install --quiet --yes awscli passlib && mamba clean --all -f -y
RUN apt-get update && apt-get install -y expect && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm /home/$NB_USER/*.ipynb

RUN pip --no-cache-dir install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy
COPY ./nbsearch /tmp/nbsearch
COPY ./sidestickies /tmp/nbtags
COPY ./conf /tmp/conf
RUN mkdir -p /usr/local/bin/before-notebook.d && \
    cp /tmp/nbsearch/example/update-index /usr/local/bin/ && \
    chmod +x /usr/local/bin/update-index && \
    mkdir -p /opt/nbsearch/ && \
    cp -fr /tmp/nbsearch/solr /opt/nbsearch/

# Boot scripts to perform /usr/local/bin/before-notebook.d/* on JupyterHub
RUN mkdir -p /opt/nbsearch/original/bin/ && \
    mkdir -p /opt/nbsearch/bin/ && \
    mv /opt/conda/bin/jupyterhub-singleuser /opt/nbsearch/original/bin/jupyterhub-singleuser && \
    mv /opt/conda/bin/jupyter-notebook /opt/nbsearch/original/bin/jupyter-notebook && \
    mv /opt/conda/bin/jupyter-lab /opt/nbsearch/original/bin/jupyter-lab && \
    cp /tmp/nbsearch/example/jupyterhub-singleuser /opt/conda/bin/ && \
    cp /tmp/nbsearch/example/jupyter-notebook /opt/conda/bin/ && \
    cp /tmp/nbsearch/example/jupyter-lab /opt/conda/bin/ && \
    cp /tmp/nbsearch/example/run-hook.sh /opt/nbsearch/bin/ && \
    cp /tmp/nbsearch/example/build-index.sh /opt/nbsearch/bin/ && \
    chmod +x /opt/conda/bin/jupyterhub-singleuser /opt/conda/bin/jupyter-notebook /opt/conda/bin/jupyter-lab \
        /opt/nbsearch/bin/*

RUN mkdir -p /opt/nbtags/bin && \
    cp /tmp/nbtags/example/config.py.template \
        /opt/nbtags/config.py.template && \
    cp /tmp/nbtags/example/config.default.py \
        /opt/nbtags/config.default.py && \
    cp /tmp/nbtags/example/nginx-ep-proxy.conf.template /opt/nbtags/ && \
    cp /tmp/nbtags/example/run-*.sh /opt/nbtags/bin/ && \
    chmod +x /opt/nbtags/bin/*

RUN mkdir -p /opt/notebook/bin && \
    cp -fr /tmp/conf /opt/notebook/ && \
    cp /tmp/nbsearch/example/update-index.lua /opt/notebook/bin/update-index.lua && \
    cp /tmp/nbsearch/example/00-add-config.sh /usr/local/bin/before-notebook.d/00-add-nbsearch-config.sh && \
    cp /tmp/nbtags/example/00-add-config.sh /usr/local/bin/before-notebook.d/00-add-sidestickies-config.sh && \
    cp /tmp/conf/99-run-supervisor.sh /usr/local/bin/before-notebook.d/ && \
    chmod +x /usr/local/bin/before-notebook.d/*.sh && \
    mkdir -p /jupyter_notebook_config.d && chown jovyan:users /jupyter_notebook_config.d

# Configuration for Server Proxy
RUN cat /tmp/conf/jupyter_notebook_config.py >> $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py

# <-- for nbsearch

RUN jupyter labextension enable sidestickies --level=system && \
    jupyter labextension enable nbsearch --level=system && \
    jupyter labextension enable jupyter-mynerva --level=system

# for nbsearch -->

# <-- for sidestickies

RUN cp /tmp/conf/etherpad-settings.json /opt/etherpad/settings.json

USER $NB_USER
RUN jupyter nbclassic-extension enable --py --user nbtags

# for sidestickies -->

RUN mkdir -p /home/$NB_USER/.nbsearch && \
    cp /tmp/nbsearch/example/config_*.py /home/$NB_USER/.nbsearch/

# Create Solr schema
RUN precreate-core jupyter-notebook /opt/nbsearch/solr/jupyter-notebook/ && \
    precreate-core jupyter-cell /opt/nbsearch/solr/jupyter-cell/ && \
    precreate-core pad /tmp/ep_weave/solr/pad/

RUN jupyter nbclassic-serverextension enable --py --user nbsearch && \
    jupyter nbclassic-extension enable --py --user nbsearch && \
    jupyter nbclassic-serverextension enable --py --user nbtags && \
    jupyter nbclassic-extension enable --py --user nbtags && \
    jupyter nbclassic-extension enable --py --user lc_notebook_diff
# <-- for nbsearch
