#How to configure golang develop environment with debug and unit test debug
===
<br/>

##Pre-Install Envrionment

- gdb require 7.1+(for osx,see <a href="#install-gdb-for-darwin">Install GDB for Darwin</a>)

- golang compiler(download from <a href="https://code.google.com/p/go/downloads/list">Go</a>)

- Sublime Text 2(ST2) (download from <a href="http://www.sublimetext.com/2">Sublime Text 2</a>)


##Install *gocode* and *MarGo*
*note:the GOPATH must be added to shell environment.see:*<a href="#add-environment-for-command">Add Environment for command</a>
	
	
```
go get github.com/nsf/gocode
go get github.com/DisposaBoy/MarGo
```

##Install ST2 Plugin

1. Install Package Control:

	copy below script to ST2 console and run,then restart the ST2(*ctrl+`* to open ST2 console，or View>Show Console)

	```
import urllib2,os; pf='Package Control.sublime-package'; ipp=sublime.installed_packages_path(); os.makedirs(ipp) if not os.path.exists(ipp) else None; urllib2.install_opener(urllib2.build_opener(urllib2.ProxyHandler())); open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read()); print('Please restart Sublime Text to finish installation')
	```
2. Install *GoSublime、SidebarEnhancements、GoGdb* by Package Control
	* *super+shift+p* open the Goto Anything.
	* input *pcip*
	* select Package Control:Install Package
	* input *GoSublime* for install
	* do the same step for *SidebarEnhancements、GoGdb*
	 
	.	
	 
	if GoGdb is not found in Package Control,install GoGdb manual
	
	
	OSX:
	
	```
cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/
git clone https://github.com/Centny/GoGdb

	```
	
	Linux:
	
	```
cd ~/.config/sublime-text-2/Packages
git clone https://github.com/Centny/GoGdb

	```

##Configure Plugin

*note:the GOPATH must be added to environment.(on osx,see <a href="#add-environment-for-launch">Add Environment for launch on Darwin</a>)*

1. Select Sublime Text 2 >Perference>Package Setting>GoSublime>Setting-Default,then find the *"env":{…}* node and add *"GOPATH":"${GS_GOPATH}:${GOPATH}"*.
2. Select Sublime Text 2 >Perference>Package Setting>GoGdb->Setting-Default,then add *"go_cmd":"/usr/local/go/bin/go"*

	support configure:
	
	- go_cmd	:
	
		the go executable command full path.it can be configure by every prjoect,see *<a href="#go-project-configure">Go Project Configure:sublimegdb_go_cmd</a>*
	- rargs:
	
		the run extend argument for command.suggest it is added every project,see *<a href="#go-project-configure">Go project configure:sublimegdb_rargs</a>*
	
	- commandline:
	
		the debug command line,such as *gdb --interpreter=mi --args ${binp} ${args}*. suggest it is added every project,see *<a href="#go-project-configure">Go project configure:sublimegdb_commandline</a>*
	
	- workingdir:
	
		the gdb debug working directory.suggest it is added to every project,see *<a href="#go-project-configure">Go project configure:sublimegdb_workingdir</a>*


##Go Project Configure

1. create the project dir and source folder

	```
