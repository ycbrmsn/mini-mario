-- 剧情四
Story4 = MyStory:new()

function Story4:new ()
  local data = {
    title = '第四关',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    index = 4,
    initPos = MyPosition:new(243.5, 57.5, 0.5),
    luckyBlockData = { -- x, y, z, category, num
      { 243, 60, -8, 3, 1 }, -- 蘑菇
      { 243, 72, -245, 2, 1 }, -- 星星
    },
    maybeKeyBlockData = {
      { 243, 15, -62 },
      { 243, 15, -78 },
      { 243, 17, -85 },
    }, -- 城堡钥匙可能出现的方块位置数据
    sureHideBlockData = {
      { 243, 60, -325, 5, 1 }, -- 续命药丸
    }, -- 确定的隐藏方块
    hideBlockPosData = {
      { 243, 60.5, -14 },
      { 243, 60.5, -15 },
      { 243, 60.5, -16 },
      { 243, 60.5, -17 },
      { 243, 60.5, -18 },
      { 243, 60.5, -45 },
      { 243, 60.5, -46 },
    }, -- 隐藏方块位置数据
    hideBlockAreas = {}, -- 隐藏方块区域
    enterPosData = {
      { 243.5, 60.5, -27.5 },
      { 243.5, 61.5, -39.5 },
      { 243.5, 60.5, -49.5 },
      { 243.5, 60.5, -106.5 },
      { 243.5, 60.5, -160.5 },
      { 243.5, 61.5, -206.5 },
      { 243.5, 61.5, -261.5 },
      { 243.5, 61.5, -277.5 },
      { 243.5, 60.5, -293.5 },
      { 243.5, 58.5, -302.5 },
    }, -- 进入水管位置数据
    enterPos = nil, -- 进入水管区域位置
    enterAreas = {}, -- 进入水管区域
    enterArea = -1, -- 进入地下区域
    leaveArea = -1, -- 离开地下区域
    backwardTimer = 300, -- 倒计时
    undergroundBeginPos = MyPosition:new(243.5, 18, 2.5), -- 刚进入地下水管的位置
    undergroundEndPos = MyPosition:new(243.5, 7.5, -118.5), -- 准备出地下水管的位置
    passPos = MyPosition:new(243, 57, -330), -- 过关区域位置
    passArea = -1 -- 过关区域
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end
