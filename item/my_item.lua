-- 我的道具类

-- 时间补给
TimeSupply = BaseItem:new({ id = MyMap.ITEM.TIME_SUPPLY })

function TimeSupply:useItem (objid)
  if (BackpackHelper:removeGridItemByItemID(objid, self.id, 1)) then
    local time = TimerHelper:getTimerTime(MyGameHelper.timerid)
    TimerHelper:changeTimerTime(MyGameHelper.timerid, time + 100)
    local player = PlayerHelper:getPlayer(objid)
    ChatHelper:sendMsg(nil, '#G', player:getName(), '#n使用了',
      ItemHelper:getItemName(self.id), '，时间额外增加了100秒')
  end
end