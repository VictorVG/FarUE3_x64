--[[ Скрипт позволяет войти в тарбалл и выйти из него из любого вложенного каталога.
     За каждую операцию отвечает свой макрос. Тарбалл это сжатый внешним компрессором
     контейнер tar представляющий из себя несжатый файл содержащий образ фрагмента
     файловой системы от точки монтирования контейнера с учётом сим- и хардлинков,
     и прав доступа к файлам и каталогам. В Windows нет встроенных инструментов для
     работы с UNIX файлами такими как тарбалл, и в большинстве её архиваторов они
     отображаются как вложенные архивы, где несжатый контейнер tar для упрощения так
     же интерперетируется как архив.

     За операцию "войти в тарбалл" отвечает макрос "Open tarball" который обеспечивает
     позиционирование курсора сразу на корневой каталог вложенного контейнера tar.

     Обратная операция "выйти из тарбалла" реализована макросом "CdUp tarball" при
     срабатывании которого происходит выход в каталог где находится тарблл независимо
     от того в какой точке дерева каталогов тарбалла мы находимся.

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

     VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2018)

     История версий:

     v1.0, 19.11.2018 07:41:29 +0300 - первая публичная версия, написана "с нуля" и с
     учётом основных недостатков Shell_DeepTarball.lua.
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