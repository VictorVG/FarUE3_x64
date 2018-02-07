-- Started: 2015-10-29

-- OPTIONS --
local OptAddToPluginsMenu = true
local OptUseMacro = true
-- END OF OPTIONS --

local F = far.Flags
local thisFile = ...

local function helpFile()
  local suffix = win.GetEnv("FARLANG")=="Russian" and "_rus.hlf" or "_eng.hlf"
  return thisFile and (thisFile:sub(1,-5) .. suffix)
end

local mEng = {
  OK          = "OK";
  CANCEL      = "Cancel";
  TITLE       = "Duplicate Fighter";
  REMDUP      = "&1 Remove duplicates";
  CLRDUP      = "&2 Clear duplicates";
  REMNONUNIQ  = "&3 Remove non-uniques";
  CLRNONUNIQ  = "&4 Clear non-uniques";
  KEEPEMPTY   = "&Keep empty lines";
  SHOWSTATS   = "&Show statistics";
  USEEXPR     = "&Use Expression";
  EXPRESSION  = "&Expression:";
  TOBOOLEAN   = "&Convert to boolean";
  STAT_TITLE  = "Statistics";
  STAT_DUP    = "Duplicate groups:",
  STAT_UNIQ   = "Unique lines:",
  STAT_CLEAR  = "Cleared lines:",
  STAT_DEL    = "Deleted lines:",
  STAT_SKIP   = "Skipped lines:",
}

local mRus = {
  OK          = "OK";
  CANCEL      = "Отмена";
  TITLE       = "Анти-дубликатор";
  REMDUP      = "&1 Удалить дубликаты";
  CLRDUP      = "&2 Очистить дубликаты";
  REMNONUNIQ  = "&3 Удалить неуникальные";
  CLRNONUNIQ  = "&4 Очистить неуникальные";
  KEEPEMPTY   = "&Сохранять пустые строки";
  SHOWSTATS   = "&Показывать статистику";
  USEEXPR     = "&Использовать выражение";
  EXPRESSION  = "&Выражение:";
  TOBOOLEAN   = "Преобразовать в &булевое";
  STAT_TITLE  = "Статистика";
  STAT_DUP    = "Групп дубликатов:",
  STAT_UNIQ   = "Уникальных строк:",
  STAT_CLEAR  = "Очищенных строк:",
  STAT_DEL    = "Удалённых строк:",
  STAT_SKIP   = "Пропущенных строк:",
}

local function SetLanguage() return win.GetEnv("FARLANG")=="Russian" and mRus or mEng end
local M = SetLanguage()

