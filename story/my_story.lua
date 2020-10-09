-- 我的剧情类
MyStory = {
  title = nil,
  name = nil,
  desc = nil,
  tips = nil
}

function MyStory:new ()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyStory:checkData (data)
  if (not(data)) then
    LogHelper:debug('剧情数据为空')
  elseif (not(data.title)) then
    LogHelper:debug('剧情标题为空')
  elseif (not(data.name)) then
    LogHelper:debug(data.title, '剧情名称为空')
  elseif (not(data.desc)) then
    LogHelper:debug(data.title, '剧情描述为空')
  elseif (not(data.tips)) then
    LogHelper:debug(data.title, '剧情提示为空')
  end
end

function MyStory:init ()
  self:initEnterPipe()
  self:initLeavePipeArea()
  self:initPassArea()
  self:initHideBlockAreas()
  self:initLuckyBlocks()
end

-- 初始化几个隐藏区域，四分之一概率
function MyStory:initHideBlockAreas ()
  local num = math.floor(#self.hideBlockPosData / 4)
  for i = 1, num do
    local index = math.random(1, #self.hideBlockPosData) -- 随机取一个
    local pos = MyPosition:new(self.hideBlockPosData[index][1],
      self.hideBlockPosData[index][2], self.hideBlockPosData[index][3])
    local areaid = AreaHelper:createAreaRectByRange(pos, pos)
    table.insert(self.hideBlockAreas, areaid)
    table.remove(self.hideBlockPosData, index)
  end
  -- 固定隐藏区域
  for i, v in ipairs(self.sureHideBlockData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    local areaid = AreaHelper:createAreaRectByRange(pos, pos)
    table.insert(self.hideBlockAreas, areaid)
    MyBlockHelper:addLuckyBlockData(pos, v[4], v[5])
  end
end

-- 初始化幸运方块
function MyStory:initLuckyBlocks ()
  for i, v in ipairs(self.luckyBlockData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    MyBlockHelper:addLuckyBlockData(pos, v[4], v[5])
  end
  -- 城堡钥匙
  local index = math.random(1, #self.maybeKeyBlockData) -- 随机取一个
  local data = self.maybeKeyBlockData[index]
  local pos = MyPosition:new(data[1], data[2], data[3])
  MyBlockHelper:addLuckyBlockData(pos, 4, 1)
  -- MyBlockHelper.luckyBlockInfos[pos:toSimpleString()] = { pos = pos, category = 4, num = 1 }
end

-- 初始化进入管道及区域
function MyStory:initEnterPipe ()
  AreaHelper:initAreaByPosData(self.enterPosData, self.enterAreas)
  -- 设置进入水管区域
  math.random()
  math.random()
  local index = math.random(1, #self.enterAreas)
  self.enterPos = MyPosition:new(self.enterPosData[index][1], self.enterPosData[index][2], self.enterPosData[index][3])
  self.enterArea = self.enterAreas[index]
  self:replacePipe(self.enterPos.x, self.enterPos.y - 1, self.enterPos.z)
  LogHelper:debug('替换第', index, '个')
end

-- 初始化离开管道区域
function MyStory:initLeavePipeArea ()
  self.leaveArea = AreaHelper:getAreaByPos(self.undergroundEndPos)
  if (not(self.leaveArea)) then
    TimeHelper:callFnAfterSecond(function ()
      self:initLeavePipeArea()
    end, 1)
  end
end

-- 初始化过关区域
function MyStory:initPassArea ()
  self.passArea = AreaHelper:getAreaByPos(self.passPos)
  if (not(self.passArea)) then
    TimeHelper:callFnAfterSecond(function ()
      self:initPassArea()
    end, 1)
  end
end

-- 是否进入过关区域
function MyStory:isPassArea (areaid)
  return areaid == self.passArea
end

-- 是否是进入水管区域
function MyStory:isEnterArea (areaid)
  return areaid == self.enterArea
end

-- 是否是隐藏方块区域
function MyStory:isHideBlockArea (areaid)
  for i, v in ipairs(self.hideBlockAreas) do
    if (v == areaid) then
      return true
    end
  end
  return false
end

-- 替换水管头
function MyStory:replacePipe (x, y, z)
  local blockid = BlockHelper:getBlockID(x, y, z)
  if (not(blockid) or blockid ~= MyMap.BLOCK.ENTER_PIPE) then
    BlockHelper:replaceBlock(MyMap.BLOCK.ENTER_PIPE, x, y, z)
    TimeHelper:callFnAfterSecond(function ()
      self:replacePipe(x, y, z)
    end, 2)
  end
end

function MyStory:enter (objid)
  if (PlayerHelper:isMainPlayer(objid)) then -- 本地玩家，则开始计时
    ActorHelper:setMyPosition(objid, self.initPos) -- 初始位置
    PlayerHelper:setRevivePoint(objid, self.initPos.x, self.initPos.y, self.initPos.z)
    if (MyStoryHelper.index ~= 1) then
      local time = TimerHelper:getTimerTime(MyGameHelper.timerid)
      TimerHelper:changeTimerTime(MyGameHelper.timerid, time + self.backwardTimer)
    end
  else
    ActorHelper:setMyPosition(objid, self.initPos.x - 2, self.initPos.y, self.initPos.z)
    PlayerHelper:setRevivePoint(objid, self.initPos.x - 2, self.initPos.y, self.initPos.z)
  end
  ActorHelper:setFaceYaw(objid, 0)
  PlayerHelper:rotateCamera(objid, 90, 0)
  local player = PlayerHelper:getPlayer(objid)
  player.isUnderground = false
end

-- 如需恢复剧情信息，则重写此方法
function MyStory:recover (player)
  -- body
end