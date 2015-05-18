#!/bin/sh

if type "pidgin" > /dev/null; then
  export NSS_SSL_CBC_RANDOM_IV=0
  nohup pidgin &
fi

if type "hipchat" > /dev/null; then
  nohup hipchat &
fi
