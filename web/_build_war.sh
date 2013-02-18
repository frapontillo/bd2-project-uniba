#!/bin/sh
DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY
./_build.sh
cd $DIRECTORY/dist
./_war.sh