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
    notDead = true, -- 未死亡
    fallHeight = 0 -- 下落高度
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
  -- local pos = self:getMyPosition()
  -- local height = pos.y + ActorHelper:getEyeHeight(self.objid) + 0.5
  -- local blockid = BlockHelper:getBlockID(pos.x, height, pos.z)

  -- local height = self.y + ActorHelper:getEyeHeight(self.objid) + 0.5
  -- local blockid = BlockHelper:getBlockID(self.x, height, self.z)
  -- if (blockid == 100) then -- 草块
  --   BlockHelper:destroyBlock(self.x, height, self.z)
  --   WorldHelper:playPlaceBlockSoundOnPos(MyPosition:new(self.x, height, self.z))
  -- end
end

-- 踩方块
function MyPlayer:trampleBlock ()
  local brokeBlockid = 100
  local pos = self:getMyPosition()
  local x, y, z = pos.x, pos.y - 0.5, pos.z
  local blockid = BlockHelper:getBlockID(x, y, z)
  if (blockid == brokeBlockid) then -- 草块
    BlockHelper:destroyBlock(x, y, z)
  elseif (blockid == BLOCKID.AIR) then
    local nz = z + 0.5
    local nextBlockid = BlockHelper:getBlockID(x, y, nz) -- 后半格方块
    if (nextBlockid == BLOCKID.AIR) then
      nz = z - 0.5
      nextBlockid = BlockHelper:getBlockID(x, y, nz) -- 前半格方块
    end
    if (nextBlockid == brokeBlockid) then
      BlockHelper:destroyBlock(x, y, nz)
    end
  end
end