-- 地图相关数据
MyMap = {
  BLOCK = {
    DESTROY = 207, -- 落叶松木板（大形态踩碎方块）
    LUCKY = 2001, -- 幸运方块
    COIN = 2002, -- 幸运金币
    INVALID = 2003 -- 无效方块
  },
  ITEM = {
    COIN = 4099, -- 幸运币
    BOTTLE = 4102, -- 续命药瓶
    PILL = 4103, -- 续命药丸
    ROAST_CHICKEN = 12558, -- 烤鸡
    JUMP = 4104, -- 跳跃
    KEY = 4105, -- 钥匙
  },
  ACTOR = {
    STAR = 3, -- 黄星星
    MUSHROOM = 4 -- 红蘑菇
  },
  BUFF = {
    CONTINUE = 999, -- 继续探险
    PROTECT = 50000001, -- 缩小保护
    FEARLESS = 50000002 -- 无畏
  },
  CUSTOM = {
    PROJECTILE_HURT = 6, -- 通用投掷物固定伤害
  }
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
MyWeaponAttr = {}
