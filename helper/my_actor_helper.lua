-- 我的角色工具类
MyActorHelper = {}

-- 初始化actors
function MyActorHelper:init ()
  -- linqianshu = Linqianshu:new()
  -- linwanshu = Linwanshu:new()
  -- yexiaolong = Yexiaolong:new()
  -- yedalong = Yedalong:new()
  -- local myActors = { linqianshu, linwanshu, yexiaolong, yedalong }
  -- for i, v in ipairs(myActors) do
  --   TimeHelper:initActor(v)
  --   -- LogHelper:debug('创建', v:getName(), '完成')
  -- end
  -- LogHelper:debug('创建人物完成')
end

-- 事件

-- actor进入区域
function MyActorHelper:actorEnterArea (objid, areaid)
  ActorHelper:actorEnterArea(objid, areaid)
  MyStoryHelper:actorEnterArea(objid, areaid)
end

-- actor离开区域
function MyActorHelper:actorLeaveArea (objid, areaid)
  ActorHelper:actorLeaveArea(objid, areaid)
  MyStoryHelper:actorLeaveArea(objid, areaid)
end

-- 生物碰撞
function MyActorHelper:actorCollide (objid, toobjid)
  ActorHelper:actorCollide(objid, toobjid)
  MyStoryHelper:actorCollide(objid, toobjid)
  -- body
  if (ActorHelper:isPlayer(toobjid)) then -- 与玩家碰撞
    local eyeHeight
    local actorid = CreatureHelper:getActorID(objid)
    if (actorid == 3400) then -- 鸡
      eyeHeight = 0.2
    else
      eyeHeight = ActorHelper:getEyeHeight(objid)
    end
    local x, y, z = ActorHelper:getPosition(objid)
    local player = PlayerHelper:getPlayer(toobjid)
    -- LogHelper:debug(y + eyeHeight)
    -- LogHelper:debug(player.y)
    if (y + eyeHeight < player.y) then -- 在玩家下方
      -- 生物假死30秒
      -- ActorHelper:killSelf(objid)
      CreatureHelper:setHp(objid, 0)
      TimeHelper:callFnAfterSecond(function ()
        CreatureHelper:setHp(objid, CreatureHelper:getMaxHp(objid))
      end, 30)

      -- 玩家一个小跳效果
      local yaw = ActorHelper:getFaceYaw(toobjid)
      local pitch = ActorHelper:getFacePitch(toobjid)
      PlayerHelper:setPosition(toobjid, player.x, player.y, player.z)
      ActorHelper:setFaceYaw(toobjid, yaw)
      ActorHelper:setFacePitch(toobjid, pitch)
      ActorHelper:appendSpeed(toobjid, 0, 0.6, 0)
      -- ActorHelper:appendSpeed(toobjid, 0, -player.ySpeed, 0)
      
    else
      ActorHelper:killSelf(toobjid)
    end
  end
end

-- 生物攻击命中
function MyActorHelper:actorAttackHit (objid, toobjid)
  ActorHelper:actorAttackHit(objid, toobjid)
  MyStoryHelper:actorAttackHit(objid, toobjid)
end

-- 生物行为改变
function MyActorHelper:actorChangeMotion (objid, actormotion)
  ActorHelper:actorChangeMotion(objid, actormotion)
  MyStoryHelper:actorChangeMotion(objid, actormotion)
end

-- 生物死亡
function MyActorHelper:actorDie (objid, toobjid)
  ActorHelper:actorDie(objid, toobjid)
  MyStoryHelper:actorDie(objid, toobjid)
end