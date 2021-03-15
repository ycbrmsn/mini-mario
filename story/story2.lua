-- 剧情二
Story2 = MyStory:new()

function Story2:new ()
  local data = {
    title = '第二关',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    index = 2,
    initPos = MyPosition:new(81.5, 57.5, 0.5),
    luckyBlockData = { -- x, y, z, category, num
      { 81, 60, -8, 3, 1 }, -- 蘑菇
      { 81, 64, -85, 2, 1 }, -- 星星
    },
    maybeKeyBlockData = {
      { 81, 13, -38 },
      { 81, 13, -52 },
      { 81, 13, -65 },
    }, -- 城堡钥匙可能出现的方块位置数据
    sureHideBlockData = {
      { 81, 60, -325, 5, 1 }, -- 复活药丸
    }, -- 确定的隐藏方块
    hideBlockPosData = {
      { 81.5, 60.5, -24.5 },
      { 81.5, 60.5, -25.5 },
      { 81.5, 60.5, -26.5 },
      { 81.5, 60.5, -27.5 },
      { 81.5, 60.5, -29.5 },
      { 81.5, 60.5, -30.5 },
      { 81.5, 60.5, -31.5 },
      { 81.5, 60.5, -32.5 },
      { 81.5, 60.5, -50.5 },
      { 81.5, 60.5, -51.5 },
      { 81.5, 60.5, -52.5 },
      { 81.5, 60.5, -53.5 },
      { 81.5, 60.5, -54.5 },
      { 81.5, 60.5, -73.5 },
      { 81.5, 60.5, -74.5 },
      { 81.5, 60.5, -75.5 },
      { 81.5, 60.5, -76.5 },
      { 81.5, 60.5, -77.5 },
      { 81.5, 60.5, -91.5 },
      { 81.5, 60.5, -92.5 },
      { 81.5, 60.5, -93.5 },
      { 81.5, 60.5, -94.5 },
      { 81.5, 60.5, -95.5 },
      { 81.5, 60.5, -129.5 },
      { 81.5, 60.5, -130.5 },
      { 81.5, 60.5, -131.5 },
      { 81.5, 60.5, -132.5 },
      { 81.5, 60.5, -134.5 },
      { 81.5, 60.5, -135.5 },
      { 81.5, 60.5, -136.5 },
      { 81.5, 60.5, -137.5 },
      { 81.5, 60.5, -194.5 },
      { 81.5, 60.5, -195.5 },
      { 81.5, 60.5, -196.5 },
      { 81.5, 60.5, -197.5 },
    }, -- 隐藏方块位置数据
    hideBlockAreas = {}, -- 隐藏方块区域
    enterPosData = {
      { 81.5, 60.5, -13.5 },
      { 81.5, 60.5, -41.5 },
      { 81.5, 60.5, -66.5 },
      { 81.5, 61.5, -84.5 },
      { 81.5, 60.5, -144.5 },
      { 81.5, 61.5, -157.5 },
      { 81.5, 62.5, -167.5 },
      { 81.5, 59.5, -188.5 },
      { 81.5, 60.5, -206.5 },
      { 81.5, 58.5, -302.5 },
    }, -- 进入水管位置数据
    enterPos = nil, -- 进入水管区域位置
    enterAreas = {}, -- 进入水管区域
    enterArea = -1, -- 进入地下区域
    leaveArea = -1, -- 离开地下区域
    backwardTimer = 300, -- 倒计时
    undergroundBeginPos = MyPosition:new(81.5, 18, 2.5), -- 刚进入地下水管的位置
    undergroundEndPos = MyPosition:new(81.5, 7.5, -118.5), -- 准备出地下水管的位置
    passPos = MyPosition:new(81, 57, -330), -- 过关区域位置
    passArea = -1 -- 过关区域
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end
