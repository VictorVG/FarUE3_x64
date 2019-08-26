-- Dialog/Editor/Viewer/Quick View show user menu v1.3 ©VictorVG
--
-- Идеи и благодарности:
--
-- Идея написать такой скрипт взята из темы "Пользовательское меню в редакторе"
-- на форуме Far http://forum.farmanager.com/viewtopic.php?f=4&t=9135 где по
-- сему поводу сломано не мало копий, а раз это возможно, то почему бы и нет?
--
-- Особая благодарность Shmuel Zeigerman за LuaMacro и функцию mf.usermenu
-- Евгению Рошалю и Far Group за Far Manager
--
-- Общее описание скрипта:
--
-- Вызываем пользовательское меню из редактора, вьера или диалога. Для
-- исключения конфликта со стандартными клавишами управления редактора/вьера
-- первый вызов скрипта происходит по CtrlF2, но если вы находясь в вызванном
-- меню снова нажмёте F2 будет вызвано главное меню Far.
--
-- Если необходим вызов меню для быстрого просмотра, просто раскоментируйте
-- макрос "меню для быстрого просмотра" удалив --[[ до и --]] после него.
--
-- Блокировка F2 для вызова общих меню возможна, но закоментирована.
-- Если понадобится просто раскоментируйте макрос "Block F2 in to user menu"
-- удалив --[[ до и --]] после него.
--
-- Имена файлов меню должны быть DlgMenu (DlgMenu.ini), EdtMenu (EdtMenu.ini),
-- VwrMenu (VwrMenu.ini) или QVMenu (QVMenu.ini). Иные скрипт не примет. Это
-- было сделано специально для того чтобы вынести в них из общих меню Far
-- инструменты вызываемые только в диалоге, редакторе, вюере и панели быстрого
-- просмотра. Меню для каждой области независимые, сначала вызывается локальное
-- меню из текущего каталога, а если его нет его можно создать, при повторном
-- нажатии CtrlF2 вызывается общее меню из %FARPROFILE%\Menus\ .
--
-- История версий
--
-- 04.08.2016 15:04:18 +0300 - v1.3.1 - адаптация к LuaMacro b580
--
-- 22.06.2015 16:54:53 +0300 - v1.3 - рефакторинг
--
-- 08.11.2014, 16:33:28 +0300, v1.2 - подключим и локальные меню а каталогах,
-- возможность блокировать вызов общих меню из пользовательских, рефакторинг.
--
-- 08.11.2014, 08:16:16 +0300, v1.1 - назначим каждой макрообласти своё меню
-- хранящееся в %FARPROFILE%\Menus\<MacroArea.ini> иначе бардак системе будет.
--
-- 08.11.2014, 06:17:00 +0300, v1.0 - первая версия.
--

-- Меню для диалогов
local Suff="/(Menu|Menu.ini)"
local DMNU="Dlg"..Suff;
local EMNU="Edt"..Suff;
local VMNU="Vwr"..Suff;
-- local QMNU="QV..Suff"; -- Please, uncomment if use Quick View menu

Macro{
  id="5A8D6457-785C-493B-9A09-E6E412437870";
  area="Dialog";
  key="CtrlF2";
  description="Dialog: show local menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(2,DMNU) end;
}

Macro{
  id="9598B728-3041-421A-A080-C18D115336F4";
  area="Dialog";
  key="CtrlF2";
  description="Dialog: show common user menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(3,DMNU) end;
}

-- Меню для редактора

Macro{
  id="1B6B30EE-26ED-49C1-81DC-F292564E1456";
  area="Editor";
  key="CtrlF2";
  description="Editor: show local menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(2,EMNU) end;
}

Macro{
  id="64740287-7BC5-498A-A78A-96DD3AD2DFB7";
  area="Editor";
  key="CtrlF2";
  description="Editor: show common user menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(3,EMNU) end;
}

-- Меню для вьера

Macro{
  id="78F01FC6-E1B9-46EC-B76A-E1F7BD98F885";
  area="Viewer";
  key="CtrlF2";
  description="Viewer: show local menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(2,VMNU) end;
}

Macro{
  id="7D7B6226-4F80-451D-9B16-DBB72DA2170D";
  area="Viewer";
  key="CtrlF2";
  description="Viewer: show common user menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(3,VMNU) end;
}

--[[

-- Меню для быстрого просмотра

Macro{
  id="0364D791-FF3A-469F-95ED-A0203909DC72";
  area="QView";
  key="CtrlF2";
  description="Quick View: show local menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(2,QMNU) end;
}

Macro{
  id="4EF3F55A-7AF5-4923-9C41-103464E10D2A";
  area="QView";
  key="CtrlF2";
  description="Quick View: show common user menu";
  flags="NoSendKeysToPlugins";
  action=function() mf.usermenu(3,QMNU) end;
}

--]]

--[[

-- Блокировка F2 в пользовательских меню для предотвращения ошибок

Macro{
  id="EF1DC43D-ABBD-43BA-86FA-61211ACD09F7";
  area="MainMenu UserMenu";
  key="F2";
  description="Block F2 in to user menu";
  flags="NoSendKeysToPlugins";
  action=function() end;
}

--]]
