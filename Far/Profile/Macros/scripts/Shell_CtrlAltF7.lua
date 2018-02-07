Macro {
  area="Shell"; key="CtrlAltF7"; description="find files from file-list @W17";
  action = function()
    local find_list = ''
    local fp = assert(io.open(APanel.Current))
    while true do
      local line = fp:read()
      if not line then break end
      line = line:gsub("^%s+","")
      line = line:gsub("%s+$","")
      if #line > 0 then find_list = find_list .. ',' .. line end
    end
    fp:close()
    Keys('AltF7'); print(find_list:sub(2)); Keys('Enter')
  end;
}