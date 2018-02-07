-- http://forum.farmanager.com/viewtopic.php?p=124193#p124193
-- mod of IgorZ's macro

local GUImenu = true  -- показывать графическое / или текстовое меню
local HoldMode = true -- срабатывать при удержании ПКМ / или при нажатии ПКМ+ЛКМ

local cmd = GUImenu and "rclk_gui:" or "rclk_txt:"
local HoldDelay = 900 -- (мс) время удержания кнопки, после которого вызывается меню
local MinDelay = 20

if not Far.GetConfig"Panel.RightClickSelect" then -- требуется far 3 build 4082
  far.Message([[

This macro requires Panel.RightClickSelect=true
(see far:config)]],...,nil,"wl")
  return
end

local FROM_LEFT_1ST_BUTTON_PRESSED, RIGHTMOST_BUTTON_PRESSED = 0x0001, 0x0002
local BOTH = bor(FROM_LEFT_1ST_BUTTON_PRESSED, RIGHTMOST_BUTTON_PRESSED)

local function eMenu(ToggleSel)
  if ToggleSel then Panel.Select(0,2,1); far.Text() end -- инвертировать выделение
  repeat
    mf.waitkey(MinDelay)
  until not GUImenu or band(Mouse.Button,RIGHTMOST_BUTTON_PRESSED)==0
  Plugin.Command("742910F1-02ED-4542-851F-DEE37C2E13B2",cmd)
end

local function On2Click(timer,ClickPos,ToggleSel)
  if band(Mouse.Button,RIGHTMOST_BUTTON_PRESSED)==0 or ClickPos~=Object.CurPos then
    timer:Close()
  elseif band(Mouse.Button,BOTH)==BOTH then
    timer:Close()
    mf.postmacro(eMenu,ToggleSel)
  end
end

local function OnHold(timer,ClickPos,ToggleSel)
  timer:Close()
  if Mouse.Button==RIGHTMOST_BUTTON_PRESSED and ClickPos==Object.CurPos then
    mf.postmacro(eMenu,ToggleSel)
  end
end

local timer
Macro{
  area="Shell Tree"; key="MsRClick"; description="EMenu: by RClick and hold";
  id="208B186D-4B57-4734-9476-6A390FBE55DD";
  action=function()
    if timer and not timer.Closed then timer:Close() end
    local selected = APanel.SelCount+PPanel.SelCount
    Keys"AKey"
    timer = far.Timer(HoldMode and HoldDelay or MinDelay,
                      HoldMode and OnHold or On2Click,
                      Object.CurPos,
                      selected~=APanel.SelCount+PPanel.SelCount)
  end;
}
