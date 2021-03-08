-- 我的背包工具类
MyBackpackHelper = {}

--[[--
EventHelper.addEvent('playerClickBlock', function (objid)
  local t1 = os.time()
  local tt1 = TimeHelper.getFrame()
  local a = 1
  for i = 1, 100000 do
    CacheHelper.getMyPosition(objid)
  end
  local t2 = os.time()
  local tt2 = TimeHelper.getFrame()
  ChatHelper.sendMsg(objid, a)
  ChatHelper.sendMsg(objid, t2 - t1, '-', tt2 - tt1)
end)
--]]--