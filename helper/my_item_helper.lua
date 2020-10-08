-- 我的道具工具类
MyItemHelper = {
  pipeMap = {}
}

-- 发现水管
function MyItemHelper:findPipe ()
  local isFind = false
  local story = MyStoryHelper:getStory()
  for i, player in ipairs(PlayerHelper:getActivePlayers()) do
    local itemid = PlayerHelper:getCurToolID(player.objid)
    if (itemid and itemid == MyMap.ITEM.DETECTOR) then -- 手持探测器
      local pos = player:getMyPosition()
      if (story.enterPos and pos) then -- 进入水管位置
        local distance = MathHelper:getDistance(story.enterPos, pos)
        if (distance < 20) then
          isFind = true
          break
        end
      end
    end
  end
  if (isFind) then
    if (not(self.pipeMap[MyStoryHelper.index])) then
      local pos = MyPosition:new(story.enterPos.x, story.enterPos.y - 1, story.enterPos.z)
      WorldHelper:playBodyEffect(pos, BaseConstant.BODY_EFFECT.PROMPT17)
      self.pipeMap[MyStoryHelper.index] = true
    end
  else
    if (self.pipeMap[MyStoryHelper.index]) then
      local pos = MyPosition:new(story.enterPos.x, story.enterPos.y - 1, story.enterPos.z)
      WorldHelper:stopBodyEffect(pos, BaseConstant.BODY_EFFECT.PROMPT17)
      self.pipeMap[MyStoryHelper.index] = false
    end
  end
  return isFind
end

-- 事件

-- 投掷物命中
function MyItemHelper:projectileHit (projectileid, toobjid, blockid, x, y, z)
  ItemHelper:projectileHit(projectileid, toobjid, blockid, x, y, z)
end

-- 投掷物被创建
function MyItemHelper:missileCreate (objid, toobjid, itemid, x, y, z)
  ItemHelper:missileCreate(objid, toobjid, itemid, x, y, z)
end