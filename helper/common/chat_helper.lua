-- 聊天工具类
ChatHelper = {}

-- 发送模板消息
function ChatHelper:sendTemplateMsg (template, map, objid)
  local msg = StringHelper:getTemplateResult(template, map)
  ChatHelper:sendSystemMsg(msg, objid)
end

-- 发送消息
function ChatHelper:sendMsg (objid, ...)
  ChatHelper:sendSystemMsg(StringHelper:concat(...), objid)
end

-- 封装原始接口

-- 发送系统消息，默认发送给所有玩家
function ChatHelper:sendSystemMsg (content, targetuin)
  targetuin = targetuin or 0
  return CommonHelper:callIsSuccessMethod(function (p)
    return Chat:sendSystemMsg(content, targetuin)
  end, '发送系统消息')
end

-- UI工具类
UIHelper = {}

-- 封装原水接口

-- 世界坐标转换到小地图
function UIHelper:world2RadarPos (x, z)
  return CommonHelper:callTwoResultMethod(function (p)
    return UI:world2RadarPos(x, z)
  end, '世界坐标转换到小地图', 'x=', x, ',z=', z)
end

-- 世界长度转换到小地图
function UIHelper:world2RadarDist (length)
  return CommonHelper:callOneResultMethod(function (p)
    return UI:world2RadarDist(length)
  end, '世界长度转换到小地图', 'length=', length)
end

-- 设置线条标记
function UIHelper:setShapeLine (uiname, p1x, p1y, p2x, p2y)
  return CommonHelper:callIsSuccessMethod(function (p)
    return UI:setShapeLine(uiname, p1x, p1y, p2x, p2y)
  end, '设置线条标记', 'uiname=', uiname, ',p1x=', p1x, ',p1y=', p1y, ',p2x=',
    p2x, ',p2y=', p2y)
end

-- 设置圆形标记
function UIHelper:setShapeCircle (uiname, x, y, radius)
  return CommonHelper:callIsSuccessMethod(function (p)
    return UI:setShapeCircle(uiname, x, y, radius)
  end, '设置圆形标记', 'uiname=', uiname, ',x=', x, ',y=', y, ',radius=', radius)
end