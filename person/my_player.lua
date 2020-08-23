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
  -- local forceSpeed = -self.ySpeed
  -- if (isHide) then
  --   forceSpeed = forceSpeed * 2
  -- end
  local forceSpeed = -1
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
  local brokeBlockid = 999
  local pos = self:getMyPosition()
  local x, y, z = math.floor(pos.x), math.floor(pos.y - 0.5), math.floor(pos.z)
  local blockid = BlockHelper:getBlockID(x, y, z)
  if (blockid == BLOCKID.AIR) then
    z = math.floor(pos.z + 0.5)
    blockid = BlockHelper:getBlockID(x, y, z) -- 后半格方块
    if (blockid == BLOCKID.AIR) then
      z = math.floor(pos.z - 0.5)
      blockid = BlockHelper:getBlockID(x, y, z) -- 前半格方块
    end
  end
  if (blockid == MyMap.BLOCK.DESTROY) then
    self:destroyBlock(x, y, z)
  elseif (blockid == MyMap.BLOCK.LUCKY) then
    self:hitLuckyBlock(x, y, z)
  end
end

-- 踩碎方块
function MyPlayer:destroyBlock (x, y, z)
  local dimension = PlayerHelper:getDimension(self.objid)
  if (dimension > 1) then
    BlockHelper:destroyBlock(x, y, z)
  end
end

-- 踩幸运方块
function MyPlayer:hitLuckyBlock (x, y, z)
  BlockHelper:placeBlock(MyMap.BLOCK.COIN, x + 2, y + 1, z, FACE_DIRECTION.DIR_POS_X)
  local t = 'place' .. x .. ',' .. y .. ',' .. z
  TimeHelper:delFnFastRuns(t)
  TimeHelper:callFnFastRuns(function ()
    BlockHelper:destroyBlock(x + 2, y + 1, z)
  end, 0.2, t)
  BackpackHelper:addItem(self.objid, MyMap.ITEM.COIN, 1)
  WorldHelper:playSoundEffectOnPos(MyPosition:new(x, y, z), BaseConstant.SOUND_EFFECT.PROMPT19, 150, 1)
end