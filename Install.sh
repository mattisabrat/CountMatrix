#!/usr/bin/env bash

##---------------------------------------------------------------------
# wget everything that needs to be w-got (lolol)
# tar everything
# configure everything
# make everything
# rm the unnecessary install materials
##---------------------------------------------------------------------

#Save the head directory path
BasePath=$PWD

#First R
wget http://cran.r-project.org/src/base/R-3/R-3.6.0.tar.gz
tar -xzf R-3.6.0.tar.gz
cd R-3.6.0/
./configure --prefix $BasePath/.R
make && make install
cd $BasePath
rm R-3.6.0.tar.gz
rm -rf R-3.6.0/

#Next Python
wget https://www.python.org/ftp/python/3.5.5/Python-3.5.5.tgz 
tar -xzf Python-3.5.5.tgz 
cd Python-3.5.5/
./configure --prefix $BasePath/.Python
make && make install
cd $BasePath
rm Python-3.5.5.tgz
rm -rf Python-3.5.5/

#And STAR
wget https://github.com/alexdobin/STAR/archive/2.7.1a.tar.gz
tar -xzf 2.7.1a.tar.gz 
cd STAR-2.7.1a/source/
make STAR
cd $BasePath
rm 2.7.1a.tar.gz
mv STAR-2.7.1a/ .STAR/

##---------------------------------------------------------------------
# Execute the package installing scripts in R and Python
##---------------------------------------------------------------------

#Set up necessary path variables
PATH=$(getconf PATH)
export PATH=$PATH:$PWD/.R/bin
export PATH=$PATH:$PWD/.Python/bin
export PYTHONPATH=$PWD/.Python/bin

#Execute the package installer scripts

Rscript --vanilla $PWD/.Install_Scripts/R_packages.R 
./.Install_Scripts/Python_packages.sh 


##---------------------------------------------------------------------
# Self Destruct
##---------------------------------------------------------------------

mv $0 .Install.sh
