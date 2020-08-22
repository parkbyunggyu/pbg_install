1. 스크립트 설명
- PostgreSQL의 9.4~12 버전을 rpm을 이용해 설치하는 스크립트 입니다.
- RedHat or CentOS 6ver(64 bit, 32bit), 7ver 64bit, 8ver 64bit 에서만 설치가 가능합니다.
- TEST환경에서 쉘은 bash, sh에서 이루어졌습니다.
- 해당 파일에 포함되어있는 엑셀을 이용해 설치를 진행한다면, 다량의 서버에 빠르게 DBMS들을 설치할수 있을것으로 기대됩니다.
- 메모리 관련 DB파라미터 ( shared_buffer, work_mem, maintenance_work_mem ) 들을 물리 메모리량과, max_connection 값에 맞춰
  이상적인 값으로 설정해 DBMS를 설치해줍니다. DB파라미터에 대한 이상적인 값은 첨부한 엑셀파일의 Appendix 탭에 기록되어 있습니다.
- 800명 이상유저를 접속하게끔 설정한다면, 커널파라미터 들을 최적의 값으로 자동설정하여 Database를 설치합니다.
- 스크립트 수행시 9.4 ~ 12버전 까지 변경이 있었던 DB관련 파라미터들을 버전에 맞춰 자동으로 최적값을 지정해 설치해줍니다.
- 기존 rpm설치에서는 Database를 관리하는 OS유저이름이 오직 "postgres"로써만 가능했지만,
  해당 스크립트를 사용하면 DB os유저이름을 원하는 이름으로 설정이 가능합니다.
  ( 스크립트 진행시 DBMS 설치뒤, 원하는 유저를 생성하고, postgresql DB관련 파일들의 소유권을 생성한 유저소유로 변경 )

2. 스크립트를 사용한 설치방법
# 설치방법에는 두가지 방법이 있습니다

1) 엑셀을 이용한 설치
[1] POSTGRESQL_INSTALL.xlsm 파일을 열고, 매크로 포함하여 문서를 열것인지 묻는 경고창이 나온다면 "매크로 포함"을 클릭합니다.
    마지막으로, 상단의 노란색 경고창의 콘텐츠사용을 클릭합니다.

[2] 설치에 필요한 최신 rpm 다운로드
Main 탭의 I27셀에서 CentOS관련 rpm을 다운받을 mirror 주소를 반드시 입력해주세요. (기본값 : http://mirror.kakao.com/centos )
mirror 주소를 입력해줄 때는 "main주소/CentOS" or "main주소/centos" 와 같이 입력해주어야 합니다.
그리고 엑셀의 Main 탭의 RedHat RPM DWLD 버튼을 클릭하여, PostgreSQL DB설치에 필요한 rpm들을 다운받습니다.
다운받아진 파일들은 엑셀파일과 동일한 위치에 있는 rpm폴더에 저장이 되게 됩니다.

[3] 설치 서버 및 설치 구성정보 입력
엑셀의 main 탭의 Database를 설치할 서버의 정보와, 설치할 Database의 사전정보를 입력합니다.
설치할 Database의 사전정보는 Null값이 허용되는 것이 있고, 설치할 Null값이 허용되지 않는 정보들이 있습니다.
해당 정보들은 엑셀문서 Main 탭의 B5:I25 셀에 기록되어 있으니 참고하십시오.

[4] 설치 버튼을 클릭
마지막으로 설치 버튼을 클릭하여 설치를 진행합니다. 설치 버튼은 두가지가 있습니다.
<1> START INSTALL FOREGROUNDSTART INSTALL  버튼
엑셀파일이 닫히지 않은 상태로 설치가 진행되며, 설치도중 엑셀프로그램이 설치로 인해 멈춰있게 됩니다.

<2>START INSTALL BACKGROUND 버튼
엑셀파일이 저장되고, 종료된 다음 설치가 진행되며, 설치도중 엑셀프로그램이 백그라운드로 실행되게 됩니다.

설치버튼을 클릭하면, 설치과정을 보여주는 cmd창을 띄울것인지 물어보는 확인창이 발생합니다.
yes를 클릭하면, 설치를 지정한 모든 서버에서 설치를 진행하는 CMD창이 화면에 띄워지며 설치과정들을 볼수가 있습니다.
no를 클릭하면, 설치를 지정한 모든 서버에서 설치를 진행하는 CMD창이 화면에 띄워지지 않고 백그라운드로 수행이 됩니다.


2) 스크립트를 이용한 설치
[1] 파일 업로드
github에서 다운받은 파일들을 
Database를 설치할 서버에 하기의 디렉토리 구조처럼 배치시켜 업로드 해줍니다.
--------------------------------------------------------------------------------
# 설치할 DB서버
설치파일이_있는_디렉토리/parameter.sh
설치파일이_있는_디렉토리/pg_install.sh
설치파일이_있는_디렉토리/rpm/설치rpm파일.rpm
--------------------------------------------------------------------------------

