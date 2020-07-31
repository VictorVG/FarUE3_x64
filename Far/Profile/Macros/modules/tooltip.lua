local id = win.Uuid"45B09D0D-6AE8-416C-BB5A-F5FA7B5CC430"
local F = far.Flags
local DEF_TIMEOUT = 3000
local function Message(text,title,timeout)--X,Y
  --todo title width
  --todo wide screen

  local len = text:len()
  local items = {
    --[[01]]  {F.DI_SINGLEBOX,0,0,len+2,3,0,0,0,0,title},
    --[[02]]  {F.DI_TEXT,     1,1,0,0,0,0,0,0,text},--todo center
  }
  local flags = F.FDLG_NONMODAL
  local timer
  local hDlg = far.DialogInit(id,-1,-1,len+2,3,len,items,flags,function(hDlg,Msg)
    if Msg==F.DN_CLOSE and timer then timer:Close() end
  end)
  if timeout~=false then
    timeout = (timeout or DEF_TIMEOUT)--*1000
    timer = far.Timer(timeout,function(t) t:Close(); hDlg:send"DM_CLOSE" end)
  end
  return hDlg
end

return Message