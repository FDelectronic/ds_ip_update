#!/bin/bash
dsURL="/run/media/fox_devil/fox_hole/Workgroup/Del_Test/ds_ip_update"
oURL="/run/media/fox_devil/fox_hole/Del_Test/ds_ip_update"
dsLogin="Логин"
dsPass="Пароль"
serial=$(grep Serial /proc/cpuinfo | cut -b 11)
curl -s -u $dsLogin:$dsPass $dsURL/version -o $oURL
cat $oURL/version >> $oURL/$serial.sra
curl -s --upload-file $oURL/$serial.sra -u $dsLogin:$dsPass $dsURL/List/
rm $oURL/$serial.sra
exit
