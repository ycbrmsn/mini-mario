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
    }, -- 进入水管区域位置点
    enterAreas = {}, -- 进入水管区域
    goOutPos = MyPosition:new(0.5, 58.5, -302.5), -- 出水管位置
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story1:init ()
  AreaHelper:initAreaByPosData(self.enterPosData, self.enterAreas)
  -- 设置进入水管区域
  math.random()
  math.random()
  local index = math.random(1, #self.enterAreas)
  self.enterArea = self.enterAreas[index]
  self:replacePipe(self.enterPosData[index])
  LogHelper:debug('替换第', index, '个')
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