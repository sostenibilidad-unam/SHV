#!/bin/bash

java -Xmx8024m -cp NetLogo.jar org.nlogo.headless.Main \
     --model ABM-Empirical-MexicoCity.nlogo \
     --experiment experiment1 \
     --setup-file $1 \
     --threads $2