mkdir ~/TGoPrj
mkdir ~/TGoPrj/src
	```
2. open ST2 and select Project>Save Project As..,save the project file to ~/TGoPrj
3. select Project->Edit Project, add configure like below:


	```
{
	//it can be added by selecting Project>Add Folder to Project.
	"folders":
	[
		{
			"path": "src"
		}
	],
	"settings":
	{
		"name": "TGoPrj",
		"sublimegdb_rargs":"",
		"sublimegdb_commandline": "gdb --interpreter=mi --args ${binp} ${args}",
		"sublimegdb_workingdir": "${ppath}",
		"sublimegdb_go_project": true
		//Configure Plugin#2
	}
	//support values:
	//${ppath} the project full path.
	//${binp} the executable file full path.
	//${args} running extend arguments.
	//${pkgp} the package path for go build or install.
	//${args} the package path for go build or install.
}
	```
4. all setting is completed. adding sample code for usage.
5. create folders under src *src/centny/tcode* and *src/centny/main*
6. new *main.go* file to *src/centny/main* and add code:


	```
	package main

	import (
		"fmt"
	)

	func main() {
		fmt.Println("Hello World!")
	}	
	```
7. press *super+shift+r* to run or *f5* to debug.
8. new *tcode.go* file to *src/centny/tcode* and add code:


	```
	package tcode

	import (
		"fmt"
	)

	func ShowTCode() {
		fmt.Println("Hello TCode!")
	}		
	```
9. new *tcode_test.go* file to *src/centny/tcode* and add code:


	```
	package tcode

	import (
		"testing"
	)

	func TestShowTCode(t testing.T) {
		ShowTCode()
	}
	```
10. press *super+shift+r* to run test
11. if run test not error,*super+shift+p* to show *Goto Anything*,typing ggdt,select *GoGdb: Debug Test(or super+shift+o)*,then select *TestShowTCode* to debug test.
12. press *super+shift+k* to kill the process.




<br/><br/><br/><br/><br/>
##Add Environment for command
- vim /etc/profile //if not found,creat it and make it executable.
- add environmen value:

	```
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"
	```
	
##Add Environment for launch on Darwin
- open ~/.MacOSX/environment.plist //if not found,creat it manual.
- add row for GOPATH:

	```
GOPATH <abstract full path> eg:/Users/<username>/go
	```
for 10.7 or later:
 add below to /etc/launchd.conf
 
	```
setenv GOPATH <abstract full path> eg:/Users/<username>/go
	```
note:setting launch environment is different in different osx version,see detail in <http://www.apple.com>


##Install GDB for Darwin
if you aleady installed,skipping this step.

1. download gdb-*.tar.gz for gnu
2. install by below script:

	```
tar -zxvf gdb-*.tar.gz
cd gdb-*
export GOC_FOR_TARGET=<go compiler path,like:/usr/local/go>
./configure --prefix=/usr
make -j8
sudo make install
	```
3. if your system is osx,the gdb must be code signed. see *<a href="building-gdb-for-darwin">Building GDB for Darwin</a>*



##Building GDB for Darwin
**copy** from <http://sourceware.org/gdb/wiki/BuildingOnDarwin>

- Creating a certificate
	
	Start Keychain Access application (/Applications/Utilities/Keychain Access.app)
	
	Open menu /Keychain Access/Certificate Assistant/Create a Certificate...
	
	Choose a name (gdb-cert in the example), set Identity Type to Self Signed Root, set Certificate Type to Code Signing and select the Let me override defaults. Click several times on Continue until you get to the Specify a Location For The Certificate screen, then set Keychain to System.
	
	If you can't store the certificate in the System keychain, create it in the login keychain, then exported it. You can then imported it into the System keychain.
	
	Finally, using the contextual menu for the certificate, select Get Info, open the Trust item, and set Code Signing to Always Trust.
	
	You must quit Keychain Access application in order to use the certificate (so before using gdb).
	
- Codesign gdb

 	```
 	cd <gdb install directory,specified by ./configure --prefix=*,like:/usr/bin>
 	codesign -s gdb-cert gdb
 	
	```
	Old notes: In Tiger, the kernel would accept processes whose primary effective group is procmod or procview.  That means that making gdb setgid procmod should work. Later versions of Darwin should accept this convention provided that taskgated (the daemon that control the access) is invoked with option '-p'. This daemon is configured by /System/Library/LaunchDaemons/com.apple.taskgated.plist. I was able to use this rule provided that I am also a member of the procmod group.
	
- if gdb have not signed success,you will receive below erro message:

	Starting program: /x/y/foo
Unable to find Mach task port for process-id 28885: (os/kern) failure (0x5).(please check gdb is codesigned - see taskgated(8))This is because the Darwin kernel will refuse to allow gdb to debug another process if you don't have special rights, since debugging a process means having full control over that process, and that isn't allowed by default since it would be exploitable by malware. (The kernel won't refuse if you are root, but of course you don't want to be root to debug.)














