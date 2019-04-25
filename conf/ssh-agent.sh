#!/bin/sh

if [ $(id -u) == 0 ] ; then
    eval "$(sudo -u $NB_USER ssh-agent)"
else
    eval "$(ssh-agent)"
fi
