#!/bin/bash

set -xe

# For MongoDB
if [[ "${NBSEARCHDB_HOSTNAME}" == "127.0.0.1" ]] ; then
    sed "s,{NB_USER},$NB_USER," /opt/nbsearch/mongod.conf.template > /opt/nbsearch/mongod.conf
    ln -s /opt/nbsearch/mongodb.conf /opt/nbsearch/conf.d/mongodb.conf
    mkdir -p /home/$NB_USER/.nbsearch/mongodb/
    chown $NB_UID:$NB_GID -R /home/$NB_USER/.nbsearch
fi

# Launch Supervisord (FS monitor and MongoDB(if needed))
if [ $(id -u) == 0 ] ; then
    sudo -E -u $NB_USER supervisord -c /opt/nbsearch/supervisor.conf
else
    supervisord -c /opt/nbsearch/supervisor.conf
fi

# Update indices (if needed)
if [[ "${NBSEARCHDB_HOSTNAME}" == "127.0.0.1" || ! -z "${NBSEARCH_UPDATE_ALL_INDICES}" ]] ; then
    if [[ "${NBSEARCHDB_HOSTNAME}" == "127.0.0.1" ]] ; then
        while ! nc -z localhost 27017; do
          sleep 0.1
        done
    fi
    set +e
    jupyter nbsearch update-index $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py local
fi
