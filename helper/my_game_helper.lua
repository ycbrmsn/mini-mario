-- 我的游戏工具类
MyGameHelper = {
  index = 0, -- 帧序数
  timerid = nil, -- 房主计时器
  totalCheckPoint = 1, -- 总关卡数
}

-- 判断是否因为位置过低需要死去
function MyGameHelper.judgeDeath (player, y)
  if (player.notDead) then
    if ((y > 40 and y < 52) or (y < 0)) then
      player.notDead = false
      ActorHelper.killSelf(player.objid)
      return true
    end
  end
  return false
end

-- 同向加速
function MyGameHelper.fasterTheSameDir (player, z, isMainPlayer)
  local dir = ActorHelper.getCurPlaceDir(player.objid)
  if (player.z) then
    player.zSpeed = math.abs(z - player.z)
    -- LogHelper.debug(player.zSpeed)
  end
  if (player.ableMove) then -- 可移动
    -- 移动速度
    if (isMainPlayer and player.zSpeed > 0.15) then -- 在移动
      if (dir == player.dir) then -- 同向
        if (player.walkSpeed < player.maxWalkSpeed) then
          player.walkSpeed = player.walkSpeed + player.onceAppendSpeed
        end
      else -- 反向
        player.walkSpeed = player.defaultWalkSpeed
      end
    else
      player.walkSpeed = player.defaultWalkSpeed
    end
    -- 游泳速度
    if (isMainPlayer and player.zSpeed > 0.02) then
      if (dir == player.dir) then -- 同向
        if (player.swimSpeed < player.maxSwimSpeed) then
          player.swimSpeed = player.swimSpeed + player.onceAppendSpeed
        end
      else -- 反向
        player.swimSpeed = player.defaultSwimSpeed
      end
    else
      player.swimSpeed = player.defaultSwimSpeed
    end
  else -- 不可移动
    player.walkSpeed = 0
    player.swimSpeed = 0
  end
  if (player.zSpeed > 0) then -- 取消持续跳跃
    player.isKeepJumping = false
  end
  PlayerHelper.setWalkSpeed(player.objid, player.walkSpeed)
  PlayerHelper.setSwimSpeed(player.objid, player.swimSpeed)
  player.dir = dir
end

-- 头顶到方块
function MyGameHelper.headHitBlock (player, x, y, z, isMainPlayer)
  local ySpeed = y - player.y
  if (ySpeed == 0) then -- 突然变为0
    if (player.ySpeed > 0 and ActorHelper.isInAir(player.objid)) then -- 处于上升状态且在空气中
      if (isMainPlayer) then
        player:headHitBlock()
      else
        -- 联网玩家还需要判断头上方是否有方块
        local dimension = PlayerHelper.getDimension(player.objid)
        local height = (ActorHelper.getEyeHeight(player.objid) + 0.6) * dimension
        if (not(BlockHelper.isAirBlock(x, y + height, z))) then
          player:headHitBlock()
        end
      end
    end
  end
  -- 踩方块
  if (player.ySpeed >= 0 and ySpeed < 0) then -- 开始下落
    player.fallHeight = player.y
  elseif (ySpeed >= 0 and player.ySpeed < 0) then -- 停止下落
    -- player.fallHeight = player.fallHeight - y
    if (player.fallHeight - y >= 3) then -- 3格高度则踩碎方块
      player:trampleBlock()
    end
    LogHelper.debug('停止下落', player.fallHeight - y)
    -- 落地之后清除高度。因高度原因，与碰撞生物事件先后执行情况不确定，这里便简单延迟置到下一帧0
    TimeHelper.callFnFastRuns(function ()
      player.fallHeight = 0
    end, 0.05)
  end
  -- 持续跳跃
  if (ySpeed == 0 and player.ySpeed <= 0 and player.isKeepJumping) then -- 不是上升状态后竖直静止
    ActorActionHelper.playJump(player.objid)
    ActorHelper.appendSpeed(player.objid, 0, 0.9, 0)
  end
  player.ySpeed = ySpeed
end

