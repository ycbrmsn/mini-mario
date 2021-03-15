-- 我的背包工具类
MyBackpackHelper = {}

--[[--
EventHelper.addEvent('playerClickBlock', function (objid)
  local t1 = os.time()
  local tt1 = TimeHelper.getFrame()
  -- local a = 1
  for i = 1, 10 do
    -- CacheHelper.getMyPosition(objid)
    PlayerHelper.playMusic(objid, 10774, 100, 1)
    TimeHelper.callFnAfterSecond (function ()
      PlayerHelper.playMusic(objid, 10773, 100, 2)
    end, 1)
  end
  local t2 = os.time()
  local tt2 = TimeHelper.getFrame()
  -- ChatHelper.sendMsg(objid, a)
  ChatHelper.sendMsg(objid, t2 - t1, '-', tt2 - tt1)

  -- local dimension = PlayerHelper.getDimension(objid)
  -- LogHelper.info('dimension: ', dimension)
  -- local height = (ActorHelper.getEyeHeight(objid) + 0.6) * dimension
  -- LogHelper.info('eye: ', ActorHelper.getEyeHeight(objid))
  -- LogHelper.info('height: ', height)


end)
--]]--