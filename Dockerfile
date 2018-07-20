FROM debian:jessie

MAINTAINER https://github.com/NII-cloud-operation

ENV DEBIAN_FRONTEND noninteractive
RUN REPO=http://cdn-fastly.deb.debian.org \
 && echo "deb $REPO/debian jessie main\ndeb $REPO/debian jessie-updates main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list \
 && apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen


# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create 'bit_kun' user
ENV NB_USER bit_kun
ENV NB_UID 1000
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir /home/$NB_USER/.jupyter && \
    chown -R $NB_USER:users /home/$NB_USER/.jupyter && \
    echo "$NB_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NB_USER

# Install Jupyter
RUN bash -c 'apt-get update && apt-get install -yq --no-install-recommends \
             curl python2.7-dev python2.7 build-essential && \
             curl -L https://bootstrap.pypa.io/get-pip.py | python2.7 && \
             pip2 --no-cache-dir install -U pip setuptools six && \
             apt-get clean && rm -rf /var/lib/apt/lists/*'

## Python kernel with matplotlib, etc...
RUN pip --no-cache-dir install jupyter && \
    pip --no-cache-dir install pandas matplotlib numpy \
                seaborn scipy scikit-learn dill bokeh && \
    apt-get update && apt-get install -yq --no-install-recommends \
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
USER $NB_USER
RUN mkdir -p $HOME/.jupyter && \
    cp -f /tmp/jupyter_notebook_config.py \
       $HOME/.jupyter/jupyter_notebook_config.py

USER root
RUN cat /tmp/sitecustomize.py >> /usr/lib/python2.7/sitecustomize.py

SHELL ["/bin/bash", "-c"]

### ansible
RUN apt-get update && \
    apt-get -y install sshpass openssl ipmitool libssl-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip --no-cache-dir install requests paramiko ansible

### Utilities
RUN apt-get update && apt-get install -y virtinst dnsutils zip tree jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip --no-cache-dir install netaddr pyapi-gitlab runipy \
                pysnmp pysnmp-mibs

### Add files
RUN mkdir -p /etc/ansible && cp /tmp/ansible.cfg /etc/ansible/ansible.cfg

### environments for Python3
ENV CONDA3_DIR /opt/conda3
RUN cd /tmp && \
    mkdir -p $CONDA3_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh && \
    echo "a946ea1d0c4a642ddf0c3a26a18bb16d *Miniconda3-4.5.4-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-4.5.4-Linux-x86_64.sh -f -b -p $CONDA3_DIR && \
    rm Miniconda3-4.5.4-Linux-x86_64.sh && \
    $CONDA3_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA3_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA3_DIR/bin/conda install --quiet --yes \
    notebook matplotlib pandas pip && \
    $CONDA3_DIR/bin/pip --no-cache-dir install pytz && \
    $CONDA3_DIR/bin/conda clean -tipsy
#### Visualization
RUN $CONDA3_DIR/bin/pip --no-cache-dir install folium

### extensions for jupyter (python2)
#### jupyter_nbextensions_configurator
#### jupyter_contrib_nbextensions
#### nbextension_i18n (NII) - https://github.com/NII-cloud-operation/Jupyter-i18n_cells
#### Jupyter-LC_nblineage (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_nblineage
#### Jupyter-LC_through (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_run_through
#### Jupyter-LC_wrapper (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_wrapper
#### Jupyter-multi_outputs (NII) - https://github.com/NII-cloud-operation/Jupyter-multi_outputs
#### Jupyter-LC_index (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_index
RUN pip --no-cache-dir install jupyter_nbextensions_configurator && \
    pip --no-cache-dir install six \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master \
    git+https://github.com/NII-cloud-operation/Jupyter-i18n_cells.git \
    https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_run_through/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/tarball/master \
    git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs \
    git+https://github.com/NII-cloud-operation/Jupyter-LC_index.git \
    git+https://github.com/NII-cloud-operation/Jupyter-LC_notebook_diff.git


