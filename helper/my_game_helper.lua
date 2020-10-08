-- 我的游戏工具类
MyGameHelper = {
  defaultWalkSpeed = 10, -- 初始速度
  onceAppendWalkSpeed = 1, -- 一次增加速度
  maxWalkSpeed = 40, -- 最大增加速度
  index = 0, -- 帧序数
  timerid = nil, -- 房主计时器
  totalCheckPoint = 1, -- 总关卡数
}

-- 判断是否因为位置过低需要死去
function MyGameHelper:judgeDeath (player, y)
  if ((y > 40 and y < 52) or (y < 0) and player.notDead) then
    ActorHelper:killSelf(player.objid)
    player.notDead = false
    return true
  end
  return false
end

-- 同向加速
function MyGameHelper:fasterTheSameDir (player, z, isMainPlayer)
  local dir = ActorHelper:getCurPlaceDir(player.objid)
  if (player.z) then
    player.zSpeed = math.abs(z - player.z)
  end
  if ((isMainPlayer and player.zSpeed > 0.15) or 
    (not(isMainPlayer) and (player.zSpeed > 0.15 or player.isRunning))) then -- 在移动
    if (dir == player.dir) then -- 同向
      if (player.walkSpeed < self.maxWalkSpeed) then
        player.walkSpeed = player.walkSpeed + self.onceAppendWalkSpeed
      end
    else -- 反向
      player.walkSpeed = self.defaultWalkSpeed
    end
  else
    player.walkSpeed = self.defaultWalkSpeed
  end
  PlayerHelper:setWalkSpeed(player.objid, player.walkSpeed)
  player.dir = dir
end

-- 头顶到方块
function MyGameHelper:headHitBlock (player, x, y, z, isMainPlayer)
  local ySpeed = y - player.y
  if (ySpeed == 0) then -- 突然变为0
    if (player.ySpeed > 0) then -- 处于上升状态
      if (isMainPlayer) then
        player:headHitBlock()
      else
        -- 联网玩家还需要判断头上方是否有方块
        local dimension = PlayerHelper:getDimension(player.objid)
        local height = (ActorHelper:getEyeHeight(player.objid) + 0.6) * dimension
        if (not(BlockHelper:isAirBlock(x, y + height, z))) then
          player:headHitBlock()
        end
      end
    end
  end
  if (player.ySpeed >= 0 and ySpeed < 0) then -- 开始下落
    player.fallHeight = player.y
  elseif (ySpeed >= 0 and player.ySpeed < 0) then -- 停止下落
    player.fallHeight = player.fallHeight - y
    if (player.fallHeight >= 4) then -- 四格高度则踩碎方块
      player:trampleBlock()
    end
  end
  player.ySpeed = ySpeed
end

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    TimerHelper:pauseTimer(self.timerid)
    local teamid = PlayerHelper:getTeam(player.objid)
    local teamScore = TeamHelper:getTeamScore(teamid)
    local time = TimerHelper:getTimerTime(self.timerid)
    local result = PlayerHelper:getGameResults(player.objid)
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
    UIHelper:setGBattleUI('left_desc', player:getName() .. msg .. score)
    UIHelper:setGBattleUI('left_little_desc', '获得金币数：' .. teamScore / 5)
    UIHelper:setGBattleUI('right_little_desc', '剩余时间：' .. time)
  end
  UIHelper:setGBattleUI('result', false)
end

-- 事件

-- 开始游戏
function MyGameHelper:startGame ()
  LogHelper:debug('开始游戏')
  GameHelper:startGame()
  MyBlockHelper:init()
  MyActorHelper:init()
  MyMonsterHelper:init()
  MyAreaHelper:init()
  MyStoryHelper:init()
  -- body
  -- 游戏开始计时
  MyGameHelper.timerid = TimerHelper:getTimer(timername)
  TimerHelper:startBackwardTimer(MyGameHelper.timerid, MyStoryHelper:getStory().backwardTimer)
end

-- 游戏运行时
function MyGameHelper:runGame ()
  GameHelper:runGame()
  self.index = self.index + 1
  -- body
  for i, v in ipairs(PlayerHelper:getActivePlayers()) do
    local x, y, z = ActorHelper:getPosition(v.objid)
    if (x) then
      if (not(MyGameHelper:judgeDeath(v, y))) then -- 玩家没有位置过低死亡
        -- LogHelper:debug(z)
        local isMainPlayer = PlayerHelper:isMainPlayer(v.objid)
        MyGameHelper:fasterTheSameDir(v, z, isMainPlayer) -- 同向加速
        MyGameHelper:headHitBlock(v, x, y, z, isMainPlayer)
        v.x, v.y, v.z = x, y, z
        -- LogHelper:debug(v.y)
      end
      if (self.index % 20 == 0) then
        if (math.abs(v.sz - z) > 2) then
          v.isRunning = true
        else
          v.isRunning = false
        end
        v.sz = z
      end
    end
  end
end

-- 结束游戏
function MyGameHelper:endGame ()
  GameHelper:endGame()
  -- body
  MyGameHelper:setGBattleUI()
end

-- 世界时间到[n]点
function MyGameHelper:atHour (hour)
  GameHelper:atHour(hour)
end

-- 世界时间到[n]秒
function MyGameHelper:atSecond (second)
  GameHelper:atSecond(second)
end

-- 任意计时器发生变化
function MyGameHelper:minitimerChange (timerid, timername)
  GameHelper:minitimerChange(timerid, timername)
  -- body
  local hostPlayer = PlayerHelper:getHostPlayer()
  local color = ''
  local time = TimerHelper:getTimerTime(self.timerid)
  if (time > 0 and time <= 60) then
    color = '#R'
    PlayerHelper:everyPlayerDoSomeThing(function (player)
      local musicIndex = MusicHelper:getMusicIndex(player.objid)
      if (musicIndex ~= 5) then
        MusicHelper:changeBGM(player.objid, 5, true)
      end
    end)
  elseif (time == 0) then -- 时间耗尽
    color = '#R'
    GameHelper:doGameEnd()
  else -- 正常
    PlayerHelper:everyPlayerDoSomeThing(function (player)
      local musicIndex = MusicHelper:getMusicIndex(player.objid)
      if (musicIndex ~= 1 and not(hostPlayer.isUnderground)) then -- 在地上
        MusicHelper:changeBGM(player.objid, 1, true)
      elseif (musicIndex ~= 2 and hostPlayer.isUnderground) then -- 在地底
        MusicHelper:changeBGM(player.objid, 2, true)
      end
    end)
  end
  if (self.timerid) then
    for i, v in ipairs(PlayerHelper:getActivePlayers()) do
      TimerHelper:showTips({ v.objid }, self.timerid, color)
    end
  end
end