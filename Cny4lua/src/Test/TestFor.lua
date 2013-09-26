--functions 
function fCount() 
	print("require count")
	return 9 
end
--
for i=0,10 do print(i..",") end
--
for i=0,fCount() do print(i..",") end
--
for i=10,0,-1 do print(i..",") end

