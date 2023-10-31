#!/bin/bash

set -xe

# Launch auto updater
if [[ "${NBSEARCHDB_AUTO_UPDATE:-}" -eq 1 ]] ; then
  if [ $(id -u) == 0 ] ; then
    sudo -E -u $NB_USER lsyncd /opt/nbsearch/update-index.lua
  else
    lsyncd /opt/nbsearch/update-index.lua
  fi
fi
