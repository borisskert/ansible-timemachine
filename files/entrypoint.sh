#!/bin/bash

touch /var/lock/netatalk

# to prevent cnid_metad[11] {cnid_metad.c:321} (error:CNID): set_dbdir: mkdir failed for /var/netatalk/CNID//*/ error
mkdir -p /var/netatalk/CNID

/usr/sbin/netatalk -d
