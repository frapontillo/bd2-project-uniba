#!/bin/sh
DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY
jar cvf mall.war *