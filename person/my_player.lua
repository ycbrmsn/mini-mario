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
  local luckyBlockInfo = MyBlockHelper:getLuckyBlockInfo(x, y, z)
  if (luckyBlockInfo.num <= 0) then -- 如果已经耗尽
    return
  end
  luckyBlockInfo.num = luckyBlockInfo.num - 1 -- 数量减1
  if (luckyBlockInfo.num == 0) then -- 当前耗尽
    BlockHelper:placeBlock(MyMap.BLOCK.INVALID, x, y, z)
  elseif (luckyBlockInfo.num < 0) then
    return
  end

  local category = luckyBlockInfo.category
  if (category == 1) then -- 幸运金币
    local cx, cy, cz = x + 2, y + 1, z
    BlockHelper:placeBlock(MyMap.BLOCK.COIN, cx, cy, cz, FACE_DIRECTION.DIR_POS_X)
    local t = 'place' .. x .. ',' .. y .. ',' .. z
    TimeHelper:delFnFastRuns(t)
    TimeHelper:callFnFastRuns(function ()
      BlockHelper:destroyBlock(cx, cy, cz)
    end, 0.2, t)
    BackpackHelper:addItem(self.objid, MyMap.ITEM.COIN, 1)
  elseif (category == 2) then -- 无畏星星
    local objids = WorldHelper:spawnCreature(x + 0.5, y - 1, z + 0.5, MyMap.ACTOR.STAR, 1)
    CreatureHelper:closeAI(objids[1])
    ActorHelper:setFaceYaw(objids[1], 90)
  elseif (category == 3) then -- 长大蘑菇
    local objids = WorldHelper:spawnCreature(x + 0.5, y - 1, z + 0.5, MyMap.ACTOR.MUSHROOM, 1)
    CreatureHelper:closeAI(objids[1])
    ActorHelper:setFaceYaw(objids[1], 90)
  end
  WorldHelper:playSoundEffectOnPos(MyPosition:new(x, y, z), BaseConstant.SOUND_EFFECT.PROMPT19, 150, 1)
end