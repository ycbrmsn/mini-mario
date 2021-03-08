-- 我的剧情工具类
MyStoryHelper = {
  index = 1
}

function MyStoryHelper.init ()
  if (#StoryHelper.getStorys() == 0) then
    local ss = { Story1, Story2, Story3, Story4, Story5 }
    for i, v in ipairs(ss) do
      local s = v:new()
      s:init()
      StoryHelper.addStory(s)
    end
  end
end

-- 下一关
function MyStoryHelper.next ()
  MyStoryHelper.index = MyStoryHelper.index + 1
  return MyStoryHelper.getStory()
end

-- 当前关卡
function MyStoryHelper.getStory ()
  return StoryHelper.getStory(MyStoryHelper.index)
end
