# base-demo-lab 2026-04-25
FROM niicloudoperation/notebook@sha256:ae28bd58aa707bb11e17d9cd8c1f8f38b981dfc794f6c7661769ae7ffe5fcbf0

USER root

ADD sample-notebooks /home/$NB_USER
RUN chown jovyan:users -R /home/$NB_USER/

ADD sample-pads /pads.d
RUN chown jovyan:users -R /pads.d

# Workaround: replace jupyter-mynerva with 0.1.3.stream2 (lazy SDK imports)
# to avoid JupyterHub spawn 30s timeout caused by slow extension load.
RUN pip uninstall -y jupyter_mynerva && \
    pip install --no-cache-dir https://github.com/NII-cloud-operation/jupyter-mynerva/releases/download/0.1.3.stream2/jupyter_mynerva-0.1.3.stream2.tar.gz && \
    jupyter labextension enable jupyter-mynerva --level=system

USER $NB_USER

RUN find /home/$NB_USER -name "*.ipynb" -exec jupyter trust {} \;
