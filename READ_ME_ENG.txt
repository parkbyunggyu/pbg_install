1. Script Description
-This is a script for installing PostgreSQL versions 9.4~12 using rpm.
-RedHat or CentOS 6ver (64 bit, 32bit), 7ver 64bit, 8ver 64bit can only be installed.
-This script tested In the bash and sh shell environment.
-If you proceed with the installation using Excel included in the file, it is expected that you can quickly install DBMSs on a large number of servers.
-DBMS is installed by setting the memory-related DB parameters (shared_buffer, work_mem, maintenance_work_mem) to ideal values ??
 according to the physical memory amount and the max_connection value. Ideal values ??for DB parameters are recorded in the Appendix tab of the attached Excel file.
-If you set to connect more than 800 users, install the database by automatically setting the kernel parameters to the optimal value.
-When executing the script, DB-related parameters that were changed from 9.4 to 12 are automatically set and installed according to the version.
-In the existing rpm installation, the name of the OS user who manages the database was only possible with "postgres".
 Using the script, you can set the DB os user name to the desired name.
 (After installing the DBMS during the script process, create the desired user and change ownership of the postgresql DB related files to the user owned)

2. Installation method
# There are two ways to install

1) Installation using Excel
[1] Open file "POSTGRESQL_INSTALL.xlsm"
Copy the file "POSTGRESQL_INSTALL_ENG_VER.xlsm" to the name "POSTGRESQL_INSTALL.xlsm", overwrite the existing document, 
and then open the document POSTGRESQL_INSTALL.xlsm.
After opening the document, click "macro included" when prompted to open the document, including macros.
Finally, click "use content" in the yellow warning window at the top.

[2] Download the latest rpm required for installation
In the I27 cell of the "Main" tab, be sure to enter the mirror address to download CentOS-related rpm. (Default: http://mirror.kakao.com/centos)
When entering the mirror address, you must enter "main address/CentOS" or "main address/centos".
Then, click the "RedHat RPM DWLD" button in Excel's "Main" tab to download the rpms required for PostgreSQL DB installation.
The downloaded files are saved in the "rpm" folder in the same location as the Excel file.

[3] Enter the installation server and installation configuration information
Enter the information of the server to install the database on the "Main" tab of Excel and the dictionary information of the database to install.
Some of the dictionary information of the database to be installed is nullable, and there are some information that is not allowed to be installed.
Please note that the information is recorded in the B5:I25 cells of the Main tab of the Excel document.

[4] Click the Install button
Finally, click the Install button to proceed with the installation. There are two installation buttons.
<1> START INSTALL FOREGROUNDSTART INSTALL button
Installation proceeds without the Excel file being closed, and the Excel program is stopped due to installation during installation.

<2> START INSTALL BACKGROUND button
The Excel file is saved, and the installation proceeds after the shutdown, and the Excel program runs in the background during installation.

When you click the Install button, a confirmation window appears asking if you want to open a cmd window showing the installation process.
If you click yes, the CMD window, which proceeds with the installation on all servers that have been specified for installation, appears on the screen and you can see the installation progress.
If you click no, the CMD window, which proceeds with the installation on all the servers that have been specified for installation, does not appear on the screen and is executed in the background.

2) Installation using script
[1] file upload
The files downloaded from github are arranged and uploaded to the server where the database will be installed, 
as in the following directory structure.
--------------------------------------------------------------------------------
# DB server to install
DIRECTORY_CONTAINING_INSTALLATION_FILES/parameter.sh
DIRECTORY_CONTAINING_INSTALLATION_FILES/pg_install.sh
DIRECTORY_CONTAINING_INSTALLATION_FILES/rpm/rpm_file.rpm
--------------------------------------------------------------------------------

DIRECTORY_CONTAINING_INSTALLATION_FILES
chown root. DIRECTORY_CONTAINING_INSTALLATION_FILES/parameter.sh
chown root. DIRECTORY_CONTAINING_INSTALLATION_FILES/pg_install.sh
chown -R root. DIRECTORY_CONTAINING_INSTALLATION_FILES/rpm/

[2] Edit the parameter.sh file
Open the parameter.sh file using the vi editor, enter the information of the database you want to install, referring to the following.
There should not be any files in the installation directory set in the parameter.sh file.
The ownership and ownership group of the installation directory set in the parameter.sh file must be set to "root.root"
The contents of the parameter.sh file are described below.

####################################################################################

# VERSION
Specify DBMS engine version ( 9.4, 9.5, 9.6, 10, 11, 12 ), required input value

# ENGINE
DBMS engine installation location designation, if not entered, automatically designated as "/usr/pgsql-version/" directory

# PGDATA
Location to install database, required input value

# PGWAL
DB WAL(REDO LOG) location, if not entered, automatically designated as "PGDATA/pg_xlog" or "PGDATA/wal" directory

# PGARCH
DB ARCHIVE location, if not entered, install "no archive mode"

# PGLOG
DB LOG location, automatically specified as "$PGDATA/pg_log" or "$PGDATA/log" directory if not input

# PGPORT
DB port designation, automatically designated as "5432" when not input

# OSUSER
Designated as DB OS user, automatically assigned as postgres when not input

# OSPASS
DB OS user PW designation, if not input, it is automatically designated as postgres

# PGUSER
DB super(sys) user specified, automatically assigned to postgres when not input

# PGPASS
DB super (sys) user PW designation, automatic designation as postgres when not input

# PGDATABASE
Specify the name of the database you want to create separately, and does not create the database unless you specify it

# LOCALE 
DB Locale designation, automatic designation as "C" when not input

# MAX_CONNECTION
Specify number of users, required input value

# PARAMETER_ADD
DB parameters that you want to set additionally are grouped with "\=" and specified by separating them with ","
ex) PARAMETER=A\=a_value,B\=b_value

####################################################################################

[3] Execite pg_install.sh
Execute the following command as the root user to proceed with the installation of the database.

sh DIRECTORY_CONTAINING_INSTALLATION_FILES/pg_install.sh