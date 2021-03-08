-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {},
  unableDestroyed = {},
  luckyBlockInfos = {}
}

-- 初始化
function MyBlockHelper.init ()
  -- body
  MyBlockHelper.initBlocks()
end

function MyBlockHelper.initBlocks ()
  for i,v in ipairs(MyBlockHelper.unableBeoperated) do
    BlockHelper.setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(MyBlockHelper.unableDestroyed) do
    BlockHelper.setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 添加隐藏方块数据
function MyBlockHelper.addLuckyBlockData (pos, category, num)
  MyBlockHelper.luckyBlockInfos[pos:toSimpleString()] = { pos = pos, category = category, num = num }
end

-- 获取幸运方块信息
function MyBlockHelper.getLuckyBlockInfo (x, y, z)
  x, y, z = math.floor(x), math.floor(y), math.floor(z)
  local pos = MyPosition:new(x, y, z)
  local luckyBlockInfo = MyBlockHelper.luckyBlockInfos[pos:toSimpleString()]
  if (not(luckyBlockInfo)) then
    luckyBlockInfo = { pos = pos, category = 1, num = math.random(1, 5) } -- 1~5枚金币
    MyBlockHelper.luckyBlockInfos[pos:toSimpleString()] = luckyBlockInfo
  end
  return luckyBlockInfo
end
