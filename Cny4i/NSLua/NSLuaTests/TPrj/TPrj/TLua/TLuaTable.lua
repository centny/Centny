abc={a=1,b=2,c=3,d=false,e='aaaaaaaaa',f=true}

print("TLuaTable")
-- print(abc)

function backc()
	bcall({a=1,b=2})
end


--method
function hback(msg,sdata)
	print(msg)
end

function hhb(msg,sdata,cback)
	HTTPBack(msg,sdata,cback)
	--print(msg)
 	--print(sdata)
	--print(cback)
end

--test http
function thttp(cback)
	print(cback)
    print("kkkkkkk.....")
	HGet("http://localhost/wdav/LuaApi/LuaApi.json",{a=11,b=2},"hhb",cback)
end

--test http
function thttp2(msg,cback)
	print(msg)
    print("kkkkkkk.....")
	HGet("http://localhost/wdav/LuaApi/LuaApi.json",{a=11,b=2},"hhb",cback)
end