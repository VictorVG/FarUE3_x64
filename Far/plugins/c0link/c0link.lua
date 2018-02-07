function export.GetContentFields(ColNames)
  for i,v in ipairs(ColNames) do
    if v:lower()=="link" then return true end
  end
end

function export.GetContentData(FilePath,ColNames)
  local data = {}
  for i,v in ipairs(ColNames) do
    if v:lower()=="link" then
      local attr = win.GetFileAttr(FilePath)
      if attr and attr:find"e" then
        data[i] = " → "..far.GetReparsePointInfo(FilePath)
      end
    end
  end
  return next(data) and data
end
