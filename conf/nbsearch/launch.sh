#!/bin/bash

set -xe

# For MongoDB
if [[ "${NBSEARCHDB_HOSTNAME}" == "127.0.0.1" ]] ; then
    ln -s /opt/nbsearch/mongodb.conf /opt/nbsearch/conf.d/mongodb.conf
fi

supervisord -c /opt/nbsearch/supervisor.conf

if [[ "${NBSEARCHDB_HOSTNAME}" == "127.0.0.1" || ! -z "${NBSEARCH_UPDATE_ALL_INDICES}" ]] ; then
    while ! nc -z localhost 27017; do
      sleep 0.1 # wait for 1/10 of the second before check again
    done
    jupyter nbsearch update-index $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py local
fi
