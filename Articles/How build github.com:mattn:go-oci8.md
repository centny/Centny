#How build github.com/mattn/go-oci8 (Go oracle driver)
====
##Create oci pkg-config
- download the **instantclient-basic** and **instantclient-sdk** package from <a href="http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html">oracle</a> and uncompress to the same directory.
- mv the **instanclient** folder to **/usr/lib**(or other postion).
- link the library file:<br/>
	**Note:**replace ```<instanclient path>``` to your **instanclient** path.
	
	```
	ln <instanclient path>/libclntsh.dylib.* /usr/lib/libclntsh.dylib.*
	ln <instanclient path>/libocci.dylib.* /usr/lib/libocci.dylib.*
	ln <instanclient path>/libociei.dylib /usr/lib/libociei.dylib
	ln <instanclient path>/libnnz11.dylib /usr/lib/libnnz11.dylib
	```
- install **pkg-config** if not installed.
- create **oci8.pc** file in **/usr/lib/pkgconfig** and add below(or download example file <a href="https://raw.github.com/Centny/Centny/master/Resources/oci8.pc" >oci8.pc</a>):<br/>
	**Note:**replace ```<instanclient path>``` to your **instanclient** path.


	```
	prefix=<replace instantclient path>
	libdir=${prefix}
	includedir=${prefix}/sdk/include/
	
	Name: OCI
	Description: Oracle database engine
	Version: 11.2
	Libs: -L${libdir} -lclntsh
	Libs.private: 
	Cflags: -I${includedir}

	```
	
##Build go-oci8
- go get github.com/mattn/go-oci8
- if have link error,check if instantclient package can be used for your system version and check pkg-config if correct.


##Test Connect
- ```cd $GOPATH/src/github.com/mattn/go-oci8/example```
- update oracle connection string in line:
	```
	db, err := sql.Open("oci8", "scott/tiger")
	```
- go run oracle.go
- if not error, install success