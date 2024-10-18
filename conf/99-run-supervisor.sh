#!/bin/bash

set -xe

# For Solr
supervisord -c /opt/notebook/conf/supervisor.conf

if [ ! -z "$WAIT_FOR_SOLR_READY" ]; then
    if [[ ! -f /home/$NB_USER/.nbsearch/config_local.py ]] ; then
        while ! nc -z localhost 8983; do
          sleep 0.5
        done
        while ! nc -z localhost 9000; do
          sleep 0.5
        done
        while ! curl http://localhost:8983/solr/jupyter-cell/admin/ping | grep '"status":"OK"'; do
          sleep 0.5
        done
        jupyter nbsearch update-index --debug $CONDA_DIR/etc/jupyter/jupyter_notebook_config.py local
    fi
fi

if [ ! -z "$WAIT_FOR_EP_WEAVE_READY" ]; then
    if [[ ! -f /opt/nbtags/config.py ]] ; then
        while ! nc -z localhost 8983; do
          sleep 0.5
        done
        while ! nc -z localhost 9002; do
          sleep 0.5
        done
        while ! curl http://localhost:8983/solr/pad/admin/ping | grep '"status":"OK"'; do
          sleep 0.5
        done
    fi
fi

export SUPERVISOR_INITIALIZED=1
