-- 我的剧情工具类
MyStoryHelper = {
  initPosition = MyPosition:new(0.5, 7.5, 0.5)
}

function MyStoryHelper:init ()
  story1 = Story1:new()
  StoryHelper:setStorys({ story1 })
end

-- 事件

-- 世界时间到[n]点
function MyStoryHelper:atHour (hour)
  StoryHelper:atHour(hour)
  -- body
end

-- 玩家进入游戏
function MyStoryHelper:playerEnterGame (objid)
  local player = PlayerHelper:getPlayer(objid)
  local hostPlayer = PlayerHelper:getHostPlayer()
  -- if (player == hostPlayer) then -- 房主
  --   if (not(GameDataHelper:updateStoryData())) then -- 刚开始游戏
  --   end
  -- end
  -- 更新玩家数据
  -- if (GameDataHelper:updatePlayerData(player)) then -- 再次进入游戏
  --   -- do nothing
  -- else -- 刚进入游戏
  -- end
  -- PlayerHelper:changeVMode(objid, VIEWPORTTYPE.CUSTOMVIEW, true) -- 锁定自定义视角
  PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.WEST, 0) -- 看向正东方
  PlayerHelper:setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, false) -- 不可被攻击
  player:setMyPosition(self.initPosition)
  PlayerHelper:setRevivePoint(objid, self.initPosition.x, self.initPosition.y, self.initPosition.z)
  StoryHelper:recover(player) -- 恢复剧情
end

-- 玩家离开游戏
function MyStoryHelper:playerLeaveGame (objid)
  -- body
end

-- 玩家进入区域
function MyStoryHelper:playerEnterArea (objid, areaid)
  -- body
end

-- 玩家离开区域
function MyStoryHelper:playerLeaveArea (objid, areaid)
  -- body
end

-- 玩家点击方块
function MyStoryHelper:playerClickBlock (objid, blockid, x, y, z)
  -- body
end

-- 玩家点击生物
function MyStoryHelper:playerClickActor (objid, toobjid)
  -- body
end

-- 玩家获得道具
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  -- body
end

-- 玩家使用道具
function MyStoryHelper:playerUseItem (objid, itemid)
  -- body
end

-- 玩家攻击命中
function MyStoryHelper:playerAttackHit (objid, toobjid)
  -- body
end

-- 玩家造成伤害
function MyStoryHelper:playerDamageActor (objid, toobjid)
  -- body
end

-- 玩家击败生物
function MyStoryHelper:playerDefeatActor (playerid, objid)
  -- body
end

-- 玩家受到伤害
function MyStoryHelper:playerBeHurt (objid, toobjid)
  -- body
end

-- 玩家死亡
function MyStoryHelper:playerDie (objid, toobjid)
  -- body
end

-- 玩家复活
function MyStoryHelper:playerRevive (objid, toobjid)
  -- body
end

-- 玩家选择快捷栏
function MyStoryHelper:playerSelectShortcut (objid)
  -- body
end

-- 玩家快捷栏变化
function MyStoryHelper:playerShortcutChange (objid)
  -- body
end

-- 玩家运动状态改变
function MyStoryHelper:playerMotionStateChange (objid, playermotion)
  -- body
end

-- 玩家移动一格
function MyStoryHelper:playerMoveOneBlockSize (objid)
  -- body
end

-- 玩家骑乘
function MyStoryHelper:playerMountActor (objid, toobjid)
  -- body
end

-- 玩家取消骑乘
function MyStoryHelper:playerDismountActor (objid, toobjid)
  -- body
end

-- 生物进入区域
function MyStoryHelper:actorEnterArea (objid, areaid)
  -- body
end

-- 生物离开区域
function MyStoryHelper:actorLeaveArea (objid, areaid)
  -- body
end

-- 生物碰撞
function MyStoryHelper:actorCollide (objid, toobjid)
  -- body
end

-- 生物攻击命中
function MyStoryHelper:actorAttackHit (objid, toobjid)
  -- body
end

-- 生物行为改变
function MyStoryHelper:actorChangeMotion (objid, actormotion)
  -- body
end

-- 生物死亡
function MyStoryHelper:actorDie (objid, toobjid)
  -- body
end
