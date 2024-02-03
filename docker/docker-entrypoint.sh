#!/bin/bash

set -x

HOME=/opt/erfwong
SHELL=/bin/sh

USER_ID=`stat -c '%u' /opt/erfwong`
GROUP_ID=`stat -c '%g' /opt/erfwong`