function MyGameHelper.setGBattleUI ()
  local player = PlayerHelper.getHostPlayer()
  if (player) then
    TimerHelper.pauseTimer(MyGameHelper.timerid)
    local teamid = PlayerHelper.getTeam(player.objid)
    local teamScore = TeamHelper.getTeamScore(teamid)
    local time = TimerHelper.getTimerTime(MyGameHelper.timerid)
    local result = PlayerHelper.getGameResults(player.objid)
    local score = math.floor(time / 3) + teamScore -- 剩余时间 + 金币得分
    if (score < teamScore or result == 2) then
      score = teamScore
    end
    local msg
    if (result and result == 1) then
      msg = '成功抵达了终点，得分：'
    else
      msg = '在中途被淘汰，得分：'
    end
    UIHelper.setGBattleUI('left_desc', player:getName() .. msg .. score)
    UIHelper.setGBattleUI('left_little_desc', '获得金币数：' .. player.coinNum)
    UIHelper.setGBattleUI('right_little_desc', '剩余时间：' .. time)
  end
  UIHelper.setGBattleUI('result', false)
end

-- 事件

-- 开始游戏
EventHelper.addEvent('startGame', function ()
  -- 游戏开始计时
  MyGameHelper.timerid = TimerHelper.getTimer(timername)
  TimerHelper.startBackwardTimer(MyGameHelper.timerid, MyStoryHelper.getStory().backwardTimer)
end)

-- 游戏运行时
EventHelper.addEvent('runGame', function ()
  for i, player in ipairs(PlayerHelper.getActivePlayers()) do
    local x, y, z = CacheHelper.getPosition(player.objid)
    if (x) then
      if (not(MyGameHelper.judgeDeath(player, y))) then -- 玩家没有位置过低死亡
        -- LogHelper.debug(z)
        -- local isMainPlayer = PlayerHelper.isMainPlayer(player.objid)
        if (player:isHostPlayer()) then
          MyGameHelper.fasterTheSameDir(player, z, true) -- 同向加速
          MyGameHelper.headHitBlock(player, x, y, z, true)
          player.x, player.y, player.z = x, y, z
        end
        -- LogHelper.debug(player.y)
      end
      -- if (MyGameHelper.index % 20 == 0) then
      --   if (math.abs(v.sz - z) > 2) then
      --     v.isRunning = true
      --   else
      --     v.isRunning = false
      --   end
      --   v.sz = z
      -- end
    end
  end
end)

-- 结束游戏
EventHelper.addEvent('endGame', function ()
  MyGameHelper.setGBattleUI()
end)

-- 任意计时器发生变化
EventHelper.addEvent('minitimerChange', function ()
  local hostPlayer = PlayerHelper.getHostPlayer()
  local color = ''
  local time = TimerHelper.getTimerTime(MyGameHelper.timerid)
  if (time > 0 and time <= 60) then
    color = '#R'
    PlayerHelper.everyPlayerDoSomeThing(function (player)
      local musicIndex = MusicHelper.getMusicIndex(player.objid)
      if (musicIndex ~= 5) then
        MusicHelper.changeBGM(player.objid, 5, true)
      end
    end)
  elseif (time == 0) then -- 时间耗尽
    color = '#R'
    GameHelper.doGameEnd()
  else -- 正常
    PlayerHelper.everyPlayerDoSomeThing(function (player)
      local musicIndex = MusicHelper.getMusicIndex(player.objid)
      if (musicIndex ~= 1 and not(hostPlayer.isUnderground)) then -- 在地上
        MusicHelper.changeBGM(player.objid, 1, true)
      elseif (musicIndex ~= 2 and hostPlayer.isUnderground) then -- 在地底
        MusicHelper.changeBGM(player.objid, 2, true)
      end
    end)
  end
  if (MyGameHelper.timerid) then
    for i, v in ipairs(PlayerHelper.getActivePlayers()) do
      TimerHelper.showTips({ v.objid }, MyGameHelper.timerid, color)
    end
  end
  MyItemHelper.findPipe()
end)