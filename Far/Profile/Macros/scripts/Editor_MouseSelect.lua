-------------------------------------------------------------------------------
--           Работа мышкой с выделением в редакторе. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   первая таблица (действие):
--     перемещать курсор за мышкой - команда "SelNone";
--     выделять обычные и вертикальные блоки - "SelNorm", "SelVert";
--     корректировать выделение обычных и вертикальных блоков - "CorNorm" и "CorVert";
--     выделять слово, строку как нормальный, так и как вертикальный блок - "WordNorm", "LineNorm" и "WordVert", "LineVert";
--     перетаскивать блоки, перетаскивать с копированием - "Move", "Copy";
--   вторая таблица (последействие):
--     в буфер обмена вырезать, копировать, добавлять, вырезать с добавлением - "Copy", "Cut", "Add", "CutAdd";
--     удалять, вставлять и обменивать с буфером обмена - "Delete", "Paste" и "Replace".
-- Различает состояния - ключи в соответствующей таблице:
--   одинарный, двойной и т.д. клик мышки в выделенной области "InSel1", "InSel2", ...
--   одинарный, двойной и т.д. клик мышки вне выделенной области "NotSel1", "NotSel2", ...
--   одинарный, двойной и т.д. клик мышки в любой области при отсутствии действий для предыдущих состояний "Click1", "Click2", ...
-- Пример: хотим выделить и вырезать в клипборд вертикальный блок - SimSU.Editor_MouseSelect.MouseSelect({Click1="SelVert"},{Click1="Cut"})
--         ещё хотим по двойному клику выделять и удалять слово - дополним таблицы... SimSU.Editor_MouseSelect.MouseSelect({Click1="SelVert",Click2="WordNorm"},{Click1="Cut",Click2="Delete"})

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_MouseSelect.cfg
local Timing=250 -- Максимальный интервал (мс) между кликами при превышении которого двойной, тройной и т.д. клик не будет засчитан.
local Key, Action, PostAct = {},{},{}
  -- Обычный блок: при клике в выделении корректируем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Key[1]="MsLClick"
  Action[1]={InSel1="CorNorm"; Click1="SelNorm"; Click2="WordNorm"; Click3="LineNorm";}
  -- Вертикальный блок: При клике в выделении корректируем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Key[2]="MsRClick AltMsLClick"
  Action[2]={InSel1="CorVert"; Click1="SelVert"; Click2="WordVert"; Click3="LineVert";}
  -- Обычный блок с копированием в буфер: при клике в выделении перетаскиваем копию, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Key[3]="CtrlMsLClick"
  Action[3]={InSel1="Copy"; Click1="SelNorm"; Click2="WordNorm"; Click3="LineNorm";}
  PostAct[3]={Click1="Copy"; Click2="Copy"; Click3="Copy";}
  -- Обычный блок с вырезанием в буфер: при клике в выделении перетаскиваем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Key[4]="ShiftMsLClick"
  Action[4]={InSel1="Move"; Click1="SelNorm"; Click2="WordNorm"; Click3="LineNorm";}
  PostAct[4]={Click1="Cut"; Click2="Cut"; Click3="Cut";}

return{Timing=Timing; Key=Key; Action=Action; PostAct=PostAct;}
-- Конец файла Profile\SimSU\Editor_MouseSelect.cfg
end

_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
--if far.lang=="Russian" then
-- Начало файла Profile\SimSU\SimSU\Editor_MouseSelectRussian.lng
local Descr={}
  -- Обычный блок: при клике в выделении корректируем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Descr[1]="Выделение обычного блока. © SimSU"
  -- Вертикальный блок: При клике в выделении корректируем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Descr[2]="Выделение вертикального блока. © SimSU"
  -- Обычный блок с копированием в буфер: при клике в выделении перетаскиваем копию, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Descr[3]="Выделение с копированием. © SimSU"
  -- Обычный блок с вырезанием в буфер: при клике в выделении перетаскиваем, иначе выделяем, при двойном клике выделить слово, при тройном выделить строку. © SimSU"
  Descr[4]="Выделение с вырезанием. © SimSU"
