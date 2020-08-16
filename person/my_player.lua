-- 我的玩家类
MyPlayer = BasePlayer:new()

function MyPlayer:new (objid)
  local o = {
    objid = objid,
    x = nil,
    y = nil,
    z = nil,
    dir = FACE_DIRECTION.DIR_NEG_Z, -- 默认朝南
    speed = 0, -- 速度，此处是位移表示
    walkSpeed = 0
  }
  o.action = BasePlayerAction:new(o)
  o.attr = BasePlayerAttr:new(o)
  -- o.attr.expData = { exp = 50 }
  o.attr.defeatedExp = 0
  setmetatable(o, self)
  self.__index = self
  return o
end
