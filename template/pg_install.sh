HM=`pwd`
if [ -f "$HM/.bash_profile" ]; then
	. "$HM"/.bash_profile
	if [ "$?" != "0" ]; then
		source "$HM"/.bash_profile
	fi
elif [ -f "$HM/.profile" ]; then
	. "$HM"/.profile
	if [ "$?" != "0" ]; then
		source "$HM"/.profile
	fi
fi
INSTALL_DIR="$1"
if [ "$INSTALL_DIR" = "" ]; then
	INSTALL_DIR=`pwd`
fi
TODAY=`date +%Y%m%d%H%M%S`
VBS=""
ERRCHK=64
LANG=en_US.UTF8
echo "#####################################################################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#####################################################################################"
echo "#                                                                                   #" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#                                                                                   #"
echo "#                              PostgreSQL INSTALL Log                               #" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#                              PostgreSQL INSTALL Log                               #"
echo "#                                                                                   #" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#                                                                                   #"
echo "#####################################################################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#####################################################################################"
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "#######################--------PARAMETER CHECK START--------##########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#######################--------PARAMETER CHECK START--------##########################"
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
if [ ! -f "$INSTALL_DIR"/parameter.sh ]; then
	echo "parameter.sh file is not exsist" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "parameter.sh file is not exsist"
	exit 1
else
	FF="$INSTALL_DIR"/parameter.sh
	FT="$INSTALL_DIR"/parameter_bak.sh
	'cp' "$FF" "$FT"
	echo ENGINE > "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGDATA >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGWAL >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGARCH >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGLOG >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo OSUSER >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo OSPASS >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGUSER >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGPASS >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PGDATABASE >> "$INSTALL_DIR"/bkbspark_wt.txt
	echo PARAMETER_ADD >> "$INSTALL_DIR"/bkbspark_wt.txt
	while read B
	do
		if [ "$B" != "PARAMETER_ADD" ]; then
			TEMP1=`TEMP1=\`cat "$FF" | grep -n "^${B}="\`;i=$((${#TEMP1}-1));echo ${TEMP1:$i:1}`
			TEMP2=`TEMP2=\`cat "$FF" | grep -n "^${B}=" |awk -F '=' '{print $2}'\`;echo ${TEMP2:0:1}`
		else
			TEMP1=`TEMP1=\`cat "$FF" | grep -n "^${B}=" | sed 's/ //g'\`;i=$((${#TEMP1}-1));echo ${TEMP1:$i:1}`
			TEMP2=`TEMP2=\`cat "$FF" | grep -n "^${B}=" | sed 's/ //g' |awk -F '=' '{print $2}'\`;echo ${TEMP2:0:1}`
		fi
		TEMPN=`cat "$FF" | grep -n "^${B}=" | awk -F ':' '{print $1}'`
		TEMPV=`cat "$FF" | grep -n "^${B}=" | awk -F '=' '{for(i=2;i<=NF;i++){if(i==NF){printf"%s",$i} else{printf"%s=",$i}}}' |sed 's/\//\\\\\//g'`
		if [ "$TEMP1" != "\"" ] && [ "$TEMP2" != "\"" ]; then
				sed ''"$TEMPN"'s/.*/'"$B"'=\"'"$TEMPV"'\"/g' "$FF" > "$FT"
		elif [ "$TEMP1" != "\"" ] && [ "$TEMP2" = "\"" ]; then
				sed ''"$TEMPN"'s/.*/'"$B"'='"$TEMPV"'\"/g' "$FF" > "$FT"
		elif [ "$TEMP1" = "\"" ] && [ "$TEMP2" != "\"" ]; then
				sed ''"$TEMPN"'s/.*/'"$B"'=\"'"$TEMPV"'/g' "$FF" > "$FT"
		fi
		'cp' "$FT" "$FF"
	done < "$INSTALL_DIR"/bkbspark_wt.txt
	rm -rf "$INSTALL_DIR"/bkbspark_wt.txt
	source "$FF"
	rm -rf "$FT"
	rm -rf "$FF"
	echo "`date`" > "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
	rm -rf "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	VBS=`echo "\"\`date\`\""`
	if [ "$OSUSER" = "" ]; then
		OSUSER="postgres"
	fi
	ps -ef | grep -v "grep" | grep postgres | grep "$OSUSER" &>/dev/null
	if [ "0" = "$?" ]; then
		RUNPID=`ps -ef | grep -v "grep" | grep postgres | grep $OSUSER | grep "/postgres" | awk '{print $2}'`
		echo "There is a Postgresql DB running due to the OS user you specified : $OSUSER. Check the PID: $RUNPID currently running on the server, then run the script again.">> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "There is a Postgresql DB running due to the OS user you specified : $OSUSER. Check the PID: $RUNPID currently running on the server, then run the script again." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"There is a Postgresql DB running due to the OS user you specified : $OSUSER. Check the PID: $RUNPID currently running on the server, then run the script again.\""`
		echo "There is a Postgresql DB running due to the OS user you specified : $OSUSER. Check the PID: $RUNPID currently running on the server, then run the script again."
		BINCHK=1
		ERRCHK=16
	fi
