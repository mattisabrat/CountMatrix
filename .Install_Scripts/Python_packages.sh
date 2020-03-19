#!/usr/bin/env bash

PATH=$(getconf PATH)
export PATH=$PWD/.Python/bin:$PATH
export PYTHONPATH=$PWD/.Python/bin

pip3 install --upgrade pip
pip3 install multiqc