업로드된 파일들을 아래명령을 사용해 소유권 및 권한을 바꿔줍니다.
chown root. 설치파일이_있는_디렉토리/parameter.sh
chown root. 설치파일이_있는_디렉토리/pg_install.sh
chown -R root. 설치파일이_있는_디렉토리/rpm/


[2] parameter.sh 파일 편집
vi편집기를 사용하여 parameter.sh파일을 열고, 하기 내용을 참고하여, 설치하고 싶은 Database의 정보를 입력합니다.
parameter.sh 파일에 설정 해놓은 설치 디렉토리 안에는 어떤 파일도 존재해서는 안됩니다.
parameter.sh 파일에 설정 해놓은 설치 디렉토리의 소유권과, 소유그룹은 root.root 로 설정 되어있어야 합니다.
parameter.sh 파일 안에 있는 내용에 대한 설명은 아래와 같습니다.

####################################################################################

# VERSION
DBMS엔진 버전을 지정 ( 9.4, 9.5, 9.6, 10, 11, 12 ), 필수입력값

# ENGINE
DBMS엔진 설치 위치를 지정, 입력하지 않을시, "/usr/pgsql-버전/" 디렉토리로 자동지정

# PGDATA
Database를 설치할 위치를 지정, 필수입력값

# PGWAL
DB WAL(REDO LOG) 위치, 입력하지 않을시, "PGDATA/pg_xlog" or "PGDATA/wal" 디렉토리로 자동지정

# PGARCH
DB ARCHIVE 위치를 지정, 입력하지 않을시, "no archive mode" 설치

# PGLOG
DB LOG 위치를 지정, 입력하지 않을시 "$PGDATA/pg_log" or "$PGDATA/log" 디렉토리로 자동지정

# PGPORT
DB port를 지정, 입력하지 않을시 "5432" 로 자동지정

# OSUSER
DB OS 유저이름을 지정, 입력하지 않을시 postgres로 자동지정

# OSPASS
DB OS유저를 PW지정, 입력하지 않을시 postgres로 자동지정

# PGUSER
DB super(sys)유저이름을 지정, 입력하지 않을시 postgres로 자동지정

# PGPASS
DB 슈퍼(sys)유저 PW지정, 입력하지 않을시 postgres로 자동지정

# PGDATABASE
생성하고 싶은 DB이름을 지정, 입력하지 않을시 따로 생성하지 않음

# LOCALE 
DB Locale을 지정, 입력하지 않을시 "C"로 자동지정

# MAX_CONNECTION
사용자수 지정, 필수입력값

# PARAMETER_ADD
추가로 설정하고 싶은 DB파라미터들을 "\="로 묶고 ","로 구분하여 지정
ex) PARAMETER=A\=a_value,B\=b_value

####################################################################################

[3] pg_install.sh 파일 수행
하기 명령을 root유저로 실행하여, Database의 설치를 진행합니다.

sh 설치파일이_있는_디렉토리/pg_install.sh