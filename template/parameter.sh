################################################ Parameter description in English #################################################

# VERSION        Specify engine version ( 9.4, 9.5, 9.6, 10, 11, 12 )
# ENGINE         Engine installation location, If not entered, 
#                it is automatically designated as "/usr/pgsql-version/" directory
# PGDATA         Database installation location
# PGWAL          DB WAL(REDO LOG) location If not entered, it is automatically designated 
#                as "PGDATA/pg_xlog" or "PGDATA/wal" directory.
# PGARCH         DB ARCHIVE location, If not entered, install as "no archive mode"
# PGLOG          DB LOG location, If not entered, it is automatically designated 
#                as "$PGDATA/pg_log" or "$PGDATA/log" directory.  
# PGPORT         Specify DB port, "5432" is specified when not input
# PGUSER         Specify DB OS user, Auto-assigned to "postgres" if not entered
# PGPASS         Specify DB OS, super(sys) user PW, Auto-assigned to "postgres" 
#                if not entered
# PGDATABASE     When Installing the DB engine, the parameter to enter the 
#                DB you want to create, if not, do not create it separately
# LOCALE         Specify DB Locale, Auto-assigned to "C" if not entered
# MAX_CONNECTION max connection count for user
# PARAMETER_ADD  DB parameters that you want to set additionally are grouped with "\=" and specified by separating them with ",".

###################################################################################################################################


################################################### Parameter description in Koren ################################################

# VERSION        엔진 버전 지정 ( 9.4, 9.5, 9.6, 10, 11, 12 ), 필수입력값
# ENGINE         엔진 설치 위치, 입력하지 않을시, "/usr/pgsql-버전/" 디렉토리로 자동지정
# PGDATA         Database 설치 위치, 필수입력값
# PGWAL          DB WAL(REDO LOG) 위치, 입력하지 않을시, "PGDATA/pg_xlog" or "PGDATA/wal" 디렉토리로 자동지정
# PGARCH         DB ARCHIVE 위치, 입력하지 않을시, "no archive mode" 설치
# PGLOG          DB LOG 위치, 입력하지 않을시 "$PGDATA/pg_log" or "$PGDATA/log" 디렉토리로 자동지정
# PGPORT         DB port 지정, 입력하지 않을시 "5432" 로 자동지정
# OSUSER         DB OS 유저 지정, 입력하지 않을시 postgres로 자동지정
# OSPASS         DB OS유저 PW지정, 입력하지 않을시 postgres로 자동지정
# PGUSER         DB super(sys)유저 지정, 입력하지 않을시 postgres로 자동지정
# PGPASS         DB 슈퍼(sys)유저 PW지정, 입력하지 않을시 postgres로 자동지정
# PGDATABASE     생성하고 싶은 DB, 입력하지 않을시 따로 생성하지 않음
# LOCALE         DB Locale 지정, 입력하지 않을시 "C"로 자동지정
# MAX_CONNECTION 사용자수 지정, 필수입력값
# PARAMETER_ADD  추가로 설정하고 싶은 DB파라미터들을 "\="로 묶고, ","로 구분하여 지정

###################################################################################################################################


################################################## List of parameters you need to set #############################################

DB_VERSION=9.4
ENGINE=/ENGINE
PGDATA="/DA TA"
PGWAL=/WAL 
PGARCH="/A RCH"
PGLOG=/LOG
PGPORT=5474
OSUSER=pg`echo $DB_VERSION|sed 's/\.//g'`
OSPASS=
PGUSER=bkb*spark
PGPASS=
PGDATABASE=tt_tw
LOCALE=C
MAX_CONNECTION=100
PARAMETER_ADD=log_connections\=on,log_disconnections \= on

###################################################################################################################################

