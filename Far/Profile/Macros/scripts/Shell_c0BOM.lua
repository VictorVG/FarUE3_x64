-- http://forum.ru-board.com/topic.cgi?forum=5&topic=49572&start=2400#9
-- Кладём в Shell_c0BOM.lua ./Profile/Macros/scripts, перегружаем макросы или сам Far,
-- F9 - File panel modes - добавляем в любой режим, либо создаём новый, взяв
-- за основу какой-либо из уже имеющихся. Например для Wide:
-- Column types
-- N,S,<BOM>
-- Column widths
-- 0,6,4

local function process(f)
  -- utf32le,utf32be,utf16le,utf16be,utf8
  local res,bom = 0,{'\255\254\0\0','\0\0\254\255','\255\254','\254\255','\239\187\191'}
  local BomName={"","32LE","32BE","16LE","16BE","UTF8"}
  local h=io.open(f,"rb")
  if h then
    local s=h:read(4) or '' h:close()
    for i=#bom,2,-1 do
      if string.sub(s,1,#bom[i])==bom[i] then
        if i==3 and s==bom[1] then i=1 end
        res=i
        break
      end
    end
  end
  return BomName[res+1]
end
local c0 = {
  GetContentFields = function(ColNames)
    for _,v in ipairs(ColNames) do
      if v:upper()=="BOM" then return true end
    end
  end;
  GetContentData = function(FilePath,ColNames)
    local data = {}
    for i,v in ipairs(ColNames) do
      if v:upper()=="BOM" then
        local attr = win.GetFileAttr(FilePath)
        if attr and not attr:find"d" then data[i]=process(FilePath) end
      end
    end
    return next(data) and data
  end
}
if not Far then
  for k,v in pairs(c0) do export[k] = v; end
elseif ContentColumns then
  ContentColumns(c0)
end