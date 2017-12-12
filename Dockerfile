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
             pip2 install -U pip setuptools six && \
             apt-get clean && rm -rf /var/lib/apt/lists/*'

## Python kernel with matplotlib, etc...
RUN pip install jupyter && \
    pip install pandas matplotlib numpy \
                seaborn scipy scikit-learn scikit-image \
                sympy cython patsy \
                statsmodels cloudpickle dill bokeh h5py && \
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
    pip install requests paramiko ansible

### Utilities
RUN apt-get update && apt-get install -y virtinst dnsutils zip tree jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip install netaddr pyapi-gitlab runipy \
                pysnmp pysnmp-mibs

### Add files
RUN mkdir -p /etc/ansible && cp /tmp/ansible.cfg /etc/ansible/ansible.cfg

### environments for Python3
ENV CONDA3_DIR /opt/conda3
RUN cd /tmp && \
    mkdir -p $CONDA3_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA3_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    $CONDA3_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA3_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA3_DIR/bin/conda install --quiet --yes \
    notebook matplotlib pandas pip && \
    $CONDA3_DIR/bin/conda clean -tipsy

### extensions for jupyter (python2)
#### jupyter_nbextensions_configurator
#### jupyter_contrib_nbextensions
#### nbextension_i18n (NII) - https://github.com/NII-cloud-operation/Jupyter-i18n_cells
#### Jupyter-LC_nblineage (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_nblineage
#### Jupyter-LC_through (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_run_through
#### Jupyter-LC_wrapper (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_wrapper
#### Jupyter-multi_outputs (NII) - https://github.com/NII-cloud-operation/Jupyter-multi_outputs
#### Jupyter-LC_index (NII) - https://github.com/NII-cloud-operation/Jupyter-LC_index
RUN pip install jupyter_nbextensions_configurator && \
    pip install six \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master && \
    pip install git+https://github.com/NII-cloud-operation/Jupyter-i18n_cells.git && \
    pip install https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/tarball/master && \
    pip install https://github.com/NII-cloud-operation/Jupyter-LC_run_through/tarball/master && \
    pip install https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/tarball/master && \
    pip install git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs && \
    pip install git+https://github.com/NII-cloud-operation/Jupyter-LC_index.git


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
    jupyter kernelspec install /tmp/kernels/python2-wrapper --user

### extensions for Jupyter (python3)
USER root
RUN $CONDA3_DIR/bin/pip install \
    https://github.com/NII-cloud-operation/Jupyter-LC_wrapper/tarball/master && \
    $CONDA3_DIR/bin/pip install jupyter_nbextensions_configurator ipywidgets && \
    $CONDA3_DIR/bin/pip install https://github.com/NII-cloud-operation/Jupyter-LC_nblineage/tarball/master && \
    $CONDA3_DIR/bin/pip install bash_kernel

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

### Bash Strict Mode
RUN cp /tmp/bash_env /etc/bash_env
ENV BASH_ENV=/etc/bash_env

### nbconfig
USER $NB_USER
RUN mkdir -p $HOME/.jupyter/nbconfig && \
    cp /tmp/notebook.json $HOME/.jupyter/nbconfig/notebook.json

### Theme for jupyter
RUN mkdir -p $HOME/.jupyter/custom/ && \
    cd /tmp/ && curl -O http://fontawesome.io/assets/font-awesome-4.7.0.zip && \
    unzip font-awesome-4.7.0.zip && cp -fr font-awesome-4.7.0/fonts $HOME/.jupyter/custom/ && \
    cp /tmp/custom.css $HOME/.jupyter/custom/custom.css && \
    cp /tmp/logo.png $HOME/.jupyter/custom/logo.png && \
    sed -e s,../fonts/,./fonts/,g font-awesome-4.7.0/css/font-awesome.css >> $HOME/.jupyter/custom/custom.css

### Custom get_ipython().system() to control error propagation of shell commands
RUN mkdir -p $HOME/.ipython/profile_default/startup && \
    cp /tmp/10-custom-get_ipython_system.py $HOME/.ipython/profile_default/startup/

ENV SHELL=/bin/bash
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]
