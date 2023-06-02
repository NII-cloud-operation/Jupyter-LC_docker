#!/bin/bash

set -xe

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
    jupyter nbsearch update-index --debug /home/$NB_USER/.jupyter/jupyter_notebook_config.py local &
fi
