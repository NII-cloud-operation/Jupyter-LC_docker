#!/bin/bash

set -xe

# For Solr
if [ "$EUID" -eq 0 ]; then
    cp -f /home/jovyan/.nbsearch/supervisor-root.conf /home/jovyan/.nbsearch/supervisor.conf
fi
supervisord -c /home/jovyan/.nbsearch/supervisor.conf

export SUPERVISOR_INITIALIZED=1