-- 我的玩家工具类
MyPlayerHelper = {
  presents = {
    [807364131] = {
      items = {
        { MyMap.ITEM.PILL, 5 }, -- 续命药丸
        { MyMap.ITEM.TIME_SUPPLY, 1 }, -- 时间补给
        { MyMap.ITEM.DETECTOR, 1 }, -- 探测器
        { MyMap.ITEM.PERMIT, 1 }, -- 通行证
        -- { MyMap.ITEM.COIN, 60 }, -- 幸运币
        { MyMap.ITEM.FLOWER, 5 }, -- 花
      },
      msgMap = { present = '一些道具' }
    }, -- 作者
    [865147101] = {
      items = {
        { MyMap.ITEM.PILL, 5 }
      },
      msgMap = { present = '5颗续命药丸' }
    }, -- 懒懒
  }
}

function MyPlayerHelper.diffPersonDiffPresents (objid)
  local player = PlayerHelper.getPlayer(objid)
  for k, v in pairs(MyPlayerHelper.presents) do
    if (objid == k) then
      for i, itemInfo in ipairs(v.items) do
        BackpackHelper.addItem(objid, itemInfo[1], itemInfo[2])
      end
      local msgMap = v.msgMap
      msgMap.name = player:getName()
      ChatHelper.sendTemplateMsg(MyTemplate.PRESENT_MSG, msgMap, objid)
      break
    end
  end
end

-- 事件

-- 玩家进入游戏
EventHelper.addEvent('playerEnterGame', function (objid)
  MyStoryHelper.init()
  local story = MyStoryHelper.getStory()
  -- PlayerHelper.setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, false) -- 不可被攻击
  -- BackpackHelper.setGridItem(objid, 1007, MyMap.ITEM.JUMP, 1) -- 跳跃键
  -- PlayerHelper.setItemDisableThrow(objid, MyMap.ITEM.JUMP) -- 不可丢弃
  MyPlayerHelper.diffPersonDiffPresents(objid)
  story:enter(objid)
  -- 播放背景音乐
  MusicHelper.startBGM(objid, 1, true)
end)

-- 玩家离开游戏
EventHelper.addEvent('playerLeaveGame', function (objid)
  MusicHelper.stopBGM(objid)
end)

-- 玩家进入区域
EventHelper.addEvent('playerEnterArea', function (objid, areaid)
  local player = PlayerHelper.getPlayer(objid)
  local story = MyStoryHelper.getStory()
  if (story:isPassArea(areaid)) then -- 过关区域
    local num = BackpackHelper.getItemNumAndGrid2(objid, MyMap.ITEM.KEY)
    if (num > 0) then
      if (BackpackHelper.removeGridItemByItemID(objid, MyMap.ITEM.KEY, 1)) then
        local nextStory = MyStoryHelper.next()
        if (nextStory) then
          PlayerHelper.everyPlayerDoSomeThing(function (player)
            nextStory:enter(player.objid)
          end)
        else
          PlayerHelper.setGameWin(objid)
        end
      else
        ChatHelper.sendMsg(objid, '缺少城堡钥匙，无法进入城堡')
      end
    else
      ChatHelper.sendMsg(objid, '缺少城堡钥匙，无法进入城堡')
    end
  elseif (areaid == story.leaveArea) then -- 进入离开地下区域
    PlayerHelper.everyPlayerDoSomeThing(function (p)
      p:goOutPipe()
    end)
  elseif (story:isHideBlockArea(areaid)) then -- 进入第一关隐藏方块区域
    local pos = player:getMyPosition(true)
    LogHelper.info('进入隐藏区域：', pos.y - player.y)
    if (pos.y - player.y > 0) then -- 在上升中
      local dimension = PlayerHelper.getDimension(objid)
      local height = ActorHelper.getEyeHeight(objid) * dimension
      LogHelper.info('height: ', pos.y + height)
      if (AreaHelper.posInArea(MyPosition:new(pos.x, pos.y + height, pos.z), areaid)) then
        AreaHelper.fillBlock(areaid, MyMap.BLOCK.LUCKY) -- 填充幸运方块
        player:headHitBlock(true)
      end
    end
  end
end)

-- 玩家获得道具
EventHelper.addEvent('playerAddItem', function (objid, itemid, itemnum)
  local player = PlayerHelper.getPlayer(objid)
  if (itemid == MyMap.ITEM.BOTTLE) then -- 续命药瓶
    if (player:isHostPlayer()) then
      BackpackHelper.removeGridItemByItemID(objid, itemid, itemnum)
      if (player.isWatchStyle) then -- 观战模式
        BackpackHelper.addItem(objid, MyMap.ITEM.PILL, itemnum * 5 - 1)
        ActorHelper.addBuff(objid, MyMap.BUFF.CONTINUE, 1, 60)
        player.isWatchStyle = false
        local pos = player.revivePoint
        player:setMyPosition(pos.x, pos.y, pos.z) -- 重回复活点
      else
        BackpackHelper.addItem(objid, MyMap.ITEM.PILL, itemnum * 5) -- 五倍
      end
    end
  elseif (itemid == MyMap.ITEM.COIN) then -- 幸运币
    -- 一个加2分
    local teamid = PlayerHelper.getTeam(objid)
    TeamHelper.addTeamScore(teamid, itemnum * 2)
    player.coinNum = player.coinNum + 1
    -- 64枚金币换一颗续命药丸
    local num = BackpackHelper.getItemNumAndGrid(objid, itemid)
    if (num >= 64) then
      if (BackpackHelper.removeGridItemByItemID(objid, itemid, 64)) then
        BackpackHelper.addItem(objid, MyMap.ITEM.PILL, 1)
      end
    end
  end
end)

