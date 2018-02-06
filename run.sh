#!/bin/bash

export R_HOME=/usr/lib/R

java -Xmx8024m -cp NetLogo.jar org.nlogo.headless.Main \
     --model ABM-Empirical-MexicoCity_V6.nlogo \
     --experiment experiment1 \
     --setup-file $1 \
     --table $2 \
     --threads $3
