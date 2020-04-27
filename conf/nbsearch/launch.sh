#!/bin/bash

set -xe

# Launch auto updater
if [[ ! -z "${NBSEARCHDB_AUTO_UPDATE}" ]] ; then
  lsyncd /opt/nbsearch/update-index.lua
fi
