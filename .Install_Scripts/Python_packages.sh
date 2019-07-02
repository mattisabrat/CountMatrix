#!/usr/bin/env bash

PATH=$(getconf PATH)
export PATH=$PATH:$PWD/.Python/bin
export PYTHONPATH=$PWD/.Python/bin

pip3 install --upgrade pip
pip3 install multiqc
pip3 install --upgrade multiqc
