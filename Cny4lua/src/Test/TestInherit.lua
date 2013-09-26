ClassYM = {x=0,y=0}
--这句是重定义元表的索引，必须要有，
ClassYM.__index = ClassYM

--模拟构造体，一般名称为new()
function ClassYM:new(x,y)
  local self = {}
  setmetatable(self, ClassYM)   --必须要有
  self.x = x
  self.y = y
  return self
end

function ClassYM:test()
  print(self.x,self.y)
end

objA = ClassYM:new(1,2)
objA:test()
objB = ClassYM:new(10,20)
objB:test()
print(objA.x,objA.y)
print(objB.x,objB.y)