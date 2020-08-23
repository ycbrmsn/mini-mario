-- 地图相关数据
MyMap = {
  ITEM = {

  },
  ACTOR = {

  },
  BUFF = {
    PROTECT = 50000001, -- 缩小保护
    FEARLESS = 50000002 -- 无畏
  },
  CUSTOM = {

  },
}

-- 模板
MyTemplate = {
  GAIN_EXP_MSG = '你获得{exp}点经验', -- exp（获得经验）
  GAIN_DEFEATED_EXP_MSG = '历经生死，你获得{exp}点经验', -- exp（获得经验）
  UPGRADE_MSG = '你升级了', -- exp（获得经验）、level（玩家等级）
  -- UNUPGRADE_MSG = '当前为{level}级。还差{needExp}点经验升级' -- level（玩家等级）、needExp（升级还需要的经验）
  TEAM_MSG = '当前红队有{1}人，蓝队有{2}人，准备玩家有{0}人', -- 0（无队伍人数）、1（红队人数）、2（蓝队人数）
}

-- 武器属性
MyWeaponAttr = {
  -- 剑
  controlSword = { -- 御仙剑
    attack = 70,
    defense = 20,
    cd = 15,
    cdReason = '御仙剑失控，短时间内无法再次御剑飞行',
    skillname = '御剑飞行',
    addAttPerLevel = 30,
    addDefPerLevel = 20
  },
  tenThousandsSword = { -- 万仙剑
    attack = 90,
    defense = 0,
    cd = 15,
    cdReason = '万剑诀技能冷却中',
    skillname = '万剑诀',
    size = 1, -- 飞剑范围
    hurt = 30,
    addAttPerLevel = 40,
    addDefPerLevel = 10,
    addSizePerLevel = 1,
    addHurtPerLevel = 5
  },
  huixianSword = { -- 回仙剑
    attack = 80,
    defense = 10,
    cd = 15,
    cdReason = '回天剑诀技能冷却中',
    skillname = '回天剑诀',
    num = 4, -- 数量
    size = 5, -- 有效范围
    hurt = 40,
    addAttPerLevel = 20,
    addDefPerLevel = 30,
    addNumPerLevel = 1,
    addSizePerLevel = 1,
    addHurtPerLevel = 10
  },
  vitalqiSword = { -- 气仙剑
    attack = 60,
    defense = 30,
    cd = 15,
    cdReason = '气甲术技能冷却中',
    skillname = '气甲术',
    addAttPerLevel = 10,
    addDefPerLevel = 40
  }
}

-- 武器id
MyWeaponAttr.controlSword.levelIds = { 4105, -1, -11, -111 } -- 御仙剑
MyWeaponAttr.controlSword.projectileid = 4109 -- 飞行的御仙剑
MyWeaponAttr.tenThousandsSword.levelIds = { 4106, -2, -22, -222 } -- 万仙剑
MyWeaponAttr.tenThousandsSword.projectileid = 4110 -- 飞行的万仙剑
MyWeaponAttr.huixianSword.levelIds = { 4107, -3, -33, -333 } -- 回仙剑
MyWeaponAttr.huixianSword.projectileid = 4111 -- 飞行的回仙剑
MyWeaponAttr.vitalqiSword.levelIds = { 4108, -4, -44, -444 } -- 气仙剑