fi
echo \\\$DB_VERSION > "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$MAX_CONNECTION >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGPORT >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$ENGINE >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGDATA >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGWAL >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGARCH >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGLOG >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$LOCALE >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$OSUSER >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGUSER >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$OSPASS >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGPASS >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$PGDATABASE >> "$INSTALL_DIR"/bkbspark_wt.txt
echo \\\$INSTALL_DIR >> "$INSTALL_DIR"/bkbspark_wt.txt
while read i
do
	STRING="$i"
	A=$(eval echo "${STRING}")
	B=("`echo "${i}"|sed 's/\\\$//g'`")
	if [ "$A" = "" ]; then
		if [ "$B" = "OSUSER" ] || [ "$B" = "PGUSER" ] || [ "$B" = "OSPASS" ] || [ "$B" = "PGPASS" ] || [ "$B" = "PGDATABASE" ]; then
			export $B=postgres
		elif [ "$B" = "LOCALE" ]; then
			export $B=C
		elif [ "$B" = "PGPORT" ]; then
			export $B=5432
		elif [ "$B" = "PGLOG" ]; then
			export $B="bkbspark"
		elif [ "$B" = "ENGINE" ]; then
			export $B=/usr/pgsql-${DB_VERSION}
		elif [ "$B" = "PGWAL" ]; then
			export $B="bkbspark"
		elif [ "$B" = "PGARCH" ]; then
			export $B="bkbspark"
			ARCHIVE_COMMAND="'true'"
		else
			echo "$B is NULL Value. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "$B is NULL Value. Please check parameter $B in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"$B is NULL Value. Please check parameter $B in Excel file And retry script.\""`
			echo "$B is NULL Value. Please check parameter $B in parameter.sh file And retry script."
			export $B="bkbspark"
			ERRCHK=16
		fi
	elif [ "$A" != "" ]; then
		if [ "$B" = "DB_VERSION" ]; then
			if [ "$A" != "9.3" ] && [ "$A" != "9.4" ] && [ "$A" != "9.5" ] && [ "$A" != "9.6" ] && [ "$A" != "10" ] && [ "$A" != "11" ] && [ "$A" != "12" ] && [ "$A" != "13" ]; then
				echo "The value of $B must be one of 9.4, 9.5, 9.6, 10, 11, 12. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The value of $B must be one of 9.4, 9.5, 9.6, 10, 11, 12. Please check parameter $B in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The value of $B must be one of 9.4, 9.5, 9.6, 10, 11, 12. Please check parameter $B in Excel file And retry script.\""`
				echo "The value of $B must be one of 9.4, 9.5, 9.6, 10, 11, 12. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
		elif [ "$B" = "PGPORT" ] || [ "$B" = "MAX_CONNECTION" ]; then
			if [ ! -z "${A//[0-9]/}" ]; then 
				echo "The $B : $A is not number. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B : $A is not number. Please check parameter $B in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B : $A is not number. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B : $A is not number. Please check parameter $B in parameter.sh file And retry script."
				export $B="bkbspark"
				ERRCHK=16
			else
				if [ "$B" = "MAX_CONNECTION" ] && [ "$A" -ge "800" ]; then
					SEMMNI_VAL=`echo $MAX_CONNECTION|awk '{printf"%.0f",$1/1000}'|awk '{printf"%d",($1*100)+100}'`
					SEMMNS_VAL=`echo 250 $SEMMNI_VAL|awk '{printf"%d",$1*$2}'`
					cat >>/etc/sysctl.conf<<EOFF
