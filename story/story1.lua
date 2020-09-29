-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '第一关',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    hideBlockPosData = {
      { 0.5, 60.5, -38.5 },
      { 0.5, 60.5, -39.5 },
      { 0.5, 60.5, -40.5 },
      { 0.5, 60.5, -41.5 },
      { 0.5, 60.5, -59.5 },
      { 0.5, 60.5, -60.5 },
      { 0.5, 60.5, -61.5 },
      { 0.5, 60.5, -62.5 },
      { 0.5, 60.5, -63.5 },
      { 0.5, 60.5, -102.5 },
      { 0.5, 60.5, -103.5 },
      { 0.5, 60.5, -104.5 },
      { 0.5, 60.5, -105.5 },
      { 0.5, 60.5, -106.5 },
      { 0.5, 60.5, -153.5 },
      { 0.5, 60.5, -154.5 },
      { 0.5, 60.5, -155.5 },
      { 0.5, 60.5, -156.5 },
      { 0.5, 60.5, -157.5 },
      { 0.5, 60.5, -158.5 },
      { 0.5, 60.5, -159.5 },
      { 0.5, 60.5, -160.5 },
      { 0.5, 60.5, -161.5 },
      { 0.5, 60.5, -162.5 },
      { 0.5, 60.5, -163.5 },
      { 0.5, 60.5, -164.5 },
      { 0.5, 60.5, -194.5 },
      { 0.5, 60.5, -195.5 },
      { 0.5, 60.5, -196.5 },
      { 0.5, 60.5, -197.5 },
      { 0.5, 60.5, -229.5 },
      { 0.5, 60.5, -230.5 },
      { 0.5, 60.5, -231.5 },
      { 0.5, 60.5, -232.5 },
    }, -- 隐藏方块位置数据
    hideBlockAreas = {}, -- 隐藏方块区域
    enterPosData = {
      { 0.5, 60.5, -15.5 },
      { 0.5, 59.5, -25.5 },
      { 0.5, 59.5, -47.5 },
      { 0.5, 59.5, -119.5 },
      { 0.5, 60.5, -176.5 },
      { 0.5, 59.5, -191.5 },
      { 0.5, 59.5, -235.5 },
      { 0.5, 59.5, -245.5 },
      { 0.5, 67.5, -273.5 }
    }, -- 进入水管位置数据
    enterAreas = {}, -- 进入水管区域
    goOutPos = MyPosition:new(0.5, 58.5, -302.5), -- 出水管位置
    backwardTimer = 300, -- 倒计时
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story1:init ()
  self:initEnterPipe()
  self:initHideBlockAreas()
end

function Story1:initEnterPipe ()
  AreaHelper:initAreaByPosData(self.enterPosData, self.enterAreas)
  -- 设置进入水管区域
  math.random()
  math.random()
  local index = math.random(1, #self.enterAreas)
  self.enterArea = self.enterAreas[index]
  self:replacePipe(self.enterPosData[index])
  LogHelper:debug('替换第', index, '个')
end

-- 初始化8个隐藏区域
function Story1:initHideBlockAreas ()
  for i = 1, 8 do
    local index = math.random(1, #self.hideBlockPosData) -- 随机取一个
    local pos = MyPosition:new(self.hideBlockPosData[index][1],
      self.hideBlockPosData[index][2], self.hideBlockPosData[index][3])
    local areaid = AreaHelper:createAreaRectByRange(pos, pos)
    table.insert(self.hideBlockAreas, areaid)
    table.remove(self.hideBlockPosData, index)
  end
end

-- 是否是进入水管区域
function Story1:isEnterArea (areaid)
  for i, v in ipairs(self.enterAreas) do
    if (v == areaid) then
      return true
    end
  end
  return false
end

-- 是否是隐藏方块区域
function Story1:isHideBlockArea (areaid)
  for i, v in ipairs(self.hideBlockAreas) do
    if (v == areaid) then
      return true
    end
  end
  return false
end

function Story1:replacePipe (data)
  local x, y, z = data[1], data[2] - 1, data[3]
  local blockid = BlockHelper:getBlockID(x, y, z)
  if (not(blockid) or blockid ~= MyMap.BLOCK.ENTER_PIPE) then
    BlockHelper:replaceBlock(MyMap.BLOCK.ENTER_PIPE, x, y, z)
    TimeHelper:callFnAfterSecond(function ()
      self:replacePipe(data)
    end, 1)
  end
end

function Story1:recover (player)
  -- body
end