#!/usr/bin/env bash

WORKDIR="/work-dir"

for i in "$@"
do
case $i in
    -c=*|--config-dir=*)
    CONFIGDIR="${i#*=}"
    shift
    ;;
    -w=*|--work-dir=*)
    WORKDIR="${i#*=}"
    shift
    ;;
    *)
    # unknown option
    ;;
esac
done

echo installing into "${WORKDIR}"
mkdir -p "${WORKDIR}"
cp /usr/local/bin/lookup-srv "${WORKDIR}"/
