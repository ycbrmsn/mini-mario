-- 我的游戏工具类
MyGameHelper = {
  defaultWalkSpeed = 10, -- 初始速度
  onceAppendWalkSpeed = 1, -- 一次增加速度
  maxWalkSpeed = 40, -- 最大增加速度
  gravity = 0.005, -- 每秒追加重力
}

-- 判断是否因为位置过低需要死去
function MyGameHelper:judgeDeath (player, y)
  if (y < 4 and player.notDead) then
    ActorHelper:killSelf(player.objid)
    player.notDead = false
    return true
  end
  return false
end

-- 同向加速
function MyGameHelper:fasterTheSameDir (player, z)
  local dir = ActorHelper:getCurPlaceDir(player.objid)
  if (player.z) then
    player.zSpeed = math.abs(z - player.z)
  end
  if (player.zSpeed > 0.15) then -- 在移动
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
function MyGameHelper:headHitBlock (player, y)
  local ySpeed = y - player.y
  if (ySpeed == 0) then -- 突然变为0
    if (player.ySpeed > 0) then -- 处于上升状态
      player:headHitBlock()
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

-- 事件

-- 开始游戏
function MyGameHelper:startGame ()
  GameHelper:startGame()
  MyBlockHelper:init()
  MyActorHelper:init()
  MyMonsterHelper:init()
  MyAreaHelper:init()
end

-- 游戏运行时
function MyGameHelper:runGame ()
  GameHelper:runGame()
  -- body
  for i, v in ipairs(PlayerHelper:getAllPlayers()) do
    if (v:isActive()) then
      ActorHelper:appendSpeed(objid, 0, -self.gravity, 0) -- 添加重力
      local x, y, z = ActorHelper:getPosition(v.objid)
      if (x) then
        if (not(MyGameHelper:judgeDeath(v, y))) then -- 玩家没有位置过低死亡
          MyGameHelper:fasterTheSameDir(v, z) -- 同向加速
          MyGameHelper:headHitBlock(v, y)
          v.x, v.y, v.z = x, y, z
          -- LogHelper:debug(v.y)
        end
      end
    end
  end
end

-- 结束游戏
function MyGameHelper:endGame ()
  GameHelper:endGame()
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
end