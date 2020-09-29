-- 我的玩家工具类
MyPlayerHelper = {
  initPosition = MyPosition:new(0.5, 57.5, 0.5),
}

-- 事件

-- 玩家进入游戏
function MyPlayerHelper:playerEnterGame (objid)
  PlayerHelper:playerEnterGame(objid)
  MyStoryHelper:playerEnterGame(objid)
  -- body
  PlayerHelper:setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, false) -- 不可被攻击
  -- BackpackHelper:setGridItem(objid, 1007, MyMap.ITEM.JUMP, 1) -- 跳跃键
  -- PlayerHelper:setItemDisableThrow(objid, MyMap.ITEM.JUMP) -- 不可丢弃
  BackpackHelper:addItem(objid, MyMap.ITEM.PILL, 3) -- 三颗续命药丸
  ActorHelper:setMyPosition(objid, self.initPosition) -- 初始位置
  ActorHelper:setFaceYaw(objid, 0)
  PlayerHelper:rotateCamera(objid, 90, 0)
  PlayerHelper:setRevivePoint(objid, self.initPosition.x, self.initPosition.y, self.initPosition.z)
  if (PlayerHelper:isMainPlayer(objid)) then -- 本地玩家，则开始计时
    -- 游戏开始计时
    MyGameHelper.timerid = TimerHelper:getTimer(timername)
    TimerHelper:startForwardTimer(MyGameHelper.timerid)
  end
  -- 播放背景音乐
  MusicHelper:startBGM(objid, 1, true)
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
  if (isPass) then -- 过关区域
    local num = BackpackHelper:getItemNumAndGrid2(objid, MyMap.ITEM.KEY)
    if (num > 0) then
      if (BackpackHelper:removeGridItemByItemID(objid, MyMap.ITEM.KEY, 1)) then
        PlayerHelper:setGameWin(objid)
      else
        ChatHelper:sendMsg(objid, '缺少城堡钥匙，无法进入城堡')
      end
    else
      ChatHelper:sendMsg(objid, '缺少城堡钥匙，无法进入城堡')
    end
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
  if (itemid == MyMap.ITEM.BOTTLE) then -- 续命药瓶
    BackpackHelper:removeGridItemByItemID(objid, itemid, itemnum)
    if (player.isWatchStyle) then -- 观战模式
      BackpackHelper:addItem(objid, MyMap.ITEM.PILL, itemnum * 3 - 1)
      ActorHelper:addBuff(objid, MyMap.BUFF.CONTINUE, 1, 60)
      player.isWatchStyle = false
      local pos = player.revivePoint
      player:setMyPosition(pos.x, pos.y, pos.z) -- 重回复活点
    else
      BackpackHelper:addItem(objid, MyMap.ITEM.PILL, itemnum * 3) -- 三倍
    end
  elseif (itemid == MyMap.ITEM.COIN) then -- 幸运币
    -- 一个加5分
    local teamid = PlayerHelper:getTeam(objid)
    TeamHelper:addTeamScore(teamid, itemnum * 5)
    -- 100枚换一颗续命丹
    local num = BackpackHelper:getItemNumAndGrid(objid, itemid)
    if (num >= 100) then
      BackpackHelper:removeGridItemByItemID(objid, itemid, 100)
      BackpackHelper:addItem(objid, MyMap.ITEM.PILL, 1)
    end
  end
end

-- 玩家使用道具
function MyPlayerHelper:playerUseItem (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerUseItem(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerUseItem(objid, toobjid, itemid, itemnum)
end

-- 玩家消耗道具
function MyPlayerHelper:playerConsumeItem (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerConsumeItem(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerConsumeItem(objid, toobjid, itemid, itemnum)
end

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  PlayerHelper:playerAttackHit(objid, toobjid)
  MyStoryHelper:playerAttackHit(objid, toobjid)
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid, hurtlv)
  PlayerHelper:playerDamageActor(objid, toobjid)
  MyStoryHelper:playerDamageActor(objid, toobjid)
end

-- 玩家击败目标
function MyPlayerHelper:playerDefeatActor (objid, toobjid)
  local realDefeat = PlayerHelper:playerDefeatActor(objid, toobjid)
  MyStoryHelper:playerDefeatActor(objid, toobjid)
  -- body
end

-- 玩家受到伤害
function MyPlayerHelper:playerBeHurt (objid, toobjid, hurtlv)
  PlayerHelper:playerBeHurt(objid, toobjid, hurtlv)
  MyStoryHelper:playerBeHurt(objid, toobjid, hurtlv)
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
function MyPlayerHelper:playerSelectShortcut (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerSelectShortcut(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerSelectShortcut(objid, toobjid, itemid, itemnum)
  -- body
  -- local player = PlayerHelper:getPlayer(objid)
  -- if (itemid == MyMap.ITEM.JUMP) then -- 跳跃键
  --   if (not(ActorHelper:isInAir(objid, player.x, player.y, player.z))) then
  --     ActorHelper:appendSpeed(objid, 0, 1, 0)
  --   end
  -- end
end

-- 玩家快捷栏变化
function MyPlayerHelper:playerShortcutChange (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerShortcutChange(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerShortcutChange(objid, toobjid, itemid, itemnum)
end

-- 玩家运动状态改变
function MyPlayerHelper:playerMotionStateChange (objid, playermotion)
  PlayerHelper:playerMotionStateChange(objid, playermotion)
  MyStoryHelper:playerMotionStateChange(objid, playermotion)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (playermotion == PLAYERMOTION.JUMP) then -- 跳跃
    ActorHelper:appendSpeed(objid, 0, 0.6, 0)
  -- elseif (playermotion == PLAYERMOTION.STATIC) then -- 静止
    -- player.isRunning = false
    -- LogHelper:debug('静止')
  -- elseif (playermotion == PLAYERMOTION.WALK) then -- 行走
    -- LogHelper:debug('行走')
  -- elseif (playermotion == PLAYERMOTION.FALL_GROUND) then -- 落地
  elseif (playermotion == PLAYERMOTION.SNEAK) then -- 潜行
    local pos = player:getMyPosition()
    if (AreaHelper:posInArea(pos, story1.enterArea)) then
      LogHelper:debug('进入水管')
    end
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

-- 按键被按下
function MyPlayerHelper:playerInputKeyDown (objid, vkey)
  PlayerHelper:playerInputKeyDown(objid, vkey)
  MyStoryHelper:playerInputKeyDown(objid, vkey)
end

-- 按键处于按下状态
function MyPlayerHelper:playerInputKeyOnPress (objid, vkey)
  PlayerHelper:playerInputKeyOnPress(objid, vkey)
  MyStoryHelper:playerInputKeyOnPress(objid, vkey)
end

-- 按键松开
function MyPlayerHelper:playerInputKeyUp (objid, vkey)
  PlayerHelper:playerInputKeyUp(objid, vkey)
  MyStoryHelper:playerInputKeyUp(objid, vkey)
end

-- 等级发生变化
function MyPlayerHelper:playerLevelModelUpgrade (objid, toobjid)
  PlayerHelper:playerLevelModelUpgrade(objid, toobjid)
  MyStoryHelper:playerLevelModelUpgrade(objid, toobjid)
end