return{Descr=Descr;}
-- Конец файла Profile\SimSU\Editor_MouseSelectRussian.lng
end --end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MouseSelect"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_MouseSelect.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MouseSelect.cfg") or Settings)()

local SimSU= SimSU or {}
SimSU.Editor_MouseSelect={}
-------------------------------------------------------------------------------
local TitleBar,KeyBar,ScrollBar
local Timing=S.Timing or 250

function SimSU.Editor_MouseSelect.Condition()
  -- Функция инициализации переменных и проверки условия запуска макроса,
  -- чтобы не запускать макрос при кликах в скролбар, функциональные клавиши и т.п.
  TitleBar=Far.Cfg_Get("Editor","ShowTitleBar")=="true" and 1 or 0 -- Если строка статуса включена, то надо корректировать координату Y мыши и не выделять если в неё кликнули.
  KeyBar=Far.KeyBar_Show(0) -- Если кейбар включен, то не выделять если в него кликнули.
  ScrollBar=Editor.Set(15,-1) -- Если скролбар включен, то не выделять если в него кликнули.
  return Mouse.X<Far.Width-ScrollBar and Mouse.Y>=TitleBar and Mouse.Y<Far.Height-KeyBar -- Кликнули в текст, значит разрешим макрос макрос.
end

function SimSU.Editor_MouseSelect.MouseToText()
-- Функция пересчёта экранных координат мышки в координаты текста.
  local X0,Y0 = Editor.Pos(0,5),Editor.Pos(0,4)
  local Yc= Mouse.Y==TitleBar-1 and Y0 or Mouse.Y>=Far.Height-1-KeyBar and Y0+Far.Height-1-TitleBar-KeyBar or Y0+Mouse.Y-TitleBar
  local Xc= Mouse.X==0 and X0 or Mouse.X>=Far.Width-1-ScrollBar and X0+Far.Width-1-ScrollBar or X0+Mouse.X
  return Xc,Yc,X0,Y0 -- Координаты курсора и координаты экрана.
end

function SimSU.Editor_MouseSelect.MouseMove(SelMode,Xb,Yb)
-- Функция обработки движения мышки.
  local MM=mmode(1,1) -- Запретим перерисовку экрана.
  local EOL=Editor.Set(7,1) -- Разрешим "курсор за пределами строки".
  local Xc,Yc,X0,Y0 = SimSU.Editor_MouseSelect.MouseToText()
  if not ((SelMode==1 or SelMode==2) and Xb and Yb) then Xb=Xc; Yb=Yc end -- За начало примем текущие координаты.
  while Mouse.Button~=0 do
    if SelMode==1 or SelMode==2 then
      -- Выделение. И магия :) для табов с вертикальными блоками.
      Editor.Pos(1,1,Yb); Editor.Pos(1,4-SelMode,Xb); Editor.Sel(SelMode+1,0)
      Editor.Pos(1,1,Yc); Editor.Pos(1,4-SelMode,Xc); Editor.Sel(SelMode+1,1)
    end
    Editor.Pos(1,4,Y0); Editor.Pos(1,5,X0) -- Координаты экрана.
    Editor.Pos(1,1,Yc); Editor.Pos(1,3,Xc) -- Координаты курсора в тексте.
    mmode(1,mmode(1,0),Editor.Pos(1,2,Xct)) -- Перерисуем экран. Двинем курсор для колорера.
    mf.waitkey(1)
    Xc,Yc,X0,Y0 = SimSU.Editor_MouseSelect.MouseToText() -- Новые координаты.
    -- Скроллирование.
    if Xc==X0 and X0>1 then X0=X0-1 Xc=X0 elseif Xc==X0+Far.Width-1-ScrollBar then X0=X0+1; Xc=X0+Far.Width-1-ScrollBar end
    if Yc==Y0 and Y0>1 then Y0=Y0-1 Yc=Y0 elseif Yc==Y0+Far.Height-1-KeyBar-TitleBar and Yc<Editor.Lines then Y0=Y0+1; Yc=Y0+Far.Height-1-KeyBar-TitleBar end
  end
  Editor.Set(7,EOL) -- Восстановим состояние "курсор за пределами строки".
  mmode(1,MM) -- Восстановим состояние отрисовки.
