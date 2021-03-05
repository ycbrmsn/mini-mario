-- 我的角色工具类
MyActorHelper = {}

-- 初始化actors
function MyActorHelper.init ()
end

-- 事件

-- 生物被创建
function MyActorHelper.actorCreate (objid, toobjid)
  ActorHelper:actorCreate(objid, toobjid)
  MyStoryHelper.actorCreate(objid, toobjid)
end

-- actor进入区域
function MyActorHelper.actorEnterArea (objid, areaid)
  ActorHelper:actorEnterArea(objid, areaid)
  MyStoryHelper.actorEnterArea(objid, areaid)
end

-- actor离开区域
function MyActorHelper.actorLeaveArea (objid, areaid)
  ActorHelper:actorLeaveArea(objid, areaid)
  MyStoryHelper.actorLeaveArea(objid, areaid)
end

-- 生物碰撞
function MyActorHelper.actorCollide (objid, toobjid)
  ActorHelper:actorCollide(objid, toobjid)
  MyStoryHelper.actorCollide(objid, toobjid)
  -- body
  if (ActorHelper:isPlayer(toobjid)) then -- 与玩家碰撞
    local actorid = CreatureHelper:getActorID(objid)
    if (actorid == MyMap.ACTOR.STAR) then -- 黄星星
      if (WorldHelper:despawnActor(objid)) then -- 销毁成功
        ActorHelper:addBuff(toobjid, MyMap.BUFF.FEARLESS, nil, 15 * 20)
      end
    elseif (actorid == MyMap.ACTOR.MUSHROOM) then -- 红蘑菇
      if (WorldHelper:despawnActor(objid)) then -- 销毁成功
        local dimension = PlayerHelper:getDimension(toobjid)
        if (dimension == 1) then
          PlayerHelper:setDimension(toobjid, 1.5) -- 尺寸1.5
        else
          LogHelper.debug('获得武器')
        end
      end
    elseif (actorid == MyMap.ACTOR.KEY) then -- 城堡钥匙
      if (WorldHelper:despawnActor(objid)) then -- 销毁成功
        BackpackHelper:addItem(toobjid, MyMap.ITEM.KEY, 1)
      end
    elseif (actorid == MyMap.ACTOR.PILL) then -- 续命药丸
      if (WorldHelper:despawnActor(objid)) then -- 销毁成功
        BackpackHelper:addItem(toobjid, MyMap.ITEM.PILL, 1)
      end
    elseif (actorid == MyMap.ACTOR.FLOOR) then -- 花
      if (WorldHelper:despawnActor(objid)) then -- 销毁成功
        BackpackHelper:addItem(toobjid, MyMap.ITEM.FLOOR, 3)
      end
    else
      local player = PlayerHelper:getPlayer(toobjid)
      if (ActorHelper:hasBuff(toobjid, MyMap.BUFF.FEARLESS)) then -- 玩家有了无畏buff
        player:knockCreature(objid)
      else -- 正常情况
        local eyeHeight
        if (actorid == 3400) then -- 鸡
          eyeHeight = 0.2
        elseif (actorid == 3407) then -- 狼
          eyeHeight = 0.2
        else
          eyeHeight = ActorHelper:getEyeHeight(objid)
        end
        local x, y, z = ActorHelper:getPosition(objid)
        -- LogHelper.debug(y + eyeHeight)
        -- LogHelper.debug(player.y)
        -- if (y + eyeHeight < player.y) then -- 在玩家下方
        LogHelper.debug(eyeHeight)
        LogHelper.debug(player.fallHeight - player.y)
        if (eyeHeight < player.fallHeight - player.y) then
          -- 生物假死30秒
          -- ActorHelper:killSelf(objid)
          player:knockCreature(objid)

          -- 玩家一个小跳效果
          local yaw = ActorHelper:getFaceYaw(toobjid)
          local pitch = ActorHelper:getFacePitch(toobjid)
          PlayerHelper:setPosition(toobjid, player.x, player.y, player.z)
          ActorHelper:setFaceYaw(toobjid, yaw)
          ActorHelper:setFacePitch(toobjid, pitch)
          ActorHelper:appendSpeed(toobjid, 0, 0.6, 0)
          -- ActorHelper:appendSpeed(toobjid, 0, -player.ySpeed, 0)
        else
          local hasProtectBuff = ActorHelper:hasBuff(toobjid, MyMap.BUFF.PROTECT)
          local hasContinueBuff = ActorHelper:hasBuff(toobjid, MyMap.BUFF.CONTINUE)
          if (hasProtectBuff or hasContinueBuff) then
          else
            local dimension = PlayerHelper:getDimension(toobjid)
            if (dimension > 1) then
              ActorHelper:addBuff(toobjid, MyMap.BUFF.PROTECT, nil, 60)
              PlayerHelper:setDimension(toobjid, 1)
            else
              player:killSelf()
            end
          end
        end
      end
    end -- 碰撞怪物结束
  end
end

-- 生物攻击命中
function MyActorHelper.actorAttackHit (objid, toobjid)
  ActorHelper:actorAttackHit(objid, toobjid)
  MyStoryHelper.actorAttackHit(objid, toobjid)
end

-- 生物击败目标
function MyActorHelper.actorBeat (objid, toobjid)
  ActorHelper:actorBeat(objid, toobjid)
  MyStoryHelper.actorBeat(objid, toobjid)
end

-- 生物行为改变
function MyActorHelper.actorChangeMotion (objid, actormotion)
  ActorHelper:actorChangeMotion(objid, actormotion)
  MyStoryHelper.actorChangeMotion(objid, actormotion)
  -- body
  -- if (actormotion == CREATUREMOTION.IDLE) then -- 空闲
  --   local pos = ActorHelper:getMyPosition(objid)
  --   if (pos) then
  --     local x
  --     if (pos.x < 10) then
  --       x = 0.5
  --     elseif (pos.x < 90) then
  --       x = 81.5
  --     elseif (pos.x < 170) then
  --       x = 162.5
  --     end
  --   end
  --   ActorHelper:setPosition(objid, x, pos.y, pos.z)
  -- end
end

-- 生物受到伤害
function MyActorHelper.actorBeHurt (objid, toobjid, hurtlv)
  ActorHelper.actorBeHurt(objid, toobjid, hurtlv)
  MyStoryHelper.actorBeHurt(objid, toobjid, hurtlv)
  -- body
end

-- 生物死亡
function MyActorHelper.actorDie (objid, toobjid)
  ActorHelper:actorDie(objid, toobjid)
  MyStoryHelper.actorDie(objid, toobjid)
end

-- 生物获得状态效果
function MyActorHelper.actorAddBuff (objid, buffid, bufflvl)
  ActorHelper.actorAddBuff(objid, buffid, bufflvl)
  MyStoryHelper.actorAddBuff(objid, buffid, bufflvl)
  -- body
end

-- 生物失去状态效果
function MyActorHelper.actorRemoveBuff (objid, buffid, bufflvl)
  ActorHelper.actorRemoveBuff(objid, buffid, bufflvl)
  MyStoryHelper.actorRemoveBuff(objid, buffid, bufflvl)
  -- body
end

-- 生物属性变化
function MyActorHelper.actorChangeAttr (objid, actorattr)
  ActorHelper.actorChangeAttr(objid, actorattr)
  MyStoryHelper.actorChangeAttr(objid, actorattr)
  -- body
end