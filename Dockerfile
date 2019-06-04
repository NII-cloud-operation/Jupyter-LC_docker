FROM jupyter/scipy-notebook:latest
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
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    libxrender1 \
    inkscape \
    wget \
    curl \
    fonts-ipafont-gothic fonts-ipafont-mincho \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy config files
ADD conf /tmp/
RUN mkdir -p $CONDA_DIR/etc/jupyter && \
    cp -f /tmp/jupyter_notebook_config.py \
       $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py

SHELL ["/bin/bash", "-c"]

### ansible
RUN apt-get update && \
    apt-get -y install sshpass openssl ipmitool libssl-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip --no-cache-dir install requests paramiko ansible

### Utilities
RUN apt-get update && apt-get install -y virtinst dnsutils zip tree jq rsync iputils-ping && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip --no-cache-dir install netaddr pyapi-gitlab runipy papermill==0.19.0 \
                pysnmp pysnmp-mibs

### Add files
RUN mkdir -p /etc/ansible && cp /tmp/ansible.cfg /etc/ansible/ansible.cfg

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
RUN pip --no-cache-dir install jupyter_nbextensions_configurator && \
    pip --no-cache-dir install six bash_kernel \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_run_through/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/tarball/master \
    git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs \
    git+https://github.com/NII-cloud-operation/Jupyter-LC_index.git \
    git+https://github.com/NII-cloud-operation/Jupyter-LC_notebook_diff.git \
    git+https://github.com/NII-cloud-operation/sidestickies.git


RUN jupyter contrib nbextension install --sys-prefix && \
    jupyter nblineage quick-setup --sys-prefix && \
    jupyter nbextension install --py lc_run_through --sys-prefix && \
    jupyter nbextension enable --py lc_run_through --sys-prefix && \
    jupyter nbextension install --py lc_multi_outputs --sys-prefix && \
    jupyter nbextension enable --py lc_multi_outputs --sys-prefix && \
    jupyter nbextension install --py notebook_index --sys-prefix && \
    jupyter nbextension enable --py notebook_index --sys-prefix && \
    jupyter nbextension install --py lc_wrapper --sys-prefix && \
    jupyter nbextension enable --py lc_wrapper --sys-prefix && \
    jupyter nbextension install --py lc_notebook_diff --sys-prefix && \
    jupyter nbextension install --py nbtags --sys-prefix && \
    jupyter serverextension enable --py nbtags --sys-prefix && \
    jupyter nbextension enable nbextensions_configurator/config_menu/main --sys-prefix && \
    jupyter nbextension enable contrib_nbextensions_help_item/main --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable dragdrop/main --sys-prefix && \
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
RUN CUSTOM_DIR=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/notebook/static/custom && \
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

### Custom get_ipython().system() to control error propagation of shell commands
RUN mkdir -p $CONDA_DIR/etc/ipython/startup/ && \
    cp /tmp/ipython_config.py $CONDA_DIR/etc/ipython/ && \
    cp /tmp/10-custom-get_ipython_system.py $CONDA_DIR/etc/ipython/startup/

### Add run-hooks
RUN mkdir -p /usr/local/bin/before-notebook.d && \
    cp /tmp/ssh-agent.sh /usr/local/bin/before-notebook.d/

USER $NB_USER
