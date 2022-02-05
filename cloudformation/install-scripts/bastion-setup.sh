#!/bin/bash

rm -f .ssh/known_hosts
chmod 600 *.pem
chmod +x master-*.sh
chmod +x worker-*.sh