end

function SimSU.Editor_MouseSelect.ClickInSel()
-- Функция проверки на клик в выделенной области.
  local Xc,Yc,X0,Y0 = SimSU.Editor_MouseSelect.MouseToText()
  local St=Editor.Sel(0,4) Yb= St==0 and Yc or Editor.Sel(0,0) Xb= St==0 and Xc or Editor.Sel(0,1); Ye= St==0 and Yc or Editor.Sel(0,2); Xe= St==0 and Xc or Editor.Sel(0,3) -- Тип и координаты выделения.
  local Sl=(St==0 or (St>0 and Yc<=Ye and Yc>=Yb)) -- Курсор в строках где есть выделение.
  local Sp=(Sl and ((St==2 and Xc>=Xb and Xc<=Xe) or (St==1 and ((Yb~=Ye and Yc==Yb and Xc>=Xb) or (Yb~=Ye and Yc==Ye and Xc<=Xe) or (Yb==Ye and Xc>=Xb and Xc<=Xe) or (Yb~=Ye and Yc~=Yb and Yc~=Ye))))) -- Курсор точно в выделении.
  if not Sp then
    Xb=nil; Yb=nil -- Если кликнули не в выделенной области, то считаем, что и выделения нет.
  else
    if (Xb-Xc)^2+(Yb-Yc)^2<(Xe-Xc)^2+(Ye-Yc)^2 then Xb,Yb = Xe,Ye end -- За начало выделенной области примем её дальний от места клика угол.
  end
  return Xb,Yb,X0,Y0 -- Координаты начала выделенного блока и координаты экрана.
end

function SimSU.Editor_MouseSelect.SelWord(SelectType,Line,Column)
-- Функция выделения слова.
  local St= SelectType or 1
  local Xc,Yc
  if Line and Column then Yc,Xc = Line,Column else Xc,Yc = SimSU.Editor_MouseSelect.MouseToText() end
  Editor.Pos(1,1,Yc); Editor.Pos(1,3,Xc)
  local s=Editor.Value; local Xct=Editor.RealPos
  local Xe=Xct while s:sub(Xe,Xe):find("[%w_]") do Xe=Xe+1 end-- Ищем конец слова c курсором.
  local Xb=Xct while s:sub(Xb-1,Xb-1):find("[%w_]") do Xb=Xb-1 end -- Ищем начало слова c курсором.
  Editor.Pos(1,2,Xb); Editor.Sel(St+1,0); Editor.Pos(1,2,Xe); Editor.Sel(St+1,1) -- Выделяем найденное слово, если слово не нашли, то выделение просто снимется из-за равенства Beg и End.
  mmode(1,mmode(1,0),Editor.Pos(1,2,Xct)) -- Перерисуем экран. Двинем курсор для колорера.
end

function SimSU.Editor_MouseSelect.SelLine(SelectType,Line,Column)
-- Функция выделения строки.
  local St= SelectType or 1
  local Xc,Yc
  if Y then Yc=Line; Xc= Column or Editor.CurPos else  Xc,Yc = SimSU.Editor_MouseSelect.MouseToText() end
  local Yb=Yc; local Ye= St==1 and Yc<Editor.Lines and Yc+1 or Yc
  Editor.Pos(1,1,Yc); local s=Editor.Value
  local Xb=1; local Xe= Yb~=Ye and 1 or s:len()+1
  Editor.Pos(1,1,Yb); Editor.Pos(1,2,Xb); Editor.Sel(St+1,0); Editor.Pos(1,1,Ye); Editor.Pos(1,2,Xe); Editor.Sel(St+1,1)
  Editor.Pos(1,1,Yc) -- Координаты курсора в тексте.
  mmode(1,mmode(1,0),Editor.Pos(1,2,Xc)) -- Перерисуем экран. Двинем курсор для колорера.
