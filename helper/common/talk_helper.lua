-- 对话工具类
TalkHelper = {
  prevTalkInfos = {}, -- { 玩家 -> 上次对话 } { playerid -> talkInfos }
  talkProgress = {}, -- { playerid -> { talkid -> talkProgress } }
}

-- 玩家当前会话
function TalkHelper.getPrevTalkInfo (playerid)
  return TalkHelper.prevTalkInfos[playerid]
end

-- 设置玩家当前会话
function TalkHelper.setPrevTalkInfo (playerid, talkInfo)
  TalkHelper.prevTalkInfos[playerid] = talkInfo
end

-- 获取会话进度
function TalkHelper.getProgress (playerid, talkid)
  if (not(TalkHelper.talkProgress[playerid])) then
    TalkHelper.talkProgress[playerid] = {}
  end
  if (not(TalkHelper.talkProgress[playerid][talkid])) then
    TalkHelper.talkProgress[playerid][talkid] = 1
  end
  return TalkHelper.talkProgress[playerid][talkid]
end

-- 设置会话进度
function TalkHelper.setProgress (playerid, talkid, talkProgress)
  local progress = TalkHelper.getProgress(playerid, talkid)
  if (progress ~= talkProgress) then
    TalkHelper.talkProgress[playerid][talkid] = talkProgress
  end
end

