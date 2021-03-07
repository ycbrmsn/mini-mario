-- 事件工具类
EventHelper = {
  func = {}, -- eventname -> [函数数组]
}

-- 新增事件
function EventHelper.addEvent (eventname, f)
  if (not(EventHelper.func[eventname])) then
    EventHelper.func[eventname] = { f }
  else
    table.insert(EventHelper.func[eventname], f)
  end
end

-- 自定义方法
function EventHelper.customEvent (eventname, ...)
  local fs = EventHelper.func[eventname]
  if (fs) then
    for i, v in ipairs(fs) do
      v(...)
    end
  end
end

-- 生物事件

-- 生物被创建
function EventHelper.actorCreate (objid, toobjid)
  ActorHelper.actorCreate(objid, toobjid)
  EventHelper.customEvent('actorCreate', objid, toobjid)
end

-- actor进入区域
function EventHelper.actorEnterArea (objid, areaid)
  ActorHelper.actorEnterArea(objid, areaid)
  EventHelper.customEvent('actorEnterArea', objid, areaid)
end

-- actor离开区域
function EventHelper.actorLeaveArea (objid, areaid)
  ActorHelper.actorLeaveArea(objid, areaid)
  EventHelper.customEvent('actorLeaveArea', objid, areaid)
end

-- 生物碰撞
function EventHelper.actorCollide (objid, toobjid)
  ActorHelper.actorCollide(objid, toobjid)
  EventHelper.customEvent('actorCollide', objid, toobjid)
end

-- 生物攻击命中
function EventHelper.actorAttackHit (objid, toobjid)
  ActorHelper.actorAttackHit(objid, toobjid)
  EventHelper.customEvent('actorAttackHit', objid, toobjid)
end

-- 生物击败目标
function EventHelper.actorBeat (objid, toobjid)
  ActorHelper.actorBeat(objid, toobjid)
  EventHelper.customEvent('actorBeat', objid, toobjid)
end

-- 生物行为改变
function EventHelper.actorChangeMotion (objid, actormotion)
  ActorHelper.actorChangeMotion(objid, actormotion)
  EventHelper.customEvent('actorChangeMotion', objid, actormotion)
end

-- 生物受到伤害
function EventHelper.actorBeHurt (objid, toobjid, hurtlv)
  ActorHelper.actorBeHurt(objid, toobjid, hurtlv)
  EventHelper.customEvent('actorBeHurt', objid, toobjid, hurtlv)
end

-- 生物死亡
function EventHelper.actorDie (objid, toobjid)
  ActorHelper.actorDie(objid, toobjid)
  EventHelper.customEvent('actorDie', objid, toobjid)
end

-- 生物获得状态效果
function EventHelper.actorAddBuff (objid, buffid, bufflvl)
  ActorHelper.actorAddBuff(objid, buffid, bufflvl)
  EventHelper.customEvent('actorAddBuff', objid, buffid, bufflvl)
end

-- 生物失去状态效果
function EventHelper.actorRemoveBuff (objid, buffid, bufflvl)
  ActorHelper.actorRemoveBuff(objid, buffid, bufflvl)
  EventHelper.customEvent('actorRemoveBuff', objid, buffid, bufflvl)
end

-- 生物属性变化
function EventHelper.actorChangeAttr (objid, actorattr)
  ActorHelper.actorChangeAttr(objid, actorattr)
  EventHelper.customEvent('actorChangeAttr', objid, actorattr)
end