kernel.sem=250 $SEMMNS_VAL 250 $SEMMNI_VAL
EOFF
					/sbin/sysctl -p&>/dev/null
				fi
			fi
		elif [ "$B" = "INSTALL_DIR" ]; then
			echo "$A" | grep "$ENGINE"
			if [ "$?" = "0" ]; then
				echo "The $B directory you specify( $A ) cannot be under the ENGINE( $ENGINE ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B directory you specify( $A ) cannot be under the ENGINE( $ENGINE ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B directory you specify( $A ) cannot be under the ENGINE( $ENGINE ) directory. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B directory you specify( $A ) cannot be under the ENGINE( $ENGINE ) directory. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
			echo "$A" | grep "$PGDATA"
			if [ "$?" = "0" ]; then
				echo "The $B directory you specify( $A ) cannot be under the PGDATA( $PGDATA ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B directory you specify( $A ) cannot be under the PGDATA( $PGDATA ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B directory you specify( $A ) cannot be under the PGDATA( $PGDATA ) directory. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B directory you specify( $A ) cannot be under the PGDATA( $PGDATA ) directory. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
			echo "$A" | grep "$PGWAL"
			if [ "$?" = "0" ]; then
				echo "The $B directory you specify( $A ) cannot be under the PGWAL( $PGWAL ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B directory you specify( $A ) cannot be under the PGWAL( $PGWAL ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B directory you specify( $A ) cannot be under the PGWAL( $PGWAL ) directory. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B directory you specify( $A ) cannot be under the PGWAL( $PGWAL ) directory. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
			echo "$A" | grep "$PGARCH"
			if [ "$?" = "0" ]; then
				echo "The $B directory you specify( $A ) cannot be under the PGARCH( $PGARCH ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B directory you specify( $A ) cannot be under the PGARCH( $PGARCH ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B directory you specify( $A ) cannot be under the PGARCH( $PGARCH ) directory. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B directory you specify( $A ) cannot be under the PGARCH( $PGARCH ) directory. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
			echo "$A" | grep "$PGLOG"
			if [ "$?" = "0" ]; then
				echo "The $B directory you specify( $A ) cannot be under the PGLOG( $PGLOG ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "The $B directory you specify( $A ) cannot be under the PGLOG( $PGLOG ) directory. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"The $B directory you specify( $A ) cannot be under the PGLOG( $PGLOG ) directory. Please check parameter $B in Excel file And retry script.\""`
				echo "The $B directory you specify( $A ) cannot be under the PGLOG( $PGLOG ) directory. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
		elif [ "$B" = "OSUSER" ]; then
			echo "$A"| grep -E "\ |\!|\@|\#|\%|\^|\&|\*|\(|\)|\+|\=|\`|\~|\?|\,|<|>|\:|\;|\"|'|\||\{|\}|\[|\]|\/|\\\\"&>/dev/null
			if [ "$?" = "0" ]; then
				echo "$B contains an invalid character. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "$B contains an invalid character. Please check parameter $B in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"$B contains an invalid character. Please check parameter $B in Excel file And retry script.\""`
				echo "$B contains an invalid character. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
		elif [ "$B" = "PGUSER" ] || [ "$B" = "PGDATABASE" ]; then
			echo "$A"| grep -E "\ |\!|\@|\#|\%|\^|\&|\*|\(|\)|\+|\=|\`|\~|\?|\,|<|>|\:|\;|\"|'|\||\{|\}|\[|\]|\/|\\\\|\-|\."&>/dev/null
			if [ "$?" = "0" ]; then
				echo "$B contains an invalid character. Please check parameter $B in parameter.sh file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "$B contains an invalid character. Please check parameter $B in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"$B contains an invalid character. Please check parameter $B in Excel file And retry script.\""`
				echo "$B contains an invalid character. Please check parameter $B in parameter.sh file And retry script."
				ERRCHK=16
			fi
		elif [ "$B" = "PGARCH" ]; then
			ARCHIVE_COMMAND="'cp %p \"$A\"/%f'"
		fi
	fi
done < "$INSTALL_DIR"/bkbspark_wt.txt
rm -rf "$INSTALL_DIR"/bkbspark_wt.txt
USER="su - $OSUSER -c"
#####################---------VERSION CACULATE START--------##########################
if [ -f /etc/redhat-release ]; then
	SYSVER=`cat /etc/redhat-release | awk -F '.' '{print $1}'| awk '{print $NF}'`
	SYSSORT=`cat /etc/redhat-release | awk '{print $1}'`
	if [ "$SYSSORT" = "Red" ]; then
		SYSSORT="Redhat"
	else
		SYSSORT="CentOS"
	fi
	BIT=`getconf LONG_BIT`
	if [ "$BIT" = "64" ]; then
			BIT="x86_64"
			WBIT="i686"
	else
			BIT="i686"
			WBIT="x86_64"
	fi
fi
DB_VERSION_TEMP=`echo $DB_VERSION|sed 's/\.//g'`
DB_VERSION_MAJOR=`echo $DB_VERSION|awk '{print $1*10}'`
if [ "$DB_VERSION_MAJOR" -gt "100" ]; then
	WAL_OPT="--wal-segsize=64"
	WAL=wal
	LG=log
else
	if [ "$DB_VERSION_MAJOR" = "100" ]; then
		WAL=wal
		LG=log
	else
		WAL=xlog
		LG=pg_log
	fi
fi
if [ "$PGWAL" = "bkbspark" ]; then
	INTW=""
else
	INTW="-X \"$PGWAL\""
fi
if [ "$2" != "" ] && [ "$2" != "`hostname`${SYSSORT}_${SYSVER}_`getconf LONG_BIT`bit" ]; then
	echo "The $2 version you entered and the current server version ${SYSSORT}_${SYSVER}_`getconf LONG_BIT`bit are different." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "Please check OS type in Excel file And retry script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "The $2 version you entered and the current server version ${SYSSORT}_${SYSVER}_`getconf LONG_BIT`bit are different." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
	echo "Please check OS type in Excel file And retry script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
	VBS=`echo "$VBS & Chr(10) & \"The $2 version you entered and the current server version ${SYSSORT}_${SYSVER}_\`getconf LONG_BIT\`bit are different.\""`
	VBS=`echo "$VBS & Chr(10) & \"Please check OS type in Excel file And retry script.\""`
	echo "The $2 version you entered and the current server version ${SYSSORT}_${SYSVER}_`getconf LONG_BIT`bit are different."
	echo "Please check OS type in Excel file And retry script."
	ERRCHK=16
fi
if [ "$PGLOG" = "bkbspark" ]; then
	PGLOGP=""
else
	PGLOGP="log_directory = '$PGLOG'"
fi
#####################---------VERSION CACULATE FINISH--------#########################
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "#######################--------PARAMETER CHECK FINISH--------#########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "#######################--------PARAMETER CHECK FINISH--------#########################"
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "############--------INSTALL DIRECTORY & OWNERSHIP CHECK START--------#################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "############--------INSTALL DIRECTORY & OWNERSHIP CHECK START--------#################"
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "$ENGINE" > "$INSTALL_DIR"/bkbspark_wt.txt
echo "$PGDATA" >> "$INSTALL_DIR"/bkbspark_wt.txt
echo "$PGWAL" >> "$INSTALL_DIR"/bkbspark_wt.txt
echo "$PGARCH" >> "$INSTALL_DIR"/bkbspark_wt.txt
echo "$PGLOG" >> "$INSTALL_DIR"/bkbspark_wt.txt
while read i
do
	if [ ! -d "$i" ]; then
		if [ "$i" != "bkbspark" ] && [ "$i" != "/usr/pgsql-${DB_VERSION}" ] && [ "$BINCHK" != "1" ]; then
			echo "You Must create $i directory." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "You Must create $i directory." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"You Must create $i directory.\""`
			echo "You Must create $i directory."
			echo "Please make $i directory and retry this script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "Please make $i directory and retry this script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"Please make $i directory and retry this script.\""`
			echo "Please make $i directory and retry this script."
			ERRCHK=16
		fi
	else
		A=`ls -ld "$i" | awk '{print $3}'`
		LC=`ls "$i" | wc -l`&>/dev/null
		if [ "$LC" != "0" ] && [ "$BINCHK" != "1" ]; then
			echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo ""
			echo "$i Directory's has some files, Please remove files in $i and retry this script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "$i Directory's has some files, Please remove files in $i and retry this script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"$i Directory's has some files, Please remove files in $i and retry this script.\""`
			echo "$i Directory's has some files, Please remove files in $i and retry this script."
			ERRCHK=16
		fi
		if [ "$A" != "root" ] && [ "$BINCHK" != "1" ]; then
			if [ "$A" = "$OSUSER" ]; then
				chown -R root. "$i"
			else
				echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo ""
				echo "$i Directory's Ownership is not 'root' Please Change Ownership to 'root' And retry this script." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "$i Directory's Ownership is not 'root' Please Change Ownership to 'root' And retry this script." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"$i Directory's Ownership is not 'root' Please Change Ownership to 'root' And retry this script.\""`
				echo "$i Directory's Ownership is not 'root' Please Change Ownership to 'root' And retry this script."
				ERRCHK=16
			fi
		fi
	fi
done < "$INSTALL_DIR"/bkbspark_wt.txt
rm -rf "$INSTALL_DIR"/bkbspark_wt.txt
##################---------MEM_parameter_CACULATE START--------#######################

MEM=`free -m | grep Mem | awk '{printf"%.0f",$2/1024}'| awk '{printf"%.0f",$1*1024}'`
SB=`echo $MEM | awk '{printf "%.0f", $1/4}'`
MWM=`echo $MEM | awk '{printf "%.0f", $1/16}'`
WM=1
if [ "$MAX_CONNECTION" != "bkbspark" ]; then 
#	F=`echo $MEM $SB $MWM $MAX_CONNECTION| awk '{printf "%.0f",($1-$2-$3)/$4}'`
#	while [ "$F" -ge "$WM" ]
#	do
#		WM=`echo $WM | awk '{printf "%.0f", $1*2}'`
#	done
#	if [ "$F" != "$WM" ]; then
#		WM=`echo $WM | awk '{printf "%.0f", $1/2}'`
#	fi
	WM=`echo $MEM $SB $MWM $MAX_CONNECTION| awk '{printf"%.0f",(($1-$2-$3)/$4)/10}'| awk -F '.' '{printf"%d",$1*10}'`
	if [ "$WM" = "0" ]; then
		WM=16
	fi
fi
SB=$SB'MB'
MWM=$MWM'MB'
WM=$WM'MB'
EFCS=`echo $MEM|awk '{printf"%.0f",($1*0.75)}'`MB

##################---------MEM_parameter_CACULATE FINISH--------######################

echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "############--------INSTALL DIRECTORY & OWNERSHIP CHECK FINISH--------###############" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "############--------INSTALL DIRECTORY & OWNERSHIP CHECK FINISH--------###############"
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
echo "DB_VERSION     : $DB_VERSION"
echo "ENGINE         : $ENGINE"
echo "PGDATA         : $PGDATA"
if [ "$PGWAL" = "bkbspark" ]; then
	echo "PGWAL          : ${PGDATA}/pg_${WAL}"
else
	echo "PGWAL          : $PGWAL"
fi
if [ "$PGARCH" = "bkbspark" ]; then
	echo "PGARCH         : No Archive Mode"
else
	echo "PGARCH         : $PGARCH"
fi
if [ "$PGLOG" = "bkbspark" ]; then
	echo "PGLOG          : ${PGDATA}/${LG}"
else
	echo "PGLOG          : $PGLOG"
fi
echo "PGPORT         : $PGPORT"
echo "OSUSER         : $OSUSER"
echo "OSPASS         : $OSPASS"
echo "PGUSER         : $PGUSER"
echo "PGPASS         : $PGPASS"
echo "PGDATABASE     : $PGDATABASE"
echo "LOCALE         : $LOCALE"
echo "MAX_CONNECTION : $MAX_CONNECTION"
while [ "$ANS" != "yes" ] && [ "$ANS" != "no" ]
do
	echo -n "You set the parameters as above. Would you like to proceed with the installation? (yes or no) : "
	read ANS
	if [ "$ANS" = "YES" ] || [ "$ANS" = "Yes" ] || [ "$ANS" = "yEs" ] || [ "$ANS" = "yeS" ] || [ "$ANS" = "yES" ] || [ "$ANS" = "YeS" ] || [ "$ANS" = "YEs" ]; then
		ANS=yes
	elif [ "$ANS" = "nO" ] || [ "$ANS" = "No" ] || [ "$ANS" = "NO" ]; then
		ANS=no
	fi
	if [ "$ANS" != "yes" ] && [ "$ANS" != "no" ]; then
		echo "You must enter either \"yes\" or \"no\"."
	fi
done
if [ "$ANS" = "no" ]; then
	echo "Script will terminate. bye bye :)."
	exit
fi
echo "DB_VERSION     : $DB_VERSION" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "ENGINE         : $ENGINE" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "PGDATA         : $PGDATA" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
if [ "$PGWAL" = "bkbspark" ]; then
	echo "PGWAL          : ${PGDATA}/pg_${WAL}" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
else
	echo "PGWAL          : $PGWAL" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
fi
if [ "$PGARCH" = "bkbspark" ]; then
	echo "PGARCH         : No Archive Mode" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
else
	echo "PGARCH         : $PGARCH" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
fi
if [ "$PGLOG" = "bkbspark" ]; then
	echo "PGLOG          : ${PGDATA}/${LG}" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
else
	echo "PGLOG          : $PGLOG" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
fi
echo "PGPORT         : $PGPORT" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "OSUSER         : $OSUSER" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "OSPASS         : $OSPASS" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "PGUSER         : $PGUSER" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "PGPASS         : $PGPASS" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "PGDATABASE     : $PGDATABASE" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "LOCALE         : $LOCALE" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "MAX_CONNECTION : $MAX_CONNECTION" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
echo ""
if [ "$ERRCHK" != "16" ]; then
	echo "######################---------ENGINE INSTALL START--------###########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "######################---------ENGINE INSTALL START--------###########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	if [ "`cat /etc/passwd | grep "$OSUSER" | awk -F ':' '{print $1}'`" = "" ]; then
		useradd -d "$ENGINE" "$OSUSER"
		if [ "$?" != "0" ]; then
			usermod -d "$ENGINE" "$OSUSER"
			if [ "$?" != "0" ]; then
				echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character.\""`
				echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character."
				ERRCHK=16
			fi
		fi
	else
		usermod -d "$ENGINE" "$OSUSER"
		if [ "$?" != "0" ]; then
			echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character.\""`
			echo "Can't USER $OSUSER Create or Modify. Please Check Username has invalid Character."
			ERRCHK=16
		fi
	fi
	if [ -f /etc/redhat-release ]; then
		INSTALL_RPM_LIST=`ls "$INSTALL_DIR"/*.rpm | grep -v $WBIT | grep "el${SYSVER}" | grep -E "/postgresql${DB_VERSION_TEMP}-libs-[0-9]|/postgresql${DB_VERSION_TEMP}-server-[0-9]|/postgresql${DB_VERSION_TEMP}-contrib-[0-9]|/postgresql${DB_VERSION_TEMP}-[0-9]|/python*-*|/perl-*|/libxslt-[0-9]|/libicu-[0-9]" | awk -F '/' '{print "\"'"$INSTALL_DIR"'/"$NF"\""}'`
		echo $INSTALL_RPM_LIST | xargs rpm -Uvh --replacepkgs &> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	else
		echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" > "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
		echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		exit 1
	fi
	if [ "$?" != "0" ]; then
		ERRCHK=16
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "DBMS ENGINE Install is Fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "DBMS ENGINE Install is Fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"DBMS ENGINE Install is Fail.\""`
		echo "DBMS ENGINE Install is Fail."
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
		echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		exit 1
	else 
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "DBMS ENGINE Install is Success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "DBMS ENGINE Install is Success."
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
	fi
	(echo "$OSPASS"; echo "$OSPASS")|su - root -c "passwd $OSUSER"
	if [ "$?" != "0" ]; then
		echo "Can't Chage USER password. Please Check User password has invalid Character." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Can't Chage USER password. Please Check User password has invalid Character." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Can't Chage USER password. Please Check User password has invalid Character.\""`
		echo "Can't Chage USER password. Please Check User password has invalid Character."
	fi
	'cp' /etc/skel/.* "$ENGINE" 2> /dev/null
	'cp' -R /etc/skel/.m* "$ENGINE" 2> /dev/null
	if [ "$ECHK" != "1" ]; then
		mv /usr/pgsql-${DB_VERSION}/* "$ENGINE"
	fi
	chown -R ${OSUSER}. "$ENGINE"
	cat>>"$ENGINE"/.bash_profile<<EOFF
umask 022
export PATH="$ENGINE"/bin:\$PATH
export PGHOME="$ENGINE"
export PGDATA="$PGDATA"
export PGLOCALEDIR=\$PGHOME/share/locale
export MANPATH=\$MANPATH:\$PGHOME/share/man
export LD_LIBRARY_PATH=\$PGHOME/lib
export PGUSER=$PGUSER
export PGDATABASE=$PGDATABASE
export PGPORT=$PGPORT
export PGHOST=localhost
EOFF
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "######################---------ENGINE INSTALL FINISH--------##########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "######################---------ENGINE INSTALL FINISH--------##########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "######################-------DATABASE INSTALL START--------###########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "######################-------DATABASE INSTALL START--------###########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "Start install Database now." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "Start install Database now."
	chmod 700 "$PGDATA"
	chown -R "$OSUSER". "$PGDATA"
	if [ "$PGWAL" != "bkbspark" ]; then
		chmod 755 "$PGWAL"
		chown -R "$OSUSER". "$PGWAL"
	fi
	if [ "$PGARCH" != "bkbspark" ]; then
		chmod 755 "$PGARCH"
		chown -R "$OSUSER". "$PGARCH"
	fi
	if [ "$PGLOG" != "bkbspark" ]; then
		chmod 755 "$PGLOG"
		chown -R "$OSUSER". "$PGLOG"
	fi
	chmod 755 "$ENGINE"
	chown -R "$OSUSER". "$ENGINE"
	chown -R "$OSUSER". /var/run/postgresql
	chown -R "$OSUSER". /var/lib/pgsql
	chown -R "$OSUSER". /run/postgresql
	$USER "(echo \"$PGPASS\";echo \"$PGPASS\")|initdb -D \"$PGDATA\" $INTW -U $PGUSER -W -E UTF8 --no-locale -k $WAL_OPT"
	if [ "$?" != "0" ]; then
		ERRCHK=16
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "Database Install is Fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Database Install is Fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Database Install is Fail.\""`
		echo "Database Install is Fail."
		echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
		echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		exit 1
	else 
		if [ "$PGLOG" != "bkbspark" ] && [ ! -L "${PGDATA}/${LG}" ] ; then
			$USER "ln -s \"$PGLOG\" \"$PGDATA\"/$LG"
		fi
		if [ "$PGWAL" != "bkbspark" ] && [ ! -L "${PGDATA}/pg_${WAL}" ] ; then
			$USER "ln -s \"$PGWAL\" \"$PGDATA\"/pg_${WAL}"
		fi
		echo "Database Install is Success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Database Install is Success."
	fi
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "######################-------DATABASE INSTALL FINISH--------##########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "######################-------DATABASE INSTALL FINISH--------##########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	##################-------DATABASE PARAMETER CONFIGURATION--------#####################
	if [ "$PGWAL" = "bkbspark" ]; then
		PGWAL="$PGDATA"
	fi
	cat >> "$PGDATA"/postgresql.conf <<EOFF
listen_addresses ='*'
port=$PGPORT
max_connections = $MAX_CONNECTION
shared_buffers = $SB
work_mem = $WM
maintenance_work_mem = $MWM
shared_preload_libraries = 'pg_stat_statements'
checkpoint_timeout = 10min
checkpoint_completion_target = 0.9
archive_mode = on
archive_command = $ARCHIVE_COMMAND
max_wal_senders = 5
random_page_cost = 2.0
effective_cache_size = $EFCS
log_destination = 'stderr'
logging_collector = on
$PGLOGP
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_min_duration_statement = 3s
log_line_prefix='%t [%p]:[%a-%u@%r:%d]'
log_lock_waits = on
log_temp_files = 50MB
track_activity_query_size = 65536
pg_stat_statements.max = 10000
pg_stat_statements.track = all
unix_socket_directories = '/tmp'
EOFF
	echo $PARAMETER_ADD | sed 's/,/\n/g' >> "$PGDATA"/postgresql.conf
	if [ "$DB_VERSION_MAJOR" -gt "94" ] ; then
		if [ "$DB_VERSION_MAJOR" -gt "96" ] ; then
			PPP=replica
		else
			PPP=hot_standby
		fi
		cat >> "$PGDATA"/postgresql.conf <<EOFF
wal_level = $PPP
max_wal_size = `df -kP "$PGWAL"|tail -n 1 | awk '{printf"%.0f",(($2/1024)/1024)*0.8}'`GB
min_wal_size = `df -kP "$PGWAL"|tail -n 1 | awk '{printf"%.0f",(($2/1024)/1024)*0.8}'`GB
EOFF
	else
		CHK94=1
		cat >> "$PGDATA"/postgresql.conf <<EOFF
wal_level = hot_standby
checkpoint_segments = 128
EOFF
	fi
	
	##################-------DATABASE PARAMETER CONFIGURATION--------#####################
	
	
	######################-------CONNECT FILE CONFIGURATION--------#######################
	cat "$PGDATA"/pg_hba.conf | sed 's/trust/md5/g' > "$INSTALL_DIR"/temp.file
	cat "$INSTALL_DIR"/temp.file | sed 's/127.0.0.1\/32/0.0.0.0\/0/g' > "$PGDATA"/pg_hba.conf
	rm -rf "$INSTALL_DIR"/temp.file
	echo localhost:"$PGPORT":"$PGDATABASE":"$PGUSER":"$PGPASS" >> "$ENGINE"/.pgpass
	echo localhost:"$PGPORT":postgres:"$PGUSER":"$PGPASS" >> "$ENGINE"/.pgpass
	chown -R "$OSUSER". "$ENGINE"/.pgpass
	chmod 600 "$ENGINE"/.pgpass
	
	######################-------CONNECT FILE CONFIGURATION--------#######################
	
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "##########################-------DATABASE STARTUP--------###########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "##########################-------DATABASE STARTUP--------###########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	$USER "pg_ctl start -w" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	if [ "$?" != "0" ]; then
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "DATABASE start is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "DATABASE start is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"DATABASE start is fail.\""`
		echo "DATABASE start is fail."

		echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
		echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
		exit 1
	else
		echo "DATABASE start is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "DATABASE start is success."
	fi
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "##########################-------DATABASE STARTED--------###########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "##########################-------DATABASE STARTED--------###########################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "################-------DATABASE CUSTOM CONFIGURATION START--------##################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "################-------DATABASE CUSTOM CONFIGURATION START--------##################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	
	if [ "$PGDATABASE" != "postgres" ]; then
		#$USER "psql -U $PGUSER --dbname=postgres -c \"create database $PGDATABASE;\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		$USER 'psql -U $PGUSER --dbname=postgres -c "create database \"$PGDATABASE\";"' >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		if [ "$?" != "0" ]; then
			echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo ""
			echo "Create DATABASE $PGDATABASE is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "Create DATABASE $PGDATABASE is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"Create DATABASE $PGDATABASE is fail.\""`
			echo "Create DATABASE $PGDATABASE is fail."
			ERRCHK=16
		else
			echo "Create DATABASE $PGDATABASE is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "Create DATABASE $PGDATABASE is success."
		fi
		
		#$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"alter database $PGDATABASE owner to $PGUSER;\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		$USER 'psql -U $PGUSER --dbname=$PGDATABASE -c "alter database \"$PGDATABASE\" owner to \"$PGUSER\";"' >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		if [ "$?" != "0" ]; then
			echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo ""
			echo "CHANGE DATABASE USER is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "CHANGE DATABASE USER is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"CHANGE DATABASE USER is fail.\""`
			echo "CHANGE DATABASE USER is fail."
			ERRCHK=16
		else
			echo "CHANGE DATABASE USER is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "CHANGE DATABASE USER is success."
		fi
		#$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"create extension pg_stat_statements;\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		$USER 'psql -U $PGUSER --dbname=$PGDATABASE -c "create extension pg_stat_statements;"' >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		if [ "$?" != "0" ]; then
			echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo ""
			echo "Create DATABASE extension is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "Create DATABASE extension is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
			VBS=`echo "$VBS & Chr(10) & \"Create DATABASE extension is fail.\""`
			echo "Create DATABASE extension is fail."
			ERRCHK=16
		else
			echo "CHANGE DATABASE extension is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			echo "CHANGE DATABASE extension is success."
		fi
	fi
	#$USER "psql -U $PGUSER --dbname=postgres -c \"create extension pg_stat_statements;\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	$USER 'psql -U $PGUSER --dbname=postgres -c "create extension pg_stat_statements;"' >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	if [ "$?" != "0" ]; then
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "Create DATABASE extension is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Create DATABASE extension is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Create DATABASE extension is fail.\""`
		echo "Create DATABASE extension is fail."
		ERRCHK=16
	else
		echo "CHANGE DATABASE extension is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "CHANGE DATABASE extension is success."
	fi
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "#################-------DATABASE CUSTOM CONFIGURATION FINISH--------#################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "#################-------DATABASE CUSTOM CONFIGURATION FINISH--------#################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "######################-------DATABASE INSTALL SUMMARY--------########################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "######################-------DATABASE INSTALL SUMMARY--------########################"
	
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "###################################  DATABASE list  #################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "###################################  DATABASE list  #################################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\l\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\l\""
	if [ "$?" != "0" ]; then
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "Prompt DATABASE list is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt DATABASE list is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Prompt DATABASE list is fail.\""`
		echo "Prompt DATABASE list is fail." 
		ERRCHK=16
	else
		echo "Prompt DATABASE list is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt DATABASE list is success."
	fi
	
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "####################################  SCHEMA list  ##################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "####################################  SCHEMA list  ##################################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\dn\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\dn\""
	if [ "$?" != "0" ]; then
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "Prompt SCHEMA list is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt SCHEMA list is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Prompt SCHEMA list is fail.\""`
		echo "Prompt SCHEMA list is fail."
		ERRCHK=16
	else
		echo "Prompt SCHEMA list is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt SCHEMA list is success."
	fi
	
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "#####################################  USER list  ###################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "#####################################  USER list  ###################################"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\du\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"\du\""
	if [ "$?" != "0" ]; then
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "Prompt DB USER list is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt DB USER list is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
		VBS=`echo "$VBS & Chr(10) & \"Prompt DB USER list is fail.\""`
		echo "Prompt DB USER list is fail."
		ERRCHK=16
	else
		echo "Prompt DB USER list is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "Prompt DB USER list is success."
	fi
	if [ "$PGARCH" != "bkbspark" ]; then
		CNT=1
		while [ "$CNT" != "5" ]
		do
			$USER "psql -U $PGUSER --dbname=$PGDATABASE -c \"select pg_switch_"$WAL"();\"" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
			if [ "$?" != "0" ]; then
				echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo ""
				echo "Change $WAL is fail." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "Change $WAL is fail." >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
				VBS=`echo "$VBS & Chr(10) & \"Change $WAL is fail.\""`
				echo "Change $WAL is fail."
				ERRCHK=16
			else
				echo "Change $WAL is success." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
				echo "Change $WAL is success."
			fi
			sleep 5
			CNT=`echo $CNT|awk '{print $1+1}'`
		done
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		echo "#################################  ARCHIVE FILE list  ###############################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo "#################################  ARCHIVE FILE list  ###############################"
		echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		echo ""
		ls -rlt "$PGARCH" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
		ls -rlt "$PGARCH"
	fi
	echo ""
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "Engine & Database Install Finished. Please Try to connect to the database using the command below." >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "su - $OSUSER" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "psql" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "Engine & Database Install Finished. Please Try to connect to the database using the command below." 
	echo "su - $OSUSER"
	echo "psql"
	echo "" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo ""
	echo "#####################################################################################" >> "$INSTALL_DIR"/PG_"$TODAY"_INSTALL.log
	echo "#####################################################################################"
	echo "PostgreSQL $DB_VERSION DBMS install Finish" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.log
	VBS=`echo "$VBS & Chr(10) & \"PostgreSQL $DB_VERSION DBMS install Finish\""`
	echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
	echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
else
	echo msgbox "$VBS"\,$ERRCHK\,\"`hostname` \/ ${SYSSORT}${SYSVER}_`getconf LONG_BIT`bit\" >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo Path = WScript.ScriptFullName >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo Path = Left\(Path, InStrRev\(Path, \"\\\"\)\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo SET objFSO = CreateObject\(\"Scripting.FileSystemObject\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo If objFso.FileExists\(Path \& \"..\\execute\\${2}1.bat\"\) Then >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
	echo 	objFSO.DeleteFile\(Path \& \"..\\execute\\$2*\"\) >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs	
	echo End If >> "$INSTALL_DIR"/PG_bkbspark_INSTALL_error.vbs
fi
exit 0
