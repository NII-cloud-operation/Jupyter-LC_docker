#!/bin/bash

set -xe

# Launch auto updater
if [[ ! -z "${NBSEARCHDB_AUTO_UPDATE}" ]] ; then
  if [ $(id -u) == 0 ] ; then
    sudo -E -u $NB_USER lsyncd /opt/nbsearch/update-index.lua
  else
    lsyncd /opt/nbsearch/update-index.lua
  fi
fi
