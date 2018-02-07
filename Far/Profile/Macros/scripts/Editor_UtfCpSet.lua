-- shmuz, переключение UNICODE кодовой страницы редактора при обнаружении BOM
-- http://forum.ru-board.com/topic.cgi?forum=5&topic=48136&start=2440#3

local F=far.Flags

local BomPatterns = {
  ["^\255\254"]=1200, ["^\254\255"]=1201, ["^\239\187\191"]=65001, ["^%+/v[89+/]"]=65000,
}

Event {
  group="EditorEvent";
  action=function(EditorID, Event, Param)
    if Event == F.EE_READ then
      local fp = io.open(editor.GetFileName(EditorID))
      if fp then
        local sTemp = fp:read(8)
        fp:close()
        if sTemp then
          for pattern, codepage in pairs(BomPatterns) do
            if string.match(sTemp, pattern) then
              editor.SetParam(EditorID, "ESPT_CODEPAGE", codepage); break;
            end
          end
        end
      end
    end
  end;
}