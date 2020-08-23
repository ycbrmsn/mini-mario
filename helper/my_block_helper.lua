-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {},
  unableDestroyed = {},
  luckyBlockData = { -- x, y, z, category, num
    { 0, 10, -8, 3, 1 }
  },
  luckyBlockInfos = {}
}

-- 初始化
function MyBlockHelper:init ()
  -- body
  MyBlockHelper:initBlocks()
  MyBlockHelper:initLuckyBlocks()
end

function MyBlockHelper:initBlocks ()
  for i,v in ipairs(self.unableBeoperated) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(self.unableDestroyed) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 初始化幸运方块
function MyBlockHelper:initLuckyBlocks ()
  for i, v in ipairs(self.luckyBlockData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    self.luckyBlockInfos[pos:toSimpleString()] = { pos = pos, category = v[4], num = v[5] }
  end
end

-- 获取幸运方块信息
function MyBlockHelper:getLuckyBlockInfo (x, y, z)
  x, y, z = math.floor(x), math.floor(y), math.floor(z)
  local pos = MyPosition:new(x, y, z)
  local luckyBlockInfo = self.luckyBlockInfos[pos:toSimpleString()]
  if (not(luckyBlockInfo)) then
    luckyBlockInfo = { pos = pos, category = 1, num = 1 }
    self.luckyBlockInfos[pos:toSimpleString()] = luckyBlockInfo
  end
  return luckyBlockInfo
end

-- 事件

-- 方块被破坏
function MyBlockHelper:blockDestroyBy (objid, blockid, x, y, z)
  BlockHelper:blockDestroyBy(objid, blockid, x, y, z)
  -- body
end

-- 完成方块挖掘
function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  BlockHelper:blockDigEnd(objid, blockid, x, y, z)
  -- body
end

-- 方块被放置
function MyBlockHelper:blockPlaceBy (objid, blockid, x, y, z)
  BlockHelper:blockPlaceBy(objid, blockid, x, y, z)
  -- body
end

-- 方块被移除
function MyBlockHelper:blockRemove (blockid, x, y, z)
  BlockHelper:blockRemove(blockid, x, y, z)
  -- body
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  -- body
end