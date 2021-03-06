-- 我的区域工具类
MyAreaHelper = {
  doorPositionData = {},
  doorPositions = {},
}

-- 初始化
function MyAreaHelper.init ()
  MyAreaHelper.initDoorAreas()
  MyAreaHelper.initShowToastAreas()
  -- body
end

-- 初始化显示飘窗区域
function MyAreaHelper.initShowToastAreas ()
  -- local arr = { wolf, ox }
  -- for i, v in ipairs(arr) do
  --   if (v.generate) then -- 如果需要生成怪物
  --     AreaHelper.addToastArea(v.areaids[2], { v.areaids[1], v.areaName, v.generate })
  --   else
  --     AreaHelper.addToastArea(v.areaids[2], { v.areaids[1], v.areaName })
  --   end
  -- end
end

-- 初始化所有actor可打开的门的位置
function MyAreaHelper.initDoorAreas ()
  for i, v in ipairs(MyAreaHelper.doorPositionData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    local areaid = AreaHelper.getAreaByPos(pos)
    table.insert(AreaHelper.allDoorAreas, areaid, pos)
  end
end

-- 获取所有的门位置
function MyAreaHelper.getDoorPositions ()
  return MyAreaHelper.doorPositions
end
