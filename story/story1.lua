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
    initPos = MyPosition:new(0.5, 57.5, 0.5),
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
      { 0.5, 67.5, -273.5 },
      { 0.5, 58.5, -302.5 },
    }, -- 进入水管位置数据
    enterPos = nil, -- 进入水管区域位置
    enterAreas = {}, -- 进入水管区域
    enterArea = -1, -- 进入地下区域
    leaveArea = -1, -- 离开地下区域
    backwardTimer = 300, -- 倒计时
    undergroundBeginPos = MyPosition:new(0.5, 18, 2.5), -- 刚进入地下水管的位置
    undergroundEndPos = MyPosition:new(0.5, 7.5, -118.5), -- 准备出地下水管的位置
    passPos = MyPosition:new(0, 57, -330), -- 过关区域位置
    passArea = -1 -- 过关区域
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end
