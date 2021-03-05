-- 我的道具工具类
MyItemHelper = {
  pipeMap = {}
}

-- 发现水管
function MyItemHelper.findPipe ()
  local isFind = false
  local story = MyStoryHelper.getStory()
  for i, player in ipairs(PlayerHelper.getActivePlayers()) do
    local itemid = PlayerHelper.getCurToolID(player.objid)
    if (itemid and itemid == MyMap.ITEM.DETECTOR) then -- 手持探测器
      local pos = player:getMyPosition()
      if (story.enterPos and pos) then -- 进入水管位置
        local distance = MathHelper.getDistance(story.enterPos, pos)
        if (distance < 20) then
          isFind = true
          break
        end
      end
    end
  end
  if (isFind) then
    if (not(MyItemHelper.pipeMap[MyStoryHelper.index])) then
      local pos = MyPosition:new(story.enterPos.x, story.enterPos.y - 1, story.enterPos.z)
      WorldHelper.playBodyEffect(pos, BaseConstant.BODY_EFFECT.PROMPT17)
      MyItemHelper.pipeMap[MyStoryHelper.index] = true
    end
  else
    if (MyItemHelper.pipeMap[MyStoryHelper.index]) then
      local pos = MyPosition:new(story.enterPos.x, story.enterPos.y - 1, story.enterPos.z)
      WorldHelper.stopBodyEffect(pos, BaseConstant.BODY_EFFECT.PROMPT17)
      MyItemHelper.pipeMap[MyStoryHelper.index] = false
    end
  end
  return isFind
end

-- 事件

-- 投掷物命中
function MyItemHelper.projectileHit (projectileid, toobjid, blockid, x, y, z)
  ItemHelper.projectileHit(projectileid, toobjid, blockid, x, y, z)
  -- body
  if (not(ActorHelper.isPlayer(toobjid))) then -- 不是玩家
    local actorid = CreatureHelper.getActorID(toobjid)
    if (actorid) then
      if (actorid == 3400 or actorid == 3407) then -- 鸡、狼
        local itemid = ItemHelper.getMissileItemid(projectileid)
        if (itemid and itemid == MyMap.ITEM.FLY_FLOOR) then
          local player = PlayerHelper.getHostPlayer()
          player:knockCreature(toobjid)
        end
      end
    end
  end
end

-- 投掷物被创建
function MyItemHelper.missileCreate (objid, toobjid, itemid, x, y, z)
  ItemHelper.missileCreate(objid, toobjid, itemid, x, y, z)
end