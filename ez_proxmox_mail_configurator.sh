#!/bin/bash

# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw

# Script for easy setup of Proxomox email settings for gmail
# Tested working with gmail and infomaniak mail servers.

# DISCLAIMER
# I assume you know what you are doing have a backup and have a default configuration.
# I'm responsible in no way if something get broken - even if there's likely no chance to happen:-)
# I am no programmer - just tying to get some begginers life a bit easier
# There will be bugs or things i did not thinked about - sorry - if so, try to solve-it yourself, let me kindly know and PR:-)

# USAGE
# You can run this scritp directly using:
# wget https://raw.githubusercontent.com/Tontonjo/proxmox/master/ez_proxmox_mail_configurator.sh
# bash ez_proxmox_mail_configurator.sh

# GMAIL: you need to allow less secure applications: 
# https://myaccount.google.com/lesssecureapps

# Sources: 
# https://forum.proxmox.com/threads/how-do-i-set-the-mail-server-to-be-used-in-proxmox.23669/
# https://linuxscriptshub.com/configure-smtp-with-gmail-using-postfix/
# https://suoption_pickedpport.google.com/accounts/answer/6010255
# https://www.howtoforge.com/community/threads/solved-problem-with-outgoing-mail-from-server.53920/

# Files:
# "/etc/aliases"
# "/etc/postfix/main.cf"
# "/etc/postfix/canonical"
# "/etc/postfix/sasl_passwd"

varversion=1.1
#V1.0: Initial Release - proof of concept
#V1.1: Small corrections

