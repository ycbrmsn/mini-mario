-- 我的玩家工具类
MyPlayerHelper = {
  initPosition = MyPosition:new(0.5, 57.5, 0.5)
}

-- 事件

-- 玩家进入游戏
function MyPlayerHelper:playerEnterGame (objid)
  PlayerHelper:playerEnterGame(objid)
  MyStoryHelper:playerEnterGame(objid)
  -- body
  PlayerHelper:setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, false) -- 不可被攻击
  BackpackHelper:addItem(objid, MyMap.ITEM.PILL, 5) -- 五颗续命药丸
  ActorHelper:setMyPosition(objid, self.initPosition)
  ActorHelper:setFaceYaw(objid, 0)
  PlayerHelper:rotateCamera(objid, 90, 0)
  PlayerHelper:setRevivePoint(objid, self.initPosition.x, self.initPosition.y, self.initPosition.z)
  MusicHelper:playBGM(objid, BGM[1], true)
end

-- 玩家离开游戏
function MyPlayerHelper:playerLeaveGame (objid)
  PlayerHelper:playerLeaveGame(objid)
  MyStoryHelper:playerLeaveGame(objid)
  MusicHelper:stopBGM(objid)
end

-- 玩家进入区域
function MyPlayerHelper:playerEnterArea (objid, areaid)
  PlayerHelper:playerEnterArea(objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  -- body
  local isPass, index = MyAreaHelper:doesEnterPassArea(areaid)
  if (isPass) then -- 过关
    PlayerHelper:setGameWin(objid)
  else -- 进入隐藏方块区域
    local player = PlayerHelper:getPlayer(objid)
    local pos = player:getMyPosition()
    if (pos.y - player.y > 0) then -- 在上升中
      local dimension = PlayerHelper:getDimension(objid)
      local height = (ActorHelper:getEyeHeight(objid) + 0.6) * dimension
      if (AreaHelper:posInArea(MyPosition:new(pos.x, pos.y + height, pos.z), areaid)) then
        AreaHelper:fillBlock(areaid, 104) -- 填充岩石
        player:headHitBlock(true)
      end
    end
  end
end

-- 玩家离开区域
function MyPlayerHelper:playerLeaveArea (objid, areaid)
  PlayerHelper:playerLeaveArea(objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

-- 玩家点击方块
function MyPlayerHelper:playerClickBlock (objid, blockid, x, y, z)
  PlayerHelper:playerClickBlock(objid, blockid, x, y, z)
  MyStoryHelper:playerClickBlock(objid, blockid, x, y, z)
  -- body
end

-- 玩家点击生物
function MyPlayerHelper:playerClickActor (objid, toobjid)
  PlayerHelper:playerClickActor(objid, toobjid)
  MyStoryHelper:playerClickActor(objid, toobjid)
end

-- 玩家获得道具
function MyPlayerHelper:playerAddItem (objid, itemid, itemnum)
  PlayerHelper:playerAddItem(objid, itemid, itemnum)
  MyStoryHelper:playerAddItem(objid, itemid, itemnum)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (itemid == MyMap.ITEM.BOTTLE) then
    BackpackHelper:removeGridItemByItemID(objid, itemid, itemnum)
    if (player.isWatchStyle) then -- 观战模式
      BackpackHelper:addItem(objid, MyMap.ITEM.PILL, itemnum * 5 - 1)
      ActorHelper:addBuff(objid, MyMap.BUFF.CONTINUE, 1, 60)
      player.isWatchStyle = false
      local pos = player.revivePoint
      player:setMyPosition(pos.x, pos.y, pos.z) -- 重回复活点
    else
      BackpackHelper:addItem(objid, MyMap.ITEM.PILL, itemnum * 5) -- 五倍
    end
  end
end

-- 玩家使用道具
function MyPlayerHelper:playerUseItem (objid, itemid)
  PlayerHelper:playerUseItem(objid, itemid)
  MyStoryHelper:playerUseItem(objid, itemid)
end

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  PlayerHelper:playerAttackHit(objid, toobjid)
  MyStoryHelper:playerAttackHit(objid, toobjid)
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid)
  PlayerHelper:playerDamageActor(objid, toobjid)
  MyStoryHelper:playerDamageActor(objid, toobjid)
end

-- 玩家击败目标
function MyPlayerHelper:playerDefeatActor (objid, toobjid)
  PlayerHelper:playerDefeatActor(objid, toobjid)
  MyStoryHelper:playerDefeatActor(objid, toobjid)
  -- body
end

-- 玩家受到伤害
function MyPlayerHelper:playerBeHurt (objid, toobjid)
  PlayerHelper:playerBeHurt(objid, toobjid)
  MyStoryHelper:playerBeHurt(objid, toobjid)
end

-- 玩家死亡
function MyPlayerHelper:playerDie (objid, toobjid)
  PlayerHelper:playerDie(objid, toobjid)
  MyStoryHelper:playerDie(objid, toobjid)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  player.notDead = false
  PlayerHelper:setDimension(objid, 1) -- 尺寸恢复1
  -- 设置重生位置
  local checkPointInfo = MyAreaHelper.checkPoint[player.checkPoint]
  local pos = player:getMyPosition()
  local x, y, z = checkPointInfo[1], checkPointInfo[2], math.ceil(pos.z / 100) * 100 + 0.5
  player.revivePoint = MyPosition:new(x, y, z)
  PlayerHelper:setRevivePoint(objid, x, y, z)
end

-- 玩家复活
function MyPlayerHelper:playerRevive (objid, toobjid)
  PlayerHelper:playerRevive(objid, toobjid)
  MyStoryHelper:playerRevive(objid, toobjid)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  player.notDead = true
  ActorHelper:setFaceYaw(objid, 0)
  local pillNum = BackpackHelper:getItemNumAndGrid2(objid, MyMap.ITEM.PILL)
  if (pillNum > 0) then -- 还有续命药丸
    BackpackHelper:removeGridItemByItemID(objid, MyMap.ITEM.PILL, 1)
  else -- 没有续命药丸了
    player.isWatchStyle = true
    local pos = player.revivePoint
    player:setMyPosition(pos.x - 2, pos.y, pos.z)
    ChatHelper:sendMsg(objid, '生命耗尽，可在商店购买续命药瓶')
  end
end

-- 玩家选择快捷栏
function MyPlayerHelper:playerSelectShortcut (objid)
  PlayerHelper:playerSelectShortcut(objid)
  MyStoryHelper:playerSelectShortcut(objid)
end

-- 玩家快捷栏变化
function MyPlayerHelper:playerShortcutChange (objid)
  PlayerHelper:playerShortcutChange(objid)
  MyStoryHelper:playerShortcutChange(objid)
end

-- 玩家运动状态改变
function MyPlayerHelper:playerMotionStateChange (objid, playermotion)
  PlayerHelper:playerMotionStateChange(objid, playermotion)
  MyStoryHelper:playerMotionStateChange(objid, playermotion)
  -- body
  if (playermotion == PLAYERMOTION.JUMP) then -- 跳跃
    ActorHelper:appendSpeed(objid, 0, 0.6, 0)
  end
end

-- 玩家移动一格
function MyPlayerHelper:playerMoveOneBlockSize (objid)
  PlayerHelper:playerMoveOneBlockSize(objid)
  MyStoryHelper:playerMoveOneBlockSize(objid)
  -- body
end

-- 玩家骑乘
function MyPlayerHelper:playerMountActor (objid, toobjid)
  PlayerHelper:playerMountActor(objid, toobjid)
  MyStoryHelper:playerMountActor(objid, toobjid)
end

-- 玩家取消骑乘
function MyPlayerHelper:playerDismountActor (objid, toobjid)
  PlayerHelper:playerDismountActor(objid, toobjid)
  MyStoryHelper:playerDismountActor(objid, toobjid)
end

-- 聊天输出界面变化
function MyPlayerHelper:playerInputContent(objid, content)
  PlayerHelper:playerInputContent(objid, content)
  MyStoryHelper:playerInputContent(objid, content)
end

-- 输入字符串
function MyPlayerHelper:playerNewInputContent(objid, content)
  PlayerHelper:playerNewInputContent(objid, content)
  MyStoryHelper:playerNewInputContent(objid, content)
end