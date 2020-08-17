-- 我的玩家类
MyPlayer = BasePlayer:new()

function MyPlayer:new (objid)
  local o = {
    objid = objid,
    x = nil,
    y = 0,
    z = nil,
    dir = FACE_DIRECTION.DIR_NEG_Z, -- 默认朝南
    ySpeed = 0, -- 纵向速度
    zSpeed = 0, -- 横向速度，此处是位移表示
    walkSpeed = 0,
    notDead = true -- 未死亡
  }
  o.action = BasePlayerAction:new(o)
  o.attr = BasePlayerAttr:new(o)
  -- o.attr.expData = { exp = 50 }
  o.attr.defeatedExp = 0
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 头顶方块
function MyPlayer:headHitBlock ()
  ActorHelper:appendSpeed(self.objid, 0, -self.ySpeed, 0)
  self.walkSpeed = MyGameHelper.defaultWalkSpeed
end