-- 我的游戏工具类
MyGameHelper = {}

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
  -- 每帧更新玩家朝向
  for i, v in ipairs(PlayerHelper:getAllPlayers()) do
    if (v:isActive()) then
      v.direction = ActorHelper:getCurPlaceDir(objid)
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
