-- 我的游戏工具类
MyGameHelper = {
  defaultWalkSpeed = 10, -- 初始速度
  onceAppendWalkSpeed = 1, -- 一次增加速度
  maxWalkSpeed = 40 -- 最大增加速度
}

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
  -- 同向加速
  for i, v in ipairs(PlayerHelper:getAllPlayers()) do
    if (v:isActive()) then
      local dir = ActorHelper:getCurPlaceDir(v.objid)
      local x, y, z = ActorHelper:getPosition(v.objid)
      if (v.z) then
        v.speed = math.abs(z - v.z)
      end
      if (v.speed > 0.15) then -- 在移动
        if (dir == v.dir) then -- 同向
          if (v.walkSpeed < self.maxWalkSpeed) then
            v.walkSpeed = v.walkSpeed + self.onceAppendWalkSpeed
          end
        else -- 反向
          v.walkSpeed = self.defaultWalkSpeed
        end
      else
        v.walkSpeed = self.defaultWalkSpeed
      end
      PlayerHelper:setWalkSpeed(v.objid, v.walkSpeed)
      v.dir = dir
      v.x, v.y, v.z = x, y, z
      -- LogHelper:debug(v.dir, '-', v.walkSpeed)
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
