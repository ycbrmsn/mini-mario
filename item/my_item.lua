-- 我的道具类

-- 时间补给
TimeSupply = BaseItem:new({ 
  id = MyMap.ITEM.TIME_SUPPLY,
  addTime = 180, -- 增加时间
})

function TimeSupply:useItem (objid)
  if (BackpackHelper:removeGridItemByItemID(objid, self.id, 1)) then
    local time = TimerHelper:getTimerTime(MyGameHelper.timerid)
    TimerHelper:changeTimerTime(MyGameHelper.timerid, time + self.addTime)
    local player = PlayerHelper:getPlayer(objid)
    ChatHelper:sendMsg(nil, '#G', player:getName(), '#n使用了',
      ItemHelper:getItemName(self.id), '，时间额外增加了', self.addTime, '秒')
  end
end

-- 关卡通行证
Permit = BaseItem:new( { id = MyMap.ITEM.PERMIT })

function Permit:ableUse (objid)
  local index = PlayerHelper:getCurShotcut(objid)
  if (index) then
    index = index + 1
    if (index < MyStoryHelper.index) then
      ChatHelper:sendMsg(objid, '无法跳过已经经过的关卡')
      return false
    elseif (index == #StoryHelper:getStorys()) then
      ChatHelper:sendMsg(objid, '目前第', index, '关已经是最后一个关卡')
      return false
    elseif (index > #StoryHelper:getStorys()) then
      ChatHelper:sendMsg(objid, '目前第', index + 1, '关正在建设中')
      return false
    else
      return true, index + 1
    end
  else
    ChatHelper:sendMsg(objid, '游戏发生错误，道具使用失败')
    return false
  end
end

function Permit:useItem (objid)
  if (PlayerHelper:isMainPlayer(objid)) then
    local ableUse, index = self:ableUse(objid)
    if (ableUse) then
      if (BackpackHelper:removeGridItemByItemID(objid, self.id, 1)) then
        MyStoryHelper.index = index
        local story = MyStoryHelper:getStory()
        PlayerHelper:everyPlayerDoSomeThing(function (player)
          story:enter(player.objid)
        end)
        local player = PlayerHelper:getPlayer(objid)
        local name = ItemHelper:getItemName(self.id)
        ChatHelper:sendMsg(nil, '#B', player:getName(), '#n使用了#G', name, '#n，直接来到了第',
          index, '关')
      else
        ChatHelper:sendMsg(objid, '游戏发生错误，道具销毁失败')
      end
    end
  else
    ChatHelper:sendMsg(objid, '该道具仅房主使用有效')
  end
end

function Permit:selectItem (objid)
  if (PlayerHelper:isMainPlayer(objid)) then
    local ableUse, index = self:ableUse(objid)
    if (ableUse) then
      ChatHelper:sendMsg(nil, '使用后可直接去往第', index, '关')
    end
  else
    ChatHelper:sendMsg(objid, '该道具仅房主使用有效')
  end
end

-- 连续跳跃
KeepJump = BaseItem:new( { id = MyMap.ITEM.JUMP })

function KeepJump:selectItem (objid)
  local player = PlayerHelper:getPlayer(objid)
  player.isKeepJumping = true
end