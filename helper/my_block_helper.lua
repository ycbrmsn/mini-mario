-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {},
  unableDestroyed = {}
}

-- 初始化
function MyBlockHelper:init ()
  -- body
  MyBlockHelper:initBlocks()
end

function MyBlockHelper:initBlocks ()
  for i,v in ipairs(self.unableBeoperated) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(self.unableDestroyed) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 事件

-- 完成方块挖掘
function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  BlockHelper:blockDigEnd(objid, blockid, x, y, z)
  -- body
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  -- body
end