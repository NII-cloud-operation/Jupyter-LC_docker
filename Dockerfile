FROM quay.io/jupyter/scipy-notebook:notebook-7.4.7
MAINTAINER https://github.com/NII-cloud-operation

USER root
# Install tools and fonts
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    vim \
    jed \
    emacs \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-recommended \
    libxrender1 \
    inkscape \
    wget \
    curl \
    fonts-ipafont-gothic fonts-ipafont-mincho \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

### ansible
RUN apt-get update && \
    apt-get -y install sshpass openssl ipmitool libssl-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    conda install --quiet --yes requests paramiko ansible asciinema && \
    conda clean --all -f -y

### Utilities
RUN apt-get update && apt-get install -y virtinst dnsutils zip tree jq \
        rsync iputils-ping netcat-traditional && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    conda install --quiet --yes papermill && \
    pip --no-cache-dir install netaddr pyapi-gitlab pysnmp pysnmp-mibs pytest-playwright && \
    conda clean --all -f -y

### Install nodejs 20 for svg-term-cli
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    mkdir -p /.npm && \
    chown jovyan:users -R /.npm && \
    rm -rf /var/lib/apt/lists/*
ENV NPM_CONFIG_PREFIX=/.npm
ENV PATH=/.npm/bin/:${PATH}
USER $NB_USER
RUN npm install -g svg-term-cli && \
    npm cache clean --force
USER root

#### Visualization
RUN pip --no-cache-dir install folium

### extensions for jupyter
#### jupyter_nbextensions_configurator
#### jupyter_contrib_nbextensions
#### Jupyter-LC_nblineage (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_nblineage
#### Jupyter-LC_through (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_run_through
#### Jupyter-LC_wrapper (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_wrapper
#### Jupyter-multi_outputs (NII) - https://github.com/NII-cloud-operation/Jupyter-multi_outputs
#### Jupyter-LC_index (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_index
#### Jupyter-LC_notebook_diff (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_notebook_diff
#### sidestickies (NII) - https://github.com/NII-cloud-operation/sidestickies
#### nbsearch (NII) - https://github.com/NII-cloud-operation/nbsearch
#### nbwhisper (NII) - https://github.com/NII-cloud-operation/nbwhisper
ENV nblineage_release_tag=0.2.0.rc2 \
    nblineage_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/releases/download/ \
    lc_index_release_tag=0.2.0.rc4 \
    lc_index_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_index/releases/download/ \
    lc_multi_outputs_release_tag=2.2.0.rc3 \
    lc_multi_outputs_release_url=https://github.com/NII-cloud-operation/Jupyter-multi_outputs/releases/download/ \
    lc_run_through_release_tag=0.2.0.rc7 \
    lc_run_through_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_run_through/releases/download/ \
    lc_wrapper_release_tag=1.3.2.rc0 \
    lc_wrapper_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/releases/download/ \
    diff_release_tag=0.2.0.rc2 \
    diff_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_notebook_diff/releases/download/ \
    sidestickies_release_tag=0.3.1.rc4 \
    sidestickies_release_url=https://github.com/NII-cloud-operation/sidestickies/releases/download/ \
    nbsearch_release_tag=0.2.0.rc5 \
    nbsearch_release_url=https://github.com/NII-cloud-operation/nbsearch/releases/download/ \
    nbwhisper_release_tag=0.2.0.rc1 \
    nbwhisper_release_url=https://github.com/NII-cloud-operation/nbwhisper/releases/download/ \
    lc_toc_button_release_tag=0.1.0.rc2 \
    lc_toc_button_release_url=https://github.com/NII-cloud-operation/Jupyter-LC_ToC_button/releases/download/
RUN pip --no-cache-dir install jupyter_nbextensions_configurator && \
    pip --no-cache-dir install six bash_kernel \
    jupyterlab-language-pack-ja-JP \
    ${nblineage_release_url}${nblineage_release_tag}/nblineage-${nblineage_release_tag}.tar.gz \
    ${lc_run_through_release_url}${lc_run_through_release_tag}/lc_run_through-${lc_run_through_release_tag}.tar.gz \
    ${lc_wrapper_release_url}${lc_wrapper_release_tag}/lc_wrapper-${lc_wrapper_release_tag}.tar.gz \
    ${lc_multi_outputs_release_url}${lc_multi_outputs_release_tag}/lc_multi_outputs-${lc_multi_outputs_release_tag}.tar.gz \
    ${lc_index_release_url}${lc_index_release_tag}/lc_index-${lc_index_release_tag}.tar.gz \
    ${diff_release_url}${diff_release_tag}/lc_notebook_diff-${diff_release_tag}.tar.gz \
    ${sidestickies_release_url}${sidestickies_release_tag}/sidestickies-${sidestickies_release_tag}.tar.gz \
    ${nbsearch_release_url}${nbsearch_release_tag}/nbsearch-${nbsearch_release_tag}.tar.gz \
    ${nbwhisper_release_url}${nbwhisper_release_tag}/nbwhisper-${nbwhisper_release_tag}.tar.gz \
    ${lc_toc_button_release_url}${lc_toc_button_release_tag}/table_of_contents-${lc_toc_button_release_tag}.tar.gz \
    jupyter-ai langchain-anthropic langchain-openai langchain-google-genai

RUN jupyter nblineage quick-setup --sys-prefix && \
    jupyter nbclassic-extension install --py lc_run_through --sys-prefix && \
    jupyter nbclassic-extension enable --py lc_run_through --sys-prefix && \
    jupyter nbclassic-extension install --py lc_multi_outputs --sys-prefix && \
    jupyter nbclassic-extension enable --py lc_multi_outputs --sys-prefix && \
    jupyter nbclassic-extension install --py lc_index --sys-prefix && \
    jupyter nbclassic-extension enable --py lc_index --sys-prefix && \
    jupyter nbclassic-extension install --py lc_wrapper --sys-prefix && \
    jupyter nbclassic-extension enable --py lc_wrapper --sys-prefix && \
    jupyter nbclassic-extension install --py lc_notebook_diff --sys-prefix && \
    jupyter nbclassic-extension enable --py lc_notebook_diff --sys-prefix && \
    jupyter nbclassic-extension install --py nbtags --sys-prefix && \
    jupyter nbclassic-serverextension enable --py nbtags --sys-prefix && \
    jupyter nbclassic-extension install --py nbsearch --sys-prefix && \
    jupyter nbclassic-serverextension enable --py nbsearch --sys-prefix && \
    # jupyter nbclassic-extension install --py nbwhisper --sys-prefix && \
    # jupyter nbclassic-serverextension enable --py nbwhisper --sys-prefix && \
    jupyter nbclassic-extension install --py jupyter_nbextensions_configurator --sys-prefix && \
    jupyter nbclassic-extension enable --py jupyter_nbextensions_configurator --sys-prefix && \
    jupyter nbclassic-serverextension enable --py jupyter_nbextensions_configurator --sys-prefix && \
    jupyter nbclassic-extension enable collapsible_headings/main --sys-prefix && \
    jupyter nbclassic-extension enable toc2/main --sys-prefix && \
    fix-permissions /home/$NB_USER

# To enable the nbsearch or sidestickies, you need to run the following command in the notebook.
# jupyter labextension enable sidestickies --level=user
# jupyter labextension enable nbsearch --level=user
# jupyter labextension enable nbwhisper --level=user
RUN jupyter labextension disable sidestickies --level=system && \
    jupyter labextension disable nbsearch --level=system && \
    jupyter labextension disable nbwhisper --level=system

# Copy config files
ADD conf /tmp/
RUN mkdir -p $CONDA_DIR/etc/jupyter && \
    cp -f /tmp/jupyter_notebook_config.py \
       $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py && \
    cp -f /tmp/jupyter_server_config.py \
       $CONDA_DIR/etc/jupyter/jupyter_server_config.py && \
    mkdir -p /etc/ansible && cp /tmp/ansible.cfg /etc/ansible/ansible.cfg

### kernels
RUN chmod +x /tmp/wrapper-kernels/prepare-icons.sh && \
    /tmp/wrapper-kernels/prepare-icons.sh && \
    python -m bash_kernel.install --sys-prefix && \
    jupyter kernelspec install /tmp/kernels/python3-wrapper --sys-prefix && \
    jupyter kernelspec install /tmp/kernels/bash-wrapper --sys-prefix && \
    jupyter wrapper-kernelspec install /tmp/wrapper-kernels/python3 --sys-prefix && \
    jupyter wrapper-kernelspec install /tmp/wrapper-kernels/bash --sys-prefix && \
    fix-permissions /home/$NB_USER

### nbconfig
RUN mkdir -p $CONDA_DIR/etc/jupyter/nbconfig/notebook.d && \
    cp /tmp/nbextension-config.json $CONDA_DIR/etc/jupyter/nbconfig/notebook.d/nbextension-config.json

### notebooks dir
ADD sample-notebooks /home/$NB_USER
RUN fix-permissions /home/$NB_USER

### Bash Strict Mode
RUN cp /tmp/bash_env /etc/bash_env

### Theme for jupyter
RUN CUSTOM_DIR=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/nbclassic/static/custom && \
    cat /tmp/custom.css >> $CUSTOM_DIR/custom.css && \
    cp /tmp/logo.png $CUSTOM_DIR/logo.png && \
    mkdir -p $CUSTOM_DIR/codemirror/addon/merge/ && \
    curl -fL https://raw.githubusercontent.com/cytoscape/cytoscape.js/master/dist/cytoscape.min.js > $CUSTOM_DIR/cytoscape.min.js && \
    curl -fL https://raw.githubusercontent.com/iVis-at-Bilkent/cytoscape.js-view-utilities/master/cytoscape-view-utilities.js > $CUSTOM_DIR/cytoscape-view-utilities.js && \
    curl -fL https://raw.githubusercontent.com/NII-cloud-operation/Jupyter-LC_notebook_diff/master/html/jupyter-notebook-diff.js > $CUSTOM_DIR/jupyter-notebook-diff.js && \
    curl -fL https://raw.githubusercontent.com/NII-cloud-operation/Jupyter-LC_notebook_diff/master/html/jupyter-notebook-diff.css > $CUSTOM_DIR/jupyter-notebook-diff.css && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/diff_match_patch/20121119/diff_match_patch.js > $CUSTOM_DIR/diff_match_patch.js && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.35.0/addon/merge/merge.js > $CUSTOM_DIR/codemirror/addon/merge/merge.js && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.35.0/addon/merge/merge.min.css > $CUSTOM_DIR/merge.min.css

#### CSS for JupyterLab
RUN CUSTOM_DIR=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/notebook/custom && \
    mkdir -p $CUSTOM_DIR && \
    cp /tmp/nb7-custom.css $CUSTOM_DIR/custom.css && \
    cp /tmp/logo.png $CUSTOM_DIR/logo.png && \
    CUSTOM_DIR=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/jupyterlab/themes/@jupyterlab && \
    cat /tmp/lab-custom.css >> $CUSTOM_DIR/theme-dark-extension/index.css && \
    cat /tmp/lab-custom.css >> $CUSTOM_DIR/theme-light-extension/index.css && \
    CUSTOM_DIR=/opt/conda/share/jupyter/lab/themes/@jupyterlab && \
    cat /tmp/lab-custom.css >> $CUSTOM_DIR/theme-dark-extension/index.css && \
    cat /tmp/lab-custom.css >> $CUSTOM_DIR/theme-light-extension/index.css

### Custom get_ipython().system() to control error propagation of shell commands
RUN mkdir -p $CONDA_DIR/etc/ipython/startup/ && \
    cp /tmp/ipython_config.py $CONDA_DIR/etc/ipython/ && \
    cp /tmp/10-custom-get_ipython_system.py $CONDA_DIR/etc/ipython/startup/

### Add run-hooks
RUN mkdir -p /usr/local/bin/before-notebook.d && \
    cp /tmp/ssh-agent.sh /usr/local/bin/before-notebook.d/

### Install lsyncd for nbsearch
RUN apt-get update && apt-get install -yq lsyncd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/nbsearch \
    && cp /tmp/nbsearch/launch.sh /usr/local/bin/before-notebook.d/nbsearch-launch.sh \
    && cp /tmp/nbsearch/update-index* /opt/nbsearch/ \
    && chmod +x /usr/local/bin/before-notebook.d/nbsearch-launch.sh /opt/nbsearch/update-index

# Workaround for https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/issues/71
RUN pip install --upgrade jupyter_core==5.6.1

# Make classic notebook the default
#ENV DOCKER_STACKS_JUPYTER_CMD=nbclassic

USER $NB_USER
