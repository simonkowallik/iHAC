# About
The iHAC (iHealth API Clients) script collection aims to be a simple and easy to use interface to a subset of features provided by [F5 iHealth](https://ihealth.f5.com).
It uses the [iHealth API](https://devcentral.f5.com/wiki/iHealth.HomePage.ashx) which is documented on [F5 DevCentral](https://devcentral.f5.com).

### Features Overview
* Upload qkviews
* List existing qkviews
* Download qkviews
* Delete qkviews
* List files
* Download files
* Show diagnostics

# Installation
Installation is a straightforward two step process:
 1. Download.
 2. Run it.

:)

#### On Mac OS (BSD tar)
```sh
simon@macos ~ $ INSTALLDIR=/usr/local/bin; \
	test -d $INSTALLDIR || mkdir -p $INSTALLDIR; \
	curl -L https://github.com/simonkowallik/iHAC/tarball/master \
	| tar xzv --strip-components 2 -C $INSTALLDIR */ihac*; \
	chmod a+x $INSTALLDIR/ihac-*
```

#### On all other platforms (GNU tar)
```sh
simon@bigip ~ $ INSTALLDIR=/usr/local/bin; \
	test -d $INSTALLDIR || mkdir -p $INSTALLDIR; \
	curl -L https://github.com/simonkowallik/iHAC/tarball/master \
	| tar xzv --strip-components 2 --wildcards -C $INSTALLDIR */ihac*; \
	chmod a+x $INSTALLDIR/ihac-*
```
Adjust ```INSTALLDIR``` to your needs. An alternative could be ```$HOME/bin``` which is in ```PATH``` by default on BIG-IP.

If you just want to get the tarball:
```sh
simon@bigip ~ $ curl -L https://github.com/simonkowallik/iHAC/tarball/master -o $HOME/ihac.tgz
```

# License
[MIT](http://opensource.org/licenses/MIT)

# Usage

### ihac-auth
Interactive authentication
```sh
simon@bigip ~ $ ihac-auth
Username: simon@example.com
Password:
OK
```

Urlencoded credentials as an argument
```sh
simon@bigip ~ $ ihac-auth 'userid=simon%40example.com&passwd=MyP%40ssw0rd'
OK
```

Urlencoded credentials via STDIN
```sh
simon@bigip ~ $ cat $HOME/credentials.txt | ihac-auth

simon@bigip ~ $ cat $HOME/credentials.txt
userid=simon%40example.com&passwd=MyP%40ssw0rd
```

De-authenticate / delete session cookies
```sh
simon@bigip ~ $ ihac-auth [--delete | -d | delete | --logout]
OK
```


### ihac-qkviewadd
Adds qkview to iHealth, qkview file supplied as argument
```sh
simon@bigip ~ $ ihac-qkviewadd ../qkviews/bigip1151.qkview
################################################################## 100.0%
2257811
OK
```

Adds qkview to iHealth, qkview file supplied via STDIN
```sh
simon@bigip ~ $ cat ../qkviews/bigip1151.qkview | ihac-qkviewadd
################################################################## 100.0%
2257819
OK
```

### ihac-qkviewlist
Lists all qkviews available on iHealth
```sh
simon@bigip ~ $ ihac-qkviewlist
2257819 bigip1151.example.com SerialNumber		May 8 2014, 21:12:29 AM (GMT) OptionalCaseNumber
2257811 bigip1151.example.com SerialNumber		May 8 2014, 21:10:19 AM (GMT) OptionalCaseNumber
2254055 bigip1151.example.com SerialNumber		May 7 2014, 20:59:32 AM (GMT) OptionalCaseNumber
2254011 bigip1151.example.com SerialNumber		May 7 2014, 20:32:39 AM (GMT) OptionalCaseNumber
```

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
Deletes qkview from iHealth
```sh
simon@bigip ~ $ ihac-qkviewdelete 2257811
2257811
OK
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
Get file from qkview on ihealth, outputs file content to STDOUT
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

### ihac-diagnostics
Fetch iHealth Diagnostics and output to STDOUT
```sh
simon@bigip ~ $ ihac-diagnostics 2483996 | head
Hostname: bip1141.example.net    Serial: Serial Number
Version: Version		  	     Platform: Platform

* Severity: LOW/MEDIUM/HIGH	Heuristic: Heuristic Number
* Title:        Heuristic Title
* Summary:      Heuristic Summary
* SOLs:         Link to SOL article
```

Filter for Severity with egrep
```sh
simon@bigip ~ $ ihac-diagnostics 2483996 | egrep -A3 "MEDIUM|^(P|H)"
simon@bigip ~ $ ihac-diagnostics 2483996 | egrep -A3 "HIGH|MEDIUM|^(P|H)"
```

# Proxy Support
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

# Security
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

# Usage Examples
Pipe credentials from local to remote system for authentication and list all qkviews available on iHealth
```sh
~ $ cat $HOME/auth.txt | ssh root@192.168.1.245 '/root/bin/ihac-auth; /root/bin/ihac-qkviewlist'
Password:
OK
2483776 bigip.example.com              0570271                         Jun 30 2014, 06:59:43 PM (GMT)
2483760 bigip.example.com              0570271                         Jun 30 2014, 06:54:47 PM (GMT)
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