local function GetDups(info, keepempty, func, toboolean)
  local isSel = (info.BlockType ~= F.BTYPE_NONE)
  local isColumn = (info.BlockType == F.BTYPE_COLUMN)
  local uniqs,dups,duplines = {},{},{}
  local nSkipped = 0
  for nl = isSel and info.BlockStartLine or 1,info.TotalLines do
    local S = editor.GetString(nil,nl)
    if   not S or
         isSel and not (S.SelStart>0 and S.SelEnd~=0) or
         nl==info.TotalLines and S.StringText=="" then
      break
    end
    local text = isColumn and S.StringText:sub(S.SelStart,S.SelEnd) or S.StringText
    if keepempty and text:match("^%s*$") then
      text = false
      nSkipped = nSkipped + 1 -- this is by convention NOT a duplicate; skip this line.
    elseif func then
      text = func(text)
      if toboolean or (type(text)~="string" and type(text)~="number") then
        text = not not text
      end
    end
    if text == false then
      -- NOT a duplicate; keep this line
    elseif uniqs[text] then
      duplines[#duplines+1] = -uniqs[text] -- the minus "marks" a duplicate as being the first one
      duplines[#duplines+1] = nl
      dups[text] = true
      uniqs[text] = nil
    elseif dups[text] then
      duplines[#duplines+1] = nl
    else
      uniqs[text] = nl
    end
  end
  
  local nUniq,nDup = 0,0
  for _ in pairs(uniqs) do nUniq = nUniq+1 end
  for _ in pairs(dups) do nDup = nDup+1 end
  
  table.sort(duplines, function(a,b) return math.abs(a) < math.abs(b) end)
  return duplines, nUniq, nDup, nSkipped
end

local function HandleDups(info, op, removeFirst, keepempty, showstats, func, toboolean)
  local duplines, nUniq, nDup, nSkipped = GetDups(info, keepempty, func, toboolean)
  local nClear, nDel = 0,0
  editor.UndoRedo(nil,"EUR_BEGIN")
  if op == "clear" then
    for _,n in ipairs(duplines) do
      if removeFirst or n>0 then
        editor.SetString(nil, math.abs(n), "")
        nClear = nClear+1
      end
    end
  elseif op == "delete" then
    for _,n in ipairs(duplines) do
      if removeFirst or n>0 then
        editor.SetPosition(nil, math.abs(n) - nDel)
        editor.DeleteString()
        nDel = nDel+1
      end
    end
  end
  editor.UndoRedo(nil,"EUR_END")
  editor.Redraw()
  if showstats then
    local len1 = math.max(M.STAT_DUP:len(), M.STAT_UNIQ:len(), M.STAT_SKIP:len(), M.STAT_DEL:len(), M.STAT_CLEAR:len())
    local len2 = tostring(math.max(nDup, nUniq, nSkipped, nDel, nClear)):len()
    local fmt = (("%%-%ds    %%%dd\n"):format(len1,len2)):rep(5):sub(1,-2)    
    local msg = fmt:format(M.STAT_DUP,nDup,M.STAT_UNIQ,nUniq,M.STAT_SKIP,nSkipped,M.STAT_DEL,nDel,M.STAT_CLEAR,nClear)
    far.Message(msg, M.STAT_TITLE)
  end
end

local STdefault = { -- default settings
  method     = 1;
  keepempty  = false;
  statistics = false;
  useexpr    = false;
  toboolean  = true;
}

local function Main()
  M = SetLanguage()
  local ST = mf.mload("Duplicate Fighter", "settings") or STdefault
  local info = editor.GetInfo()

  local dItems = {
--[[01]] {F.DI_DOUBLEBOX,   3, 1,69,14, 0, 0, 0, 0, M.TITLE},
--[[02]] {F.DI_RADIOBUTTON, 5, 3, 0, 0, 1, 0, 0, "DIF_GROUP", M.REMDUP,     op="delete"; removeFirst=false},
--[[03]] {F.DI_RADIOBUTTON, 5, 4, 0, 0, 0, 0, 0, 0,           M.CLRDUP,     op="clear";  removeFirst=false},
--[[04]] {F.DI_RADIOBUTTON, 5, 5, 0, 0, 0, 0, 0, 0,           M.REMNONUNIQ, op="delete"; removeFirst=true},
--[[05]] {F.DI_RADIOBUTTON, 5, 6, 0, 0, 0, 0, 0, 0,           M.CLRNONUNIQ, op="clear";  removeFirst=true},

--[[06]] {F.DI_CHECKBOX,   35, 3, 0, 0, 0, 0, 0, 0,           M.KEEPEMPTY},
--[[07]] {F.DI_CHECKBOX,   35, 4, 0, 0, 0, 0, 0, 0,           M.SHOWSTATS},

--[[08]] {F.DI_CHECKBOX,    5, 8, 0, 0, 0, 0, 0, 0,           M.USEEXPR},
--[[09]] {F.DI_CHECKBOX,   35, 8, 0, 0, 0, 0, 0, 0,           M.TOBOOLEAN},
--[[10]] {F.DI_TEXT,        5, 9, 0, 0, 0, 0, 0, 0,           M.EXPRESSION},
--[[11]] {F.DI_EDIT,        5,10,67, 0, 0, "DupFighterExpression",0,{DIF_HISTORY=1,DIF_USELASTHISTORY=1},""},


--[[12]] {F.DI_TEXT,       -1,12, 0, 0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[13]] {F.DI_BUTTON,      0,13, 0, 0, 0, 0, 0, {DIF_DEFAULTBUTTON=1,DIF_CENTERGROUP=1}, M.OK},
--[[14]] {F.DI_BUTTON,      0,13, 0, 0, 0, 0, 0, F.DIF_CENTERGROUP, M.CANCEL},
  }
  local rbStart,rbEnd,cbEmpty,cbStat,cbExpr,cbBool,lbExpr,edExpr,btOK = 2,5,6,7,8,9,10,11,13

  local function DlgProc(hDlg,Msg,p1,p2)
    if Msg==F.DN_INITDIALOG then
      if ST.method>=rbStart and ST.method<=rbEnd then
        hDlg:send("DM_SETCHECK", ST.method, 1)
        hDlg:send("DM_SETFOCUS", ST.method)
      end
      hDlg:send("DM_SETCHECK", cbEmpty, ST.keepempty  and 1 or 0)
      hDlg:send("DM_SETCHECK", cbStat,  ST.statistics and 1 or 0)
      hDlg:send("DM_SETCHECK", cbExpr,  ST.useexpr    and 1 or 0)
      hDlg:send("DM_SETCHECK", cbBool,  ST.toboolean  and 1 or 0)
      hDlg:send("DM_ENABLE",   cbBool,  ST.useexpr    and 1 or 0)
      hDlg:send("DM_ENABLE",   lbExpr,  ST.useexpr    and 1 or 0)
      hDlg:send("DM_ENABLE",   edExpr,  ST.useexpr    and 1 or 0)

    elseif Msg==F.DN_BTNCLICK and p1==cbExpr then
      hDlg:send("DM_ENABLE", cbBool, p2)
      hDlg:send("DM_ENABLE", lbExpr, p2)
      hDlg:send("DM_ENABLE", edExpr, p2)

    elseif Msg == F.DN_CONTROLINPUT then
      if p2.EventType == F.KEY_EVENT then
        if "F1" == far.InputRecordToName(p2) then
          local fname = helpFile()
          if fname then far.ShowHelp(fname, nil, F.FHELP_CUSTOMFILE) end
        end
      end

    elseif Msg==F.DN_CLOSE and p1==btOK then
      if hDlg:send("DM_GETCHECK", cbExpr) ~= 0 then
        local expr = "return " .. hDlg:send("DM_GETTEXT", edExpr)
        local f, msg = loadstring(expr)
        if not f then
          far.Message(msg, M.TITLE, nil, "w"); return 0;
        end
      end

    end
  end

  local guid = win.Uuid("85FA90FE-4068-4FFB-962E-F961F46BE867")
  if far.Dialog (guid,-1,-1,73,16,nil,dItems,nil,DlgProc) == btOK then
    ST.keepempty  = dItems[cbEmpty][6] ~= 0
    ST.statistics = dItems[cbStat][6] ~= 0
    ST.useexpr    = dItems[cbExpr][6] ~= 0
    ST.toboolean  = dItems[cbBool][6] ~= 0
    for k=rbStart,rbEnd do
      local item = dItems[k]
      if item[6] ~= 0 then
        ST.method = k
        mf.msave("Duplicate Fighter", "settings", ST)
        local func = ST.useexpr and loadstring("local L=... return "..dItems[edExpr][10])
        HandleDups(info, item.op, item.removeFirst, ST.keepempty, ST.statistics, func, ST.toboolean)
        break
      end
    end
  end
end

if OptUseMacro then
  Macro {
    description = M.TITLE;
    area="Editor"; key="CtrlShiftP"; action=Main;
  }
end

if OptAddToPluginsMenu then
  MenuItem {
    description = M.TITLE;
    menu   = "Plugins";
    area   = "Editor";
    guid   = "D1F37D2D-20F4-4151-820E-236E7B4A42CC";
    text   = function(menu, area) M = SetLanguage(); return M.TITLE; end;
    action = function(OpenFrom, Item) mf.postmacro(Main) end;
  }
end