if [ $(dpkg-query -W -f='${Status}' libsasl2-modules 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y libsasl2-modules;
fi

echo "I assume you know what you are doing have a backup and have a default configuration.
this is aimed for simple gmail and may not work for every mail server"

echo "backuping files before anything modifications - this wont be done if existing backup exist"

ALIASESBCK=/etc/aliases.BCK
if test -f "$ALIASESBCK"; then
    echo "$ALIASESBCK Already exist - Skipping"
	else
	cp -n /etc/aliases /etc/aliases.BCK
	echo "backuped "$ALIASESBCK""
fi
MAINCFBCK=/etc/postfix/main.cf.BCK
if test -f "$MAINCFBCK"; then
    echo "$MAINCFBCK Already exist - Skipping"
	else
	cp -n /etc/postfix/main.cf /etc/postfix/main.cf.BCK
	echo "backuped "$MAINCFBCK""
fi
CANONICALBCK=/etc/postfix/canonical
if test -f "$CANONICALBCK"; then
    echo "$CANONICALBCK file exist - backuping in case"
	cp -n /etc/postfix/canonical /etc/postfix/canonical.BCK
	else
	echo "no $CANONICALBCK file - Skipping"
fi

show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}**************************** PROXMOX EZ MAIL CONFIGURATOR *********************************${NORMAL}"
    echo -e "${MENU}************************ Tonton Jo - 2020 Version $varversion *********************************${NORMAL}"
    echo -e "${MENU}*********** https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw *********************************${NORMAL}"
    echo " "
    echo -e "${MENU}**${NUMBER} 1)${MENU} Configure ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Test ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Restore original conf ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 0)${MENU} Exit ${NORMAL}"
    echo " "
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read -rsn1 opt
	while [ opt != '' ]
  do
    if [[ $opt = "" ]]; then
      exit;
    else
      case $opt in
      1) clear;
			echo "Destination mail Adresse: "
			read 'varrootmail'
			echo "What is the mail server hostname? (smtp.gmail.com): "
			read 'varmailserver'
			echo "What is the mail server port? (Usually 587 - can be 25 (no tls)): "
			read 'varmailport'
			echo "What is the AUTHENTIFICATION USERNAME? (xxx@xxxx.com or username): "
			read 'varmailusername'
			echo "What is the AUTHENTIFICATION PASSWORD?: "
			read 'varmailpassword'
			read -p  "Use TLS?: y = yes / anything=no: " -n 1 -r 
			if [[ $REPLY =~ ^[Yy]$ ]]; then
			vartls=yes
			else
			vartls=no
			fi
					
			
		echo "- working on it!"
		echo "- Setting Aliases"
		if grep "root:" /etc/aliases
			then
			echo "- Aliases entry was found: editing for $varrootmail"
			sed -i "s/^root:.*$/root: $varrootmail/" /etc/aliases
		else
			echo "- no root alias found: Adding"
			echo "root: $varrootmail" >> /etc/aliases
			
		fi
		#Setting canonical file for sender - :
		echo "root $varrootmail" > /etc/postfix/canonical
		chmod 600 /etc/postfix/canonical
		
		# Preparing for password hash
		echo [$varmailserver]:$varmailport $varmailusername:$varmailpassword > /etc/postfix/sasl_passwd
		chmod 600 /etc/postfix/sasl_passwd 
		
		sed -i "/#/!s/\(relayhost[[:space:]]*=[[:space:]]*\)\(.*\)/\1"[$varmailserver]:"$varmailport""/"  /etc/postfix/main.cf
		
		# Checking TLS settings
		if grep "smtp_use_tls" /etc/apt/sources.list /etc/postfix/main.cf
			then
			echo "- TLS value found: Setting TLS entry"
			sed -i "/#/!s/\(smtp_use_tls[[:space:]]*=[[:space:]]*\)\(.*\)/\1"$vartls"/"  /etc/postfix/main.cf
		else
			echo "- No TLS entry: adding"
			echo "smtp_use_tls = $vartls" >> /etc/postfix/main.cf
			
		fi
		# Checking for password hash entry
				if grep "smtp_sasl_password_maps" /etc/postfix/main.cf
			then
			echo "- Password hashe looks setted-up"
		else
			echo "- Adding password hash entry"
			echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
		fi
		#checking for certificate
		if grep "smtp_tls_CAfile" /etc/postfix/main.cf
			then
			echo "- TLS CA File looks setted-up"
			else
			echo "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> /etc/postfix/main.cf
		fi
		# Adding sasl security options
	    # eliminates default security options which are imcompatible with gmail
		if grep "smtp_sasl_security_options" /etc/postfix/main.cf
			then
			echo "- Google smtp_sasl_security_options looks setted-up"
			else
			echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
		fi
		if grep "smtp_sasl_auth_enable" /etc/postfix/main.cf
			then
			echo "- Authentification looks enable - Good"
			else
			echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
		fi 
		if grep "sender_canonical_maps" /etc/postfix/main.cf
			then
			echo "- Canonical entry found - Good"
			else
			echo "sender_canonical_maps = hash:/etc/postfix/canonical" >> /etc/postfix/main.cf
		fi 
		
		echo "- Encrypting password and canonical entry"
		postmap /etc/postfix/sasl_passwd
		postmap /etc/postfix/canonical
		echo "- Restarting postfix and enable automatic startup"
		systemctl restart postfix && systemctl enable postfix
		
      show_menu;
      ;;

     2) clear;
		echo "Destination mail address? :"
		read vardestaddress
		echo "- An email will be sent to: $vardestaddress"
		echo "Enter Email subject: "
		read "varsubject"
		echo "- Enter the body of your test message then press ctrl-d"
		echo "- When asked for CC - press enter again"
		echo "  --------- Enter mail body ----------------"
		mail -s "$varsubject" "$vardestaddress"
	  
	  show_menu;	
      ;;

      3) clear;
		read -p "Do you really want to restore: y=yes - Anything=no: " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]
				then
					echo " "
					echo "- Restoring default configuration files"
				    cp -rf /etc/aliases.BCK /etc/aliases
					cp -rf /etc/postfix/main.cf.BCK /etc/postfix/main.cf
					cp -rf /etc/postfix/canonical.BCK /etc/postfix/canonical
					echo "- Restoration done - restarting services "
					systemctl restart postfix
					echo "- Restoration done"
			fi

	  show_menu;	
      ;;
      0) clear;
      exit
      ;;

      x)exit;
      ;;

      \n)exit;
      ;;

      *)clear;
      show_menu;
      ;;
      esac
    fi
  done
}

clear
show_menu
