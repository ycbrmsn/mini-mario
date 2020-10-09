-- 剧情三
Story3 = MyStory:new()

function Story3:new ()
  local data = {
    title = '第三关',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    initPos = MyPosition:new(162.5, 57.5, 0.5),
    luckyBlockData = { -- x, y, z, category, num
      { 162, 60, -8, 3, 1 }, -- 蘑菇
      { 162, 66, -118, 2, 1 }, -- 星星
    },
    maybeKeyBlockData = {
      { 162, 17, -31 },
      { 162, 20, -36 },
      { 162, 18, -42 },
    }, -- 城堡钥匙可能出现的方块位置数据
    sureHideBlockData = {
      { 162, 64, -177, 1, 1 },
      { 162, 60, -184, 1, 1 },
      { 162, 60, -325, 5, 1 }, -- 续命药丸
    }, -- 确定的隐藏方块
    hideBlockPosData = {
      { 162, 60.5, -18 },
      { 162, 60.5, -19 },
      { 162, 60.5, -27 },
      { 162, 60.5, -28 },
      { 162, 60.5, -34 },
      { 162, 60.5, -35 },
      { 162, 60.5, -36 },
      { 162, 60.5, -37 },
      { 162, 60.5, -38 },
      { 162, 60.5, -40 },
      { 162, 60.5, -41 },
      { 162, 60.5, -42 },
      { 162, 60.5, -43 },
      { 162, 60.5, -45 },
      { 162, 60.5, -46 },
      { 162, 60.5, -47 },
      { 162, 60.5, -48 },
      { 162, 60.5, -50 },
      { 162, 60.5, -51 },
      { 162, 60.5, -52 },
      { 162, 60.5, -53 },
      { 162, 60.5, -57 },
      { 162, 60.5, -58 },
      { 162, 60.5, -59 },
      { 162, 60.5, -60 },
      { 162, 60.5, -61 },
      { 162, 60.5, -62 },
      { 162, 60.5, -63 },
      { 162, 60.5, -64 },
      { 162, 60.5, -65 },
      { 162, 60.5, -66 },
      { 162, 60.5, -67 },
      { 162, 60.5, -68 },
      { 162, 60.5, -69 },
      { 162, 60.5, -70 },
      { 162, 60.5, -71 },
      { 162, 60.5, -75 },
      { 162, 60.5, -76 },
      { 162, 60.5, -77 },
      { 162, 60.5, -78 },
      { 162, 60.5, -79 },
      { 162, 60.5, -80 },
      { 162, 60.5, -81 },
      { 162, 60.5, -82 },
      { 162, 60.5, -83 },
      { 162, 60.5, -84 },
      { 162, 60.5, -88 },
      { 162, 60.5, -89 },
      { 162, 60.5, -158 },
      { 162, 60.5, -159 },
      { 162, 60.5, -185 },
      { 162, 60.5, -186 },
      { 162, 60.5, -187 },
      { 162, 60.5, -188 },
      { 162, 60.5, -189 },
      { 162, 60.5, -190 },
      { 162, 60.5, -191 },
    }, -- 隐藏方块位置数据
    hideBlockAreas = {}, -- 隐藏方块区域
    enterPosData = {
      { 162.5, 61.5, -30.5 },
      { 162.5, 61.5, -54.5 },
      { 162.5, 61.5, -72.5 },
      { 162.5, 61.5, -85.5 },
      { 162.5, 60.5, -92.5 },
      { 162.5, 61.5, -161.5 },
      { 162.5, 67.5, -172.5 },
      { 162.5, 61.5, -177.5 },
      { 162.5, 64.5, -181.5 },
      { 162.5, 58.5, -302.5 },
    }, -- 进入水管位置数据
    enterPos = nil, -- 进入水管区域位置
    enterAreas = {}, -- 进入水管区域
    enterArea = -1, -- 进入地下区域
    leaveArea = -1, -- 离开地下区域
    backwardTimer = 200, -- 倒计时
    undergroundBeginPos = MyPosition:new(162.5, 18, 2.5), -- 刚进入地下水管的位置
    undergroundEndPos = MyPosition:new(162.5, 7.5, -118.5), -- 准备出地下水管的位置
    passPos = MyPosition:new(162, 57, -330), -- 过关区域位置
    passArea = -1 -- 过关区域
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end
