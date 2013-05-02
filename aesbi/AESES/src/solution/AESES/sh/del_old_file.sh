#!/bin/bash

find /usr/local/data/bi_data/ERCOT/ERCOT_RT_Energy -type f -mtime +5 -exec rm -f -r {} \;

find /usr/local/data/bi_data/ERCOT/ERCOT_DAM_Energy -type f -mtime +10 -exec rm -f -r {} \;

find /usr/local/data/bi_data/ERCOT/ERCOT_DAM_Ancillary -type f -mtime +10 -exec rm -f -r {} \;

find /usr/local/data/bi_data/ERCOT/ERCOT_Ancillary_plan -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/ERCOT/ERCOT_Capacity -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/iso-ne -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/caiso -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/caiso_volume -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/logs/fleetpro.log -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/logs/kettlepro.log -type f -mtime +10 -exec rm -f -r {} \; 

find /usr/local/data/bi_data/logs/miso.log -type f -mtime +10 -exec rm -f -r {} \;