USER $NB_USER
RUN mkdir -p $HOME/.local/share && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension install --py nbextension_i18n_cells --user && \
    jupyter nbextension enable --py nbextension_i18n_cells --user && \
    jupyter nblineage quick-setup --user && \
    jupyter run-through quick-setup --user && \
    jupyter nbextension install --py lc_multi_outputs --user && \
    jupyter nbextension enable --py lc_multi_outputs --user && \
    jupyter nbextension install --py notebook_index --user && \
    jupyter nbextension enable --py notebook_index --user && \
    jupyter nbextension install --py lc_notebook_diff --user && \
    jupyter kernelspec install /tmp/kernels/python2-wrapper --user

### extensions for Jupyter (python3)
USER root
RUN $CONDA3_DIR/bin/pip --no-cache-dir install jupyter_nbextensions_configurator ipywidgets && \
    $CONDA3_DIR/bin/pip --no-cache-dir install https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/tarball/master \
    https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/tarball/master \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master \
    bash_kernel

USER $NB_USER
RUN $CONDA3_DIR/bin/ipython kernel install --user && \
    $CONDA3_DIR/bin/python -m bash_kernel.install --user && \
    $CONDA3_DIR/bin/jupyter kernelspec install /tmp/kernels/python3-wrapper --user && \
    $CONDA3_DIR/bin/jupyter kernelspec install /tmp/kernels/bash-wrapper --user && \
    $CONDA3_DIR/bin/jupyter nblineage quick-setup --user && \
    $CONDA3_DIR/bin/jupyter nbextension enable --user --py widgetsnbextension

### notebooks dir
USER root
RUN mkdir -p /notebooks
ADD sample-notebooks /notebooks
RUN chown $NB_USER:users -R /notebooks
WORKDIR /notebooks

### utilities
RUN pip install papermill

### Bash Strict Mode
RUN cp /tmp/bash_env /etc/bash_env
ENV BASH_ENV=/etc/bash_env

### nbconfig
USER $NB_USER
RUN mkdir -p $HOME/.jupyter/nbconfig && \
    cp /tmp/notebook.json $HOME/.jupyter/nbconfig/notebook.json

### Theme for jupyter
RUN mkdir -p $HOME/.jupyter/custom/ && \
    cp /tmp/custom.css $HOME/.jupyter/custom/custom.css && \
    cp /tmp/logo.png $HOME/.jupyter/custom/logo.png && \
    mkdir -p $HOME/.jupyter/custom/codemirror/addon/merge/ && \
    curl -fL https://raw.githubusercontent.com/cytoscape/cytoscape.js/master/dist/cytoscape.min.js > $HOME/.jupyter/custom/cytoscape.min.js && \
    curl -fL https://raw.githubusercontent.com/iVis-at-Bilkent/cytoscape.js-view-utilities/master/cytoscape-view-utilities.js > $HOME/.jupyter/custom/cytoscape-view-utilities.js && \
    curl -fL https://raw.githubusercontent.com/NII-cloud-operation/Jupyter-LC_notebook_diff/master/html/jupyter-notebook-diff.js > $HOME/.jupyter/custom/jupyter-notebook-diff.js && \
    curl -fL https://raw.githubusercontent.com/NII-cloud-operation/Jupyter-LC_notebook_diff/master/html/jupyter-notebook-diff.css > $HOME/.jupyter/custom/jupyter-notebook-diff.css && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/diff_match_patch/20121119/diff_match_patch.js > $HOME/.jupyter/custom/diff_match_patch.js && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.35.0/addon/merge/merge.js > $HOME/.jupyter/custom/codemirror/addon/merge/merge.js && \
    curl -fL https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.35.0/addon/merge/merge.min.css > $HOME/.jupyter/custom/merge.min.css

### Custom get_ipython().system() to control error propagation of shell commands
RUN mkdir -p $HOME/.ipython/profile_default/startup && \
    cp /tmp/10-custom-get_ipython_system.py $HOME/.ipython/profile_default/startup/

ENV SHELL=/bin/bash
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]
