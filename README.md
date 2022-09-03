# iHAC
[![ci-tests](https://github.com/simonkowallik/iHAC/actions/workflows/main.yml/badge.svg)](https://github.com/simonkowallik/iHAC/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/release/simonkowallik/iHAC.svg)](https://github.com/simonkowallik/iHAC/releases)
[![Commits since latest release](https://img.shields.io/github/commits-since/simonkowallik/iHAC/latest.svg)](https://github.com/simonkowallik/iHAC/commits)
[![Latest Release](https://img.shields.io/github/release-date/simonkowallik/iHAC.svg?color=blue)](https://github.com/simonkowallik/iHAC/releases/latest)
## About
The iHAC (iHealth API Clients) script collection aims to be a simple and easy to use interface to a subset of features provided by [F5 iHealth](https://ihealth.f5.com).
It uses the [iHealth API](https://devcentral.f5.com/wiki/iHealth.HomePage.ashx) which is documented on [F5 DevCentral](https://devcentral.f5.com).

### Feature Overview
* Upload qkviews
* List existing qkviews
* Download qkviews
* Delete qkviews
* List files
* Download files
* List commands
* Run commands
* Show diagnostics

#### Demo!
<p align="center">
    <img src="https://simonkowallik.github.io/iHAC/demo.svg">
</p>

## Installation
### 1. Install prerequisites
This is the list of prerequisites:
* coreutils (tested with: 5.97, 8.15)
* curl (tested with: 7.15.5 7.19.7, 7.30.0, 7.37.0)
* bash (tested with: 3.2.25, 3.2.51, 4.1.11)
* perl (tested with: 5.8.8, 5.14.4, 5.16.2)
	* XML::Simple (used for ihac-diagnostics XML parsing) 
	* MIME::Base64 (used for ihac-commandrun output conversion)

BIG-IP 11.x: Works right away

Mac OS: Works right away

Ubuntu / Debian: ```apt-get install libxml-simple-perl```

RedHat / CentOS: ```yum install perl-XML-Simple```

Cygwin: Install ```curl``` and ```perl-XML-Simple``` through the Cygwin Setup

### 2. Download / Install / Update
#### On BIG-IP
```sh
simon@bigip ~ $ INSTALLDIR=$HOME/bin; \
	test -d $INSTALLDIR || mkdir -p $INSTALLDIR; \
	CURL_CA_BUNDLE=/config/ssl/ssl.crt/ca-bundle.crt \
	curl -L https://github.com/simonkowallik/iHAC/tarball/main \
	| tar xzv --strip-components 1 --wildcards -C $INSTALLDIR */ihac*; \
	chmod a+x $INSTALLDIR/ihac-*
```

#### Homebrew / Linuxbrew
```sh
simon@macos ~ $ brew install simonkowallik/f5/ihac
```
If you want to receive updates when running `brew update` add my tap with `brew tap simonkowallik/f5`.

#### On Mac OS
```sh
simon@macos ~ $ sudo sh -c 'INSTALLDIR=/usr/local/bin; \
	test -d $INSTALLDIR || mkdir -p $INSTALLDIR; \
	curl -L https://github.com/simonkowallik/iHAC/tarball/main \
	| tar xzv --strip-components 1 -C $INSTALLDIR */ihac*; \
	chmod a+x $INSTALLDIR/ihac-*'
```

#### Other platforms
```sh
simon@other ~ $ INSTALLDIR=/usr/local/bin; \
	test -d $INSTALLDIR || mkdir -p $INSTALLDIR; \
	curl -L https://github.com/simonkowallik/iHAC/tarball/main \
	| tar xzv --strip-components 1 --wildcards -C $INSTALLDIR */ihac*; \
	chmod a+x $INSTALLDIR/ihac-*
```
Adjust ```INSTALLDIR``` to your needs. ```/usr/local/bin``` is mounted as read-only on BIG-IP therefore the default above is ```$HOME/bin``` which is in ```PATH``` by default.

If you just want to get the tarball:
```sh
simon@bigip ~ $ curl -L https://github.com/simonkowallik/iHAC/tarball/main -o $HOME/ihac.tgz
```

If the CA chain validation for github.com fails on your system, you might try the following:
 1. Specify an alternative CA bundle by setting ```CURL_CA_BUNDLE=``` shell variable (see BIG-IP example above)
 2. Add the ```-k``` option to curl to ignore any validity checks, however this is **not recommended**.

If you need a proxy, use curls proxy option ```-x http://192.0.2.245:8080```.

### 3. Run
Have fun. :)

## Usage

### ihac-auth
Interactive authentication
```sh
simon@bigip ~ $ ihac-auth
Username: simon@example.com
Password:
OK
```

JSON formatted credentials as an argument
```sh
simon@bigip ~ $ ihac-auth '{"user_id": "simon@example.com", "user_secret": "MyP@ssw0rd"}'
OK
```

JSON formatted credentials via STDIN
```sh
simon@bigip ~ $ cat $HOME/credentials.json | ihac-auth

simon@bigip ~ $ cat $HOME/credentials.json
{"user_id": "simon@example.com", "user_secret": "MyP@ssw0rd"}
```

De-authenticate / delete session cookies
```sh
simon@bigip ~ $ ihac-auth [--delete | -d | delete | --logout]
OK
```

### ihac-qkviewadd
Adds qkview to iHealth, qkview file supplied as argument. You can specify as many qkviews as arguments as you want.
```sh
simon@bigip ~ $ ihac-qkviewadd ../bigip1141.qkview ./bigip1151.qkview bigip1160.qkview
################################################################## 100.0%
2257810 OK
################################################################## 100.0%
2257812 OK
################################################################## 100.0%
2257814 OK
```

Adds qkview to iHealth, qkview file supplied via STDIN
```sh
simon@bigip ~ $ cat ../qkviews/bigip1151.qkview | ihac-qkviewadd
################################################################## 100.0%
2257819 OK
```

### ihac-qkviewlist
Lists all qkviews available on iHealth
```sh
simon@bigip ~ $ ihac-qkviewlist
2257819 bigip1151.example.com SerialNumber	  May 8 2014, 21:12:29 AM (GMT) OptionalCaseNumber
2257811 bigip1151.example.com SerialNumber	  May 8 2014, 21:10:19 AM (GMT) OptionalCaseNumber
2254055 bigip1151.example.com SerialNumber	  May 7 2014, 20:59:32 AM (GMT) OptionalCaseNumber
2254011 bigip1151.example.com SerialNumber	  May 7 2014, 20:32:39 AM (GMT) OptionalCaseNumber
```
The first column displays the qkview ID, which is important for all commands below.

### ihac-qkviewget
Dowloads qkview from iHealth, output file specified as argument
```sh
simon@bigip ~ $ ihac-qkviewget 2254055 ../qkview/2254055.qkview.tgz
################################################################## 100.0%
OK

simon@bigip ~ $ ls -la 2254055.qkview.tgz
-rw-r--r-- 1 simon users 12555744 May  8 21:18 ../qkview/2254055.qkview.tgz
```

Dowloads qkview from iHealth, outputs to STDOUT
```sh
simon@bigip ~ $ ihac-qkviewget 2254011 | gzip -d > 2254011.qkview.tar
################################################################## 100.0%
OK

simon@bigip ~ $ ls -la 2254011.qkview.tar
-rw-r--r-- 1 simon users 136547328 May  8 21:23 2254011.qkview.tar
```

### ihac-qkviewdelete
Deletes qkview from iHealth. You can specify as many qkview IDs as arguments as you want.
```sh
simon@bigip ~ $ ihac-qkviewdelete 2257810 2257812
2257810 OK
2257812 OK
```

### ihac-filelist
Lists all files for a specific qkview, outputs filenames with path to STDOUT
```sh
simon@bigip ~ $ ihac-filelist 2254055 | grep /config/bigip | head -5
/config/bigip_base.conf.bak
/config/bigip.conf.bak
/config/bigip_script.conf.bak
/config/bigip_base.conf
/config/bigip.conf
```

### ihac-fileget
Get file from qkview on iHealth, outputs file content to STDOUT
```sh
simon@bigip ~ $ ihac-fileget 2254055 /config/bigip.conf | head
#TMSH-VERSION: 11.5.1

apm client-packaging /Common/client-packaging { }
apm resource remote-desktop citrix-client-bundle /Common/default-citrix-client-bundle { }
ltm default-node-monitor {
    rule none
}
ltm node /Common/10.0.0.10 {
    address 10.0.0.10
}
```

fetching multiple files (supports wildcards) and placing them in a directory
```sh
simon@bigip ~ $ ihac-fileget 2254055 --output-directory ./qkview/ /config/bigip*.conf /PLATFORM
simon@bigip ~ $ find ./qkview/ -type f
./qkview/config/bigip_user.conf
./qkview/config/bigip_base.conf
./qkview/config/bigip.conf
./qkview/PLATFORM
```

### ihac-commandlist
Lists all commands available for a specific qkview, outputs command list to STDOUT
```sh
simon@bigip ~ $ ihac-commandlist 2254055 | grep /sys | head
show running-config /sys management-ip
show running-config /sys management-route all-properties
list /sys application service recursive all-properties
list /sys cluster all-properties
list /sys daemon-ha all-properties
list /sys db all-properties
list /sys db all-properties (non-default values)
list /sys db systemauth.source all-properties
list /sys disk all-properties
list /sys feature-module all-properties
```

### ihac-commandrun
Fetches command output from qkview on iHealth to STDOUT
```sh
simon@bigip ~ $ ihac-commandrun 2254055 ‘show /sys provision’
-------------------------------------------------------------
Sys::Provision
Module   CPU (%)   Memory (MB)   Host-Memory (MB)   Disk (MB)
-------------------------------------------------------------
afm            1           466                720        3900
am             0             0                  0           0
apm            0             0                  0           0
asm            0             0                  0           0
avr            0             0                  0           0
em             0             0                  0           0
gtm            0             0                  0           0
host          10          2896                  0       47984
lc             0             0                  0           0
ltm            1             0                  0           0
tmos          88          4640                280           0
ui             0           224                  0           0
vcmp           0             0                  0           0

simon@bigip ~ # ihac-commandrun 2254055 'tmctl -a (blade)' | wc -l
4757
```

### ihac-diagnostics
Fetch iHealth Diagnostics and output to STDOUT
```sh
simon@bigip ~ $ ihac-diagnostics 2254055 | head
Hostname: bip1141.example.net    Serial: Serial Number
Version: Version		  	     Platform: Platform

* Severity: LOW/MEDIUM/HIGH	Heuristic: Heuristic Number
* Title:        Heuristic Title
* Summary:      Heuristic Summary
* SOLs:         Link to SOL article
```

Filter for Severity with egrep
```sh
simon@bigip ~ $ ihac-diagnostics 2254055 | egrep -A3 "MEDIUM|^(P|H)"
simon@bigip ~ $ ihac-diagnostics 2254055 | egrep -A3 "HIGH|MEDIUM|^(P|H)"
```

Output JSON or XML for further processing
```sh
simon@bigip ~ $ ihac-diagnostics --json 2254055 | jq .
simon@bigip ~ $ ihac-diagnostics --xml 2254055 | xq
```

## Proxy Support
Specify environment variable before executing an ihac script
```sh
simon@bigip ~ $ IHACPROXY=http://localhost:8080 ihac-*
```

Set environment variable which is then used by all further ihac scripts executed in the same session
```sh
simon@bigip ~ $ export IHACPROXY=http://localhost:8080
simon@bigip ~ $ ihac-*
```

Set a permanent proxy
```sh
simon@bigip ~ $ echo ‘http://localhost:8080’ > $HOME/.ihac/IHACPROXY
simon@bigip ~ $ ihac-*
```

Note: Environment variable will always have precedence

## Security
### Transport Security
cURL command line client is used to interact with iHealth. Transport security depends on cURL, which includes encryption and authenticity verification.

### Credentials and iHealth session cookies
Credentials are never stored on disk, unless a user decides to.
iHealth session cookies will be stored in $HOME/.ihac/auth.jar, which is valid for about 4 hours.

Session cookie jar file is only readable and writable by user.
```sh
simon@bigip ~ $ file $HOME/.ihac/auth.jar
/home/simon/.ihac/auth.jar: Netscape cookie, ASCII text

simon@bigip ~ $ ls -l $HOME/.ihac/
total 4
-rw------- 1 simon users 1531 May 11 23:37 auth.jar
```

Session cookies can be deleted by ihac-auth or manually by the user.
```sh
simon@bigip ~ $ ihac-auth --logout
OK

simon@bigip ~ $ file $HOME/.ihac/auth.jar
/home/simon/.ihac/auth.jar: empty

simon@bigip ~ $ rm -f $HOME/.ihac/auth.jar
```

## Usage Examples
Pipe credentials from local to remote system for authentication and list all qkviews available on iHealth
```sh
~ $ cat $HOME/auth.txt | ssh root@192.168.1.245 '/root/bin/ihac-auth;/root/bin/ihac-qkviewlist'
Password:
OK
2483776 bigip.example.com           0570271                Jun 30 2014, 06:59:43 PM (GMT)
2483760 bigip.example.com           0570271                Jun 30 2014, 06:54:47 PM (GMT)
```

Pipe local qkview file to remote system and upload to iHealth
```sh
~ $ cat qkview/bigip1141.qkview.tgz | ssh root@192.168.1.245 '/root/bin/ihac-qkviewadd'
Password:
################################################################## 100.0%
OK
```

Get file from iHealth and send to remote system
```sh
~ $ ihac-fileget 2521684 /config/bigip.conf | ssh root@192.168.1.245 'cat > /tmp/bigip.conf'
```

Generate qkview on remote system, send via pipe to local system and upload to iHealth
```sh
~ $ ssh root@192.168.1.245 'qkview -f /var/tmp/qkview.tgz;cat /var/tmp/qkview.tgz' | ihac-qkviewadd
Password:
Gathering System Diagnostics: Please wait ...
Diagnostic information has been saved in:
/var/tmp/qkview.tgz
Please send this file to F5 support.
################################################################## 100.0%
OK
```
