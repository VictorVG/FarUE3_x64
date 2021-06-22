--[[ Скрипт позволяет войти в тарбалл и выйти из него из любого вложенного каталога,
     распаковать на пассивную панель текущий или выбранные тарбаллы не открывая их.

     Тарбалл это сжатый внешним компрессором контейнер tar представляющий из себя
     несжатый файл содержащий образ фрагмента файловой системы от точки монтирования
     контейнера с учётом сим- и хардлинков, и прав доступа к файлам и каталогам.
     В Windows нет встроенных инструментов для работы с UNIX файлами такими как тарбалл,
     и в большинстве её архиваторов они отображаются как вложенные архивы, где несжатый
     контейнер tar для упрощения так же интерпретируется как архив.

     За операцию "войти в тарбалл" отвечает макрос "Open tarball" который обеспечивает
     позиционирование курсора сразу на корневой каталог вложенного контейнера tar.

     Обратная операция "выйти из тарбалла" реализована макросом "CdUp tarball" при
     срабатывании которого происходит выход в каталог где находится тарблл независимо
     от того в какой точке дерева каталогов тарбалла мы находимся.

     За операции распаковки отвечает макрос "Unpack tarball", а собственно распаковка
     производится плагином ArcLite.

     В отличии от своего аналога Shell_DeepTarball.lua (c) siberia-man данный скрипт
     позволяет выйти в файловую панель из любого подкаталога тарбалла, в т.ч. когда имя
     тарбалла имеет сокращённый вид типа *.tbz, *.tgz, *.tlz, *.trz, *.txz, *.tz что
     часто встречается в UNIX системах, например в портах FreeBSD UNIX бинарные пакеджи
     имеют имена вида *.tbz или *.txz.

     ToDo:

     Для корректной работы скрипта если используются несколько архиваторных плагинов
     (например ArcLite и MultiArc) необходимо чтобы с архивами tar работал только один из
     них. У второго плагина надо отключить для Tar операции на CtrlPgDn. Идеи по устранению
     данного недостатка у меня есть, со временем и его устраню.

     VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2021)

     История версий:

     v1.0, 19.11.2018 07:41:29 +0300 - первая публичная версия, написана "с нуля" и с
     учётом основных недостатков Shell_DeepTarball.lua.
     v1.0.1, 13.01.2019 10:09:10 +0300 - UTF-8
     v1.0.2, 19.06.2021 12:49:10 +0300 - распаковка по Shift-F2 тарбаллов под курсором в
     "один заход" на пассивную панель. Копирайт.
     v1.0.3, 21.06.2021 07:47:41 +0300, добавлена распаковка выбранных трабалов в отдельные
     каталоги на пассивную панель, рефакторинг.
     v1.0.4, 22.06.2021 07:43:46 +0300, рефакторинг.
--]]

local Mask="/.+\\.(t(bz|bz2|gz|lz|rz|xz|z)|tar\\.(gz|bz2|lz|lzma|rz|xz|z))/i";
local Msk="/.+(tar)/i";

Macro {
area = "Shell";
key = "Enter CtrlPgDn";
priority=60;
description = "Open tarball";
condition = function() return (mf.fmatch(APanel.Current,Mask)==1 and not APanel.Folder) end;
action = function() Far.DisableHistory(-1); Keys("CtrlPgDn Down CtrlPgDn")
 end;
}

Macro {
area = "Shell";
key = "CtrlPgUp";
priority=60;
description = "CdUp tarball";
condition = function() return
 (APanel.Plugin and (mf.fmatch(APanel.HostFile,Mask)==1 or mf.fmatch(APanel.HostFile,Msk)==1 )) end;
action = function() Far.DisableHistory(-1);
  local m1="/.+\\.(tbz|tbz2|tgz|tlz|trz|txz|tz)/i";
       while (mf.fmatch(APanel.HostFile,Msk)==1) do Keys("Home Enter") end;
        if mf.fmatch(APanel.HostFile,m1)==1 then Keys("Home Enter") end;
 end;
}

Macro{
  area="Shell";
  key="ShiftF2";
  priority=60;
  description="Unpack tarball";
  condition=function() return not APanel.Folder end;
  action=function()
  Far.DisableHistory(-1);
  local ArcID,m1,nm,var,tm = "65642111-AA69-4B84-B4B8-9249579EC4FA","/.+\\.(tbz|tbz2|tgz|tlz|trz|txz|tz)/i","","","";
  local function fnm(fn)
   if mf.fmatch(fn,m1)==1 then
    nm = mf.fsplit(fn,4)..".tar"
   else
    nm = mf.fsplit(fn,4)
   end
    return nm
  end
  if APanel.Selected then
   local ic = Panel.SetPosIdx(0,0)
    for i=1,APanel.SelCount do
     Panel.SetPosIdx(0,i,1)
     if mf.fmatch(APanel.Current,Mask) == 1 then
      if var == "" then
       var = Panel.Item(0,APanel.Current,0)
      else
       var =var.." "..Panel.Item(0,APanel.Current,0)
      end
      if tm == "" then
       tm = win.GetEnv("TEMP").."\\"..fnm(APanel.Current)
      else
       tm = tm.." "..win.GetEnv("TEMP").."\\"..fnm(APanel.Current)
      end
     end
    end
    Panel.SetPosIdx(0,ic)
    Plugin.Command(ArcID,"x -ie:y -o:o -da:n -sd:n "..var.." "..win.GetEnv("TEMP"))
    Plugin.Command(ArcID,"x -ie:y -o:o -da:y -sd:y "..tm.." "..PPanel.Path)
   elseif mf.fmatch(APanel.Current,Mask)==1 then
   local cmda = "x -ie:y -o:o -sd:n "
   Plugin.Command(ArcID,cmda.."-da:n "..APanel.Current.." "..win.GetEnv("TEMP"))
   Plugin.Command(ArcID,cmda.."-da:y "..win.GetEnv("TEMP").."\\"..fnm(APanel.Current).." "..PPanel.Path)
  end
end;
}