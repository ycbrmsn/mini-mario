-- 我的区域工具类
MyAreaHelper = {
  doorPositionData = {},
  doorPositions = {},
  hideBlock = {},
  hideBlockAreas = {},
  checkPoint = {
    { 0.5, 57.5 }
  },
  passPoints = { -- 过关区域点
    { 0, 57, -330 }
  },
  passAreas = {} -- 过关区域
}

-- 初始化
function MyAreaHelper:init ()
  self:initDoorAreas()
  self:initShowToastAreas()
  -- body
  MyAreaHelper:initHideBlocks()
  MyAreaHelper:initPassAreas()
end

-- 初始化显示飘窗区域
function MyAreaHelper:initShowToastAreas ()
  -- local arr = { wolf, ox }
  -- for i, v in ipairs(arr) do
  --   if (v.generate) then -- 如果需要生成怪物
  --     AreaHelper:addToastArea(v.areaids[2], { v.areaids[1], v.areaName, v.generate })
  --   else
  --     AreaHelper:addToastArea(v.areaids[2], { v.areaids[1], v.areaName })
  --   end
  -- end
end

-- 初始化所有actor可打开的门的位置
function MyAreaHelper:initDoorAreas ()
  for i, v in ipairs(self.doorPositionData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    local areaid = AreaHelper:getAreaByPos(pos)
    table.insert(AreaHelper.allDoorAreas, areaid, pos)
  end
end

-- 获取所有的门位置
function MyAreaHelper:getDoorPositions ()
  return self.doorPositions
end

-- 根据位置数据初始化区域
function MyAreaHelper:initAreaByData (data, areas)
  for i, v in ipairs(data) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    local areaid = AreaHelper:getAreaByPos(pos)
    table.insert(areas, areaid)
  end
end

-- 初始化隐藏方块
function MyAreaHelper:initHideBlocks ()
  MyAreaHelper:initAreaByData(self.hideBlock, self.hideBlockAreas)
end

-- 初始化过关区域
function MyAreaHelper:initPassAreas ()
  MyAreaHelper:initAreaByData(self.passPoints, self.passAreas)
end

-- 是否进入隐藏方块区域
function MyAreaHelper:doesEnterHideBlockArea (areaid)
  for i, v in ipairs(self.hideBlockAreas) do
    if (v == areaid) then
      return true
    end
  end
  return false
end

-- 是否进入过关区域 返回boolean、 number
function MyAreaHelper:doesEnterPassArea (areaid)
  for i, v in ipairs(self.passAreas) do
    if (v == areaid) then
      return true, i
    end
  end
end