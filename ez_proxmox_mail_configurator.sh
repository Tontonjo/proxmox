#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# Script for easy setup of Proxomox email settings.
# Tested working with gmail and infomaniak mail servers using TLS

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
# http://mhawthorne.net/posts/2011-postfix-configuring-gmail-as-relay/

# Files:
# "/etc/aliases"
# "/etc/postfix/main.cf"
# "/etc/postfix/canonical"
# Logs:
# "/var/log/mail.*"

varversion=1.6
#V1.0: Initial Release - proof of concept
#V1.1: Small corrections
#V1.2: Add sender address ask if same as auth mail, if so use it, else ask for value
#V1.3: Delete sasl_password file
#V1.4: Removing useless echo and canonical backup
#V1.5: Add menu to check logs for known errors - add error "SMTPUTF8 was required" and corrections
#V1.6: Change sed for postmap command / swap restore and fix menus

if [ $(dpkg-query -W -f='${Status}' libsasl2-modules 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y libsasl2-modules;
fi

# Backuping files before anything

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

show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}**************************** EZ PROXMOX MAIL CONFIGURATOR *********************************${NORMAL}"
    echo -e "${MENU}*************************** Tonton Jo - 2020 - Version $varversion ********************************${NORMAL}"
    echo -e "${MENU}**************** https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw ******************${NORMAL}"
    echo " "
    echo -e "${MENU}**${NUMBER} 1)${MENU} Configure ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Test ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Check logs for error - attempt to correct ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} Restore original conf ${NORMAL}"
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
			echo "System destination mail address (user@domain.tld) (root alias): "
			read 'varrootmail'
			echo "What is the mail server hostname? (smtp.gmail.com): "
			read 'varmailserver'
			echo "What is the mail server port? (Usually 587 - can be 25 (no tls)): "
			read 'varmailport'
			echo "What is the AUTHENTIFICATION USERNAME? (user@domain.tld or username): "
			read 'varmailusername'
			echo "What is the AUTHENTIFICATION PASSWORD?: "
			read 'varmailpassword'
			read -p  "Is the SENDER mail address the same as the AUTHENTIFICATION USERNAME? y to use $varmailusername enter to set something else: " -n 1 -r 
			if [[ $REPLY =~ ^[Yy]$ ]]; then
			varsenderaddress=$varmailusername
			else
			echo "What is the sender address?: "
			read 'varsenderaddress'
			fi
			echo " "
			read -p  "Use TLS?: y = yes / anything=no: " -n 1 -r 
			if [[ $REPLY =~ ^[Yy]$ ]]; then
			vartls=yes
			else
			vartls=no
			fi
					
			
		echo "- Working on it!"
		echo " "
		echo "- Setting Aliases"
		if grep "root:" /etc/aliases
			then
			echo "- Aliases entry was found: editing for $varrootmail"
			sed -i "s/^root:.*$/root: $varrootmail/" /etc/aliases
		else
			echo "- No root alias found: Adding"
			echo "root: $varrootmail" >> /etc/aliases
			
		fi
		
		#Setting canonical file for sender - :
		echo "root $varsenderaddress" > /etc/postfix/canonical
		chmod 600 /etc/postfix/canonical
		
		# Preparing for password hash
		echo [$varmailserver]:$varmailport $varmailusername:$varmailpassword > /etc/postfix/sasl_passwd
		chmod 600 /etc/postfix/sasl_passwd 
		
		# Add mailserver in main.cf
		sed -i "/#/!s/\(relayhost[[:space:]]*=[[:space:]]*\)\(.*\)/\1"[$varmailserver]:"$varmailport""/"  /etc/postfix/main.cf
		
		# Checking TLS settings
		echo "- Setting correct TLS Settings: $vartls"
		postconf smtp_use_tls=$vartls
		
		# Checking for password hash entry
			if grep "smtp_sasl_password_maps" /etc/postfix/main.cf
			then
			echo "- Password hashe looks setted-up"
		else
			echo "- Adding password hash entry"
			postconf smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
		fi
		#checking for certificate
		if grep "smtp_tls_CAfile" /etc/postfix/main.cf
			then
			echo "- TLS CA File looks setted-up"
			else
			postconf smtp_tls_CAfile=/etc/ssl/certs/ca-certificates.crt
		fi
		# Adding sasl security options
	    # eliminates default security options which are imcompatible with gmail
		if grep "smtp_sasl_security_options" /etc/postfix/main.cf
			then
			echo "- Google smtp_sasl_security_options looks setted-up"
			else
			postconf smtp_sasl_security_options=noanonymous
		fi
		if grep "smtp_sasl_auth_enable" /etc/postfix/main.cf
			then
			echo "- Authentification looks enable - Good"
			else
			postconf smtp_sasl_auth_enable=yes
		fi 
		if grep "sender_canonical_maps" /etc/postfix/main.cf
			then
			echo "- Canonical entry found - Good"
			else
			postconf sender_canonical_maps=hash:/etc/postfix/canonical
		fi 
		
		echo "- Encrypting password and canonical entry"
		postmap /etc/postfix/sasl_passwd
		postmap /etc/postfix/canonical
		echo "- Restarting postfix and enable automatic startup"
		systemctl restart postfix && systemctl enable postfix
		echo "- Cleaning file used to generate password hash"
		rm -rf "/etc/postfix/sasl_passwd"
		echo "- Files cleaned"
		
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
		echo "- Email should have been sent - If none received, you may want to check for errors in menu 3"
	  
	  show_menu;	
      ;;
	        3) clear;
			echo "- Checking for known errors that may be found in logs"
			if grep "SMTPUTF8 is required" "/var/log/mail.log"
			then
			echo "- Errors may have been found "
			read -p "Looks like there's a error as SMTPUTF8 was required but not supported: try to fix? y = yes / anything=no: " -n 1 -r
				if [[ $REPLY =~ ^[Yy]$ ]]
				then
					if grep "smtputf8_enable = no" /etc/postfix/main.cf
					then
					echo "- Fix looks already applied!"
					else
					echo " "
					echo "- Setting "smtputf8_enable=no" to correct "SMTPUTF8 was required but not supported""
					postconf smtputf8_enable=no
					postfix reload
				  fi 
				fi
		        else
			echo "- No configured error found - nothing to do!"
			fi
	  show_menu;	
      ;;
      4) clear;
		read -p "Do you really want to restore: y=yes - Anything=no: " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]
				then
					echo " "
					echo "- Restoring default configuration files"
				        cp -rf /etc/aliases.BCK /etc/aliases
					cp -rf /etc/postfix/main.cf.BCK /etc/postfix/main.cf
					echo "- Restarting services "
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
