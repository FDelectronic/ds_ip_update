#!/bin/bash

dsURL="/run/media/fox_devil/fox_hole/Workgroup/Del_Test/ds_ip_update"
oURL="/run/media/fox_devil/fox_hole/Del_Test/ds_ip_update"
dsLogin="Логин"
dsPass="Пароль"
serial=$(grep Serial /proc/cpuinfo | cut -b 11)
#serial="4688h8f3"
clear
#Фаил kill.sh нужен для запуска новых бу
#Проверяем на наличие файла kill.sh
if [[ -r $oURL/kill.sh ]];
then
  rm -f $oURL/kill.sh
  sudo reboot
fi

if [[ -r $oURL/reset.rst ]];#Проверяем наличие файла reset.rst
then
   rm -f $oURL/reset.rst
   sudo reboot
else
   if [[ -r $oURL/version ]];# Проверяем наличие файла version
   then
     curl -s -u $dsLogin:$dsPass $dsURL/status/$serial.rsa -o $oURL
     dsJUMP=$(cat $oURL/version)
     oJUMP=$(cat $oURL/$serial.sra)
     if [[ $dsJUMP == $oJUMP ]]; # Проверяем сообветствую ли версии
     then
        echo '=-)'
     else
        cat $oURL/$serial.sra > $oURL/version
        echo 'curl -s -u $dsLogin:$dsPass $dsURL/update.sh -o $oURL && sh update.sh'
     fi
   else
      curl -s -u $dsLogin:$dsPass $dsURL/version -o $oURL
      cat $oURL/version >> $oURL/$serial.sra
      #Записываем Логи
      curl -s --upload-file $oURL/$serial.sra -u $dsLogin:$dsPass $dsURL/List/
      rm $oURL/$serial.sra
      rm $oURL/version
      sleep 30
      curl -s -u $dsLogin:$dsPass $dsURL/status/$serial.rsa -o $oURL
      if [[ -r $oURL/$serial.sra ]];# Проверяем наличие файла serial.sra
      then
         echo 'curl -s -u $dsLogin:$dsPass $dsURL/update.sh -o $oURL && sh update.sh'
      else
         #Отпровляем отчёт об неудачном обновлении папка BUG
      fi
   fi
fi
exit