-- 返回会话信息
function TalkHelper.getTalkInfo (playerid, actor)
  local talkInfos = actor.talkInfos
  if (talkInfos and #talkInfos > 0) then
    for i, talkInfo in ipairs(talkInfos) do
      if (talkInfo:isMeet(playerid)) then -- 满足一项
        local prevTalkInfo = TalkHelper.getPrevTalkInfo(playerid)
        local talkIndex = TalkHelper.getTalkIndex(playerid, actor)
        if (prevTalkInfo and prevTalkInfo ~= talkInfo and talkIndex ~= 1) then -- 会话发生改变，如对话中丢弃了任务道具
          TalkHelper.resetTalkIndex(playerid, actor, index)
          TalkHelper.showBreakSeparate(playerid)
        end
        return talkInfo
      end
    end
  end
  return nil
end

-- NPC与玩家对话
function TalkHelper.talkWith (playerid, actor)
  if (not(actor)) then -- 没有选择过特定生物
    return
  end
  local sessions = TalkHelper.getSessions(playerid, actor)
  if (sessions) then -- 存在一段对话
    local index = TalkHelper.getTalkIndex(playerid, actor)
    local session = sessions[index]
    if (session) then -- 存在一条对话
      TalkHelper.handleTalkSession(playerid, actor, index, sessions)
    else -- 不存在，则默认对话
      if (actor.defaultTalkMsg) then
        actor:speakTo(playerid, 0, actor.defaultTalkMsg)
        TalkHelper.showEndSeparate(playerid)
      end
    end
  else -- 不存在，则默认对话
    if (actor.defaultTalkMsg) then
      actor:speakTo(playerid, 0, actor.defaultTalkMsg)
      TalkHelper.showEndSeparate(playerid)
    end
  end
end

-- 找到一段对话
function TalkHelper.getSessions (playerid, actor)
  local talkInfo = TalkHelper.getTalkInfo(playerid, actor)
  if (not(talkInfo)) then -- 没有会话
    return nil
  end
  local talkProgress = TalkHelper.getProgress(playerid, talkInfo.id)
  local sessions = talkInfo.progress[talkProgress]
  if (not(sessions)) then -- 没找到对应会话
    sessions = talkInfo.progress[0] -- 任意进度均此对话
    if (not(sessions)) then -- 任意进度对话也没有
      return nil
    end
  end
  return sessions
end

-- 获取对话序数
function TalkHelper.getTalkIndex (playerid, actor)
  local index = actor.talkIndex[playerid]
  if (not(index)) then
    index = 1
    actor.talkIndex[playerid] = index
  end
  return index
end

-- 对话序数跳转 默认跳一个
function TalkHelper.turnTalkIndex (playerid, actor, max, index)
  if (not(index)) then
    index = TalkHelper.getTalkIndex(playerid, actor) + 1
  end
  if (index > max or index == -1) then
    index = 1
    actor.talkIndex[playerid] = index
    TalkHelper.showEndSeparate(playerid)
    return false
  else
    actor.talkIndex[playerid] = index
    return true
  end
end

-- 重置序数
function TalkHelper.resetTalkIndex (playerid, actor, index)
  actor.talkIndex[playerid] = index or 1
end

-- 处理当前对话
function TalkHelper.handleTalkSession (playerid, actor, index, sessions)
  local player = PlayerHelper.getPlayer(playerid)
  local session = sessions[index]
  if (session.t == 1) then -- 生物说
    actor:speakTo(playerid, 0, session.msg)
    if (session.f) then
      session.f(player, actor)
    end
    TalkHelper.turnTalkIndex(playerid, actor, #sessions, session.turnTo)
  elseif (session.t == 2) then -- 生物想
    actor:thinkTo(playerid, 0, session.msg)
    if (session.f) then
      session.f(player, actor)
    end
    TalkHelper.turnTalkIndex(playerid, actor, #sessions, session.turnTo)
  elseif (type(session.msg) == 'table') then -- 选项
    ChatHelper.showChooseItems(playerid, session.msg, 'msg')
    player.whichChoose = 'talk'
    if (session.f) then
      session.f(player, actor)
    end
  else -- 玩家对话
    if (session.t == 3) then -- 玩家说
      player:speakSelf(0, session.msg)
    elseif (session.t == 4) then -- 玩家想
      player:thinkSelf(0, session.msg)
    end
    if (session.f) then
      session.f(player, actor)
    end
    TalkHelper.turnTalkIndex(playerid, actor, #sessions, session.turnTo)
  end
end

-- 选择对话
function TalkHelper.chooseTalk (playerid, actor)
  if (not(actor)) then -- 没有选择过特定生物
    return
  end
  local sessions = TalkHelper.getSessions(playerid, actor)
  if (not(sessions)) then
    return
  end
  local talkIndex = TalkHelper.getTalkIndex(playerid, actor)
  local session = sessions[talkIndex]
  if (not(session)) then 
    return
  elseif (type(session.msg) ~= 'table') then -- 当前不是选择项
    TalkHelper.talkWith(playerid, actor)
  else -- 选择项
    local index = PlayerHelper.getCurShotcut(playerid) + 1
    if (index > #session.msg) then -- 没有该选项
      return
    end
    -- 选择了
    local player = PlayerHelper.getPlayer(playerid)
    player.whichChoose = nil -- 去掉选择状态
    local playerTalk = session.msg[index]
    local max = #sessions
    if (playerTalk.f) then
      playerTalk.f(player, actor)
    end
    if (not(playerTalk.t) or playerTalk.t == 1) then -- 继续
      if (TalkHelper.turnTalkIndex(playerid, actor, max)) then
        TalkHelper.talkWith(playerid, actor)
      end
    elseif (playerTalk.t == 2) then -- 跳转
      if (TalkHelper.turnTalkIndex(playerid, actor, max, playerTalk.other)) then
        TalkHelper.talkWith(playerid, actor)
      end
    elseif (playerTalk.t == 3) then -- 终止
      TalkHelper.turnTalkIndex(playerid, actor, max, max + 1)
    elseif (playerTalk.t == 4) then -- 任务

    end
  end
end

-- 重置进度对话
function TalkHelper.resetProgressContent (actor, talkid, progressid, sessions)
  local talkInfos = actor.talkInfos
  if (talkInfos and #talkInfos > 0) then
    for i, talkInfo in ipairs(talkInfos) do
      if (talkInfo.id == talkid) then
        talkInfo.progress[progressid] = sessions
        return true
      end
    end
  end
  return false
end

-- 清空进度对话，从index开始清空
function TalkHelper.clearProgressContent (actor, talkid, progressid, index)
  index = index or 1
  local talkInfos = actor.talkInfos
  if (talkInfos and #talkInfos > 0) then
    for i, talkInfo in ipairs(talkInfos) do
      if (talkInfo.id == talkid) then
        for i = #talkInfo.progress[progressid], index, -1 do
          table.remove(talkInfo.progress[progressid])
        end
        return true
      end
    end
  end
  return false
end

-- 新增一条进度对话
function TalkHelper.addProgressContent (actor, talkid, progressid, session)
  local talkInfos = actor.talkInfos
  if (talkInfos and #talkInfos > 0) then
    for i, talkInfo in ipairs(talkInfos) do
      if (talkInfo.id == talkid) then
        table.insert(talkInfo.progress[progressid], session)
        return true
      end
    end
  end
  return false
end

-- 新增一些进度对话
function TalkHelper.addProgressContents (actor, talkid, progressid, sessions)
  local talkInfos = actor.talkInfos
  if (talkInfos and #talkInfos > 0) then
    for i, talkInfo in ipairs(talkInfos) do
      if (talkInfo.id == talkid) then
        for j, session in ipairs(sessions) do
          table.insert(talkInfo.progress[progressid], session)
        end
        return true
      end
    end
  end
  return false
end

-- 显示对话结束分隔
function TalkHelper.showEndSeparate (objid)
  TalkHelper.handleTalkOver(objid)
  ChatHelper.showEndSeparate(objid)
end

-- 显示对话中止分隔
function TalkHelper.showBreakSeparate (objid)
  TalkHelper.handleTalkOver(objid)
  ChatHelper.showBreakSeparate(objid)
end

-- 处理对话结束的一些数据
function TalkHelper.handleTalkOver (objid)
  TaskHelper.removeTasks(objid, TaskHelper.needRemoveTasks)
  local player = PlayerHelper.getPlayer(objid)
  if (player.whichChoose and player.whichChoose == 'talk') then
    player.whichChoose = nil
  end
  player:setClickActor(nil)
end