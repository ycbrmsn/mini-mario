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
function MyPlayer:headHitBlock (isHide)
  local forceSpeed = -self.ySpeed
  if (isHide) then
    forceSpeed = forceSpeed * 2
  end
  ActorHelper:appendSpeed(self.objid, 0, forceSpeed, 0)
  self.walkSpeed = MyGameHelper.defaultWalkSpeed
  -- 破坏方块
  local pos = self:getMyPosition()
  local height = pos.y + ActorHelper:getEyeHeight(self.objid) + 0.5
  local blockid = BlockHelper:getBlockID(pos.x, height, pos.z)
  if (blockid == 100) then -- 草块
    BlockHelper:destroyBlock(pos.x, height, pos.z)
    WorldHelper:playPlaceBlockSoundOnPos(MyPosition:new(pos.x, height, pos.z))
  end
end