#!/bin/bash

echo "starting webpack dev" && export NODE_OPTIONS="--max_old_space_size=4096" && yarn && rm -rf /opt/webauthnrailsdemo/public/packs && bin/webpack-dev-server