-- 玩家死亡
EventHelper.addEvent('playerDie', function (objid, toobjid)
  local player = PlayerHelper.getPlayer(objid)
  player.notDead = false
  PlayerHelper.setDimension(objid, 1) -- 尺寸恢复1
  -- 设置重生位置
  local story = MyStoryHelper.getStory()
  local pos = player:getMyPosition()
  local x, y, z = story.initPos.x
  if (player.isUnderground) then -- 地下
    y, z = 7.5, 0.5
  else
    y, z = story.initPos.y, math.ceil(pos.z / 100) * 100 + 0.5
  end
  player.revivePoint = MyPosition:new(x, y, z)
  PlayerHelper.setRevivePoint(objid, x, y, z)
  -- 移除一朵花
  BackpackHelper.removeGridItemByItemID(objid, MyMap.ITEM.FLOWER, 1)
end)

-- 玩家复活
EventHelper.addEvent('playerRevive', function (objid, toobjid)
  local player = PlayerHelper.getPlayer(objid)
  player.notDead = true
  if (player:isHostPlayer()) then -- 房主
    local pillNum = BackpackHelper.getItemNumAndGrid2(objid, MyMap.ITEM.PILL)
    if (pillNum > 0) then -- 还有续命药丸
      BackpackHelper.removeGridItemByItemID(objid, MyMap.ITEM.PILL, 1)
    else -- 没有续命药丸了
      player.isWatchStyle = true
      local pos = player.revivePoint
      player:setMyPosition(pos.x - 2, pos.y, pos.z)
      ChatHelper.sendMsg(objid, '生命耗尽，可在商店购买续命药瓶')
    end
  else
    player.isWatchStyle = true
    local pos = player.revivePoint
    player:setMyPosition(pos.x - 2, pos.y, pos.z)
  end
  ActorHelper.setFaceYaw(objid, 0)
end)

-- 玩家选择快捷栏
EventHelper.addEvent('playerSelectShortcut', function (objid, toobjid, itemid, itemnum)
  -- local player = PlayerHelper.getPlayer(objid)
  -- if (itemid == MyMap.ITEM.JUMP) then -- 跳跃键
  --   if (not(ActorHelper.isInAir(objid, player.x, player.y, player.z))) then
  --     ActorHelper.appendSpeed(objid, 0, 1, 0)
  --   end
  -- end
end)

-- 玩家运动状态改变
EventHelper.addEvent('playerMotionStateChange', function (objid, playermotion)
  local player = PlayerHelper.getPlayer(objid)
  local story = MyStoryHelper.getStory()
  if (playermotion == PLAYERMOTION.STATIC) then -- 静止
    if (story) then
      TimeHelper.callFnCanRun(function ()
        local pos = player:getMyPosition()
        local x = story.initPos.x
        if (player.isWatchStyle) then -- 在观战
          x = x - 2
        end
        local yaw = ActorHelper.getFaceYaw(objid)
        local pitch = ActorHelper.getFacePitch(objid)
        PlayerHelper.setPosition(objid, x, pos.y, pos.z)
        ActorHelper.setFaceYaw(objid, yaw)
        ActorHelper.setFacePitch(objid, pitch)
      end, 1, objid .. 'STATIC')
      LogHelper.info('adjust')
    end
  -- elseif (playermotion == PLAYERMOTION.JUMP) then -- 跳跃
    -- ActorHelper.appendSpeed(objid, 0, 0.6, 0)
  -- elseif (playermotion == PLAYERMOTION.WALK) then -- 行走
    -- player.isRunning = false
  -- elseif (playermotion == PLAYERMOTION.FALL_GROUND) then -- 落地
    -- LogHelper.info('落地')
  elseif (playermotion == PLAYERMOTION.SNEAK) then -- 潜行
    local pos = player:getMyPosition()
    if (AreaHelper.posInArea(pos, story.enterArea)) then
      player:setPosition(story.enterPos.x, story.enterPos.y - 0.5, story.enterPos.z)
      TimeHelper.callFnFastRuns(function ()
        player:setPosition(story.enterPos.x, story.enterPos.y - 0.7, story.enterPos.z) -- 下水管
        TimeHelper.callFnFastRuns(function ()
          PlayerHelper.everyPlayerDoSomeThing(function (p)
            p:enterPipe()
          end)
        end, 0.5)
      end, 0.5)
    end
  end
end)

-- 属性变化
EventHelper.addEvent('playerChangeAttr', function (objid, playerattr)
  local player = PlayerHelper.getPlayer(objid)
  if (playerattr == CREATUREATTR.CUR_OXYGEN) then -- 氧气值
    local oxygen = PlayerHelper.getOxygen(objid)
    if (oxygen == 0) then
      player:killSelf()
    elseif (oxygen == 4 and player.prevOxygen > 4) then
      ChatHelper.sendMsg(objid, '你感觉需要换口气了')
    end
    player.prevOxygen = oxygen
  end
end)
