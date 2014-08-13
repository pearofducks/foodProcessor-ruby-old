#!/bin/sh

docker run -d --name foodprocessor -v $1:/in -v $2:/out foodprocessor_image