end

function SimSU.Editor_MouseSelect.MouseSelect(Action,PostAct)
-- Функция работы мышкой с выделением в редакторе. © SimSU
  local NumClick=1
  local PA=true
  while NumClick do
    local Act= Action~=nil and ((Editor.Sel(0,4)>0 and SimSU.Editor_MouseSelect.ClickInSel() and Action["InSel"..NumClick]) or (Editor.Sel(0,4)>0 and not SimSU.Editor_MouseSelect.ClickInSel() and Action["NotSel"..NumClick]) or Action["Click"..NumClick])
    local PAct= PostAct~=nil and ((Editor.Sel(0,4)>0 and SimSU.Editor_MouseSelect.ClickInSel() and PostAct["InSel"..NumClick]) or (Editor.Sel(0,4)>0 and not SimSU.Editor_MouseSelect.ClickInSel() and PostAct["NotSel"..NumClick]) or PostAct["Click"..NumClick])
    if     Act=="SelNorm"  then SimSU.Editor_MouseSelect.MouseMove(1)
    elseif Act=="SelVert"  then SimSU.Editor_MouseSelect.MouseMove(2)
    elseif Act=="SelNone"  then SimSU.Editor_MouseSelect.MouseMove(0)
    elseif Act=="CorNorm"  then local Xb,Yb = SimSU.Editor_MouseSelect.ClickInSel(); SimSU.Editor_MouseSelect.MouseMove(1,Xb,Yb)
    elseif Act=="CorVert"  then local Xb,Yb = SimSU.Editor_MouseSelect.ClickInSel(); SimSU.Editor_MouseSelect.MouseMove(2,Xb,Yb)
    elseif Act=="WordNorm" then SimSU.Editor_MouseSelect.SelWord(1)
    elseif Act=="WordVert" then SimSU.Editor_MouseSelect.SelWord(2)
    elseif Act=="LineNorm" then SimSU.Editor_MouseSelect.SelLine(1)
    elseif Act=="LineVert" then SimSU.Editor_MouseSelect.SelLine(2)
    elseif Act=="Move"     then local PB=Editor.Set(2,1); SimSU.Editor_MouseSelect.MouseMove(0); Keys("CtrlM"); Editor.Set(2,PB); PA=false
    elseif Act=="Copy"     then local PB=Editor.Set(2,1); SimSU.Editor_MouseSelect.MouseMove(0); Keys("CtrlP"); Editor.Set(2,PB); PA=false
    end
    if     PA and PAct=="Copy"    then mf.clip(1,Editor.SelValue)
    elseif PA and PAct=="Cut"     then mf.clip(1,Editor.SelValue); editor.DeleteBlock() --Keys("CtrlD")
    elseif PA and PAct=="Add"     then mf.clip(2,Editor.SelValue)
    elseif PA and PAct=="CutAdd"  then mf.clip(2,Editor.SelValue); editor.DeleteBlock() --Keys("CtrlD")
    elseif PA and PAct=="Delete"  then editor.DeleteBlock() -- Keys("CtrlD")
    elseif PA and PAct=="Paste"   then Keys("CtrlV")
    elseif PA and PAct=="Replace" then s=Editor.SelValue; editor.DeleteBlock() Keys("CtrlV"); mf.clip(1,s)
    end
    local VK=mf.waitkey(Timing)
    NumClick= VK:find("Click",1,true) and NumClick+1 or nil
  end
end;
-------------------------------------------------------------------------------
if not Macro then return {Editor_MouseSelect=SimSU.Editor_MouseSelect} end

local ok, mod = pcall(require,"SimSU.Editor_MouseSelect"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

for i=1,#S.Key do
Macro {area="Editor"; key=S.Key[i]; description=M.Descr[i]; condition=SimSU.Editor_MouseSelect.Condition;
  action=function() SimSU.Editor_MouseSelect.MouseSelect(S.Action[i],S.PostAct[i]) end;
}
end
