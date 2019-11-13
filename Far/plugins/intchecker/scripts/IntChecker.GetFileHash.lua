-- Demo скрипт для вызова IntChecker v2.7.3 Git-4ccaf0dad или новее!
--
-- Параметры вызова: "команда", "алгоритм", "путь к файлу"
-- Пока поддерживается одна команда "gethash" - получить хеш одного файла
--
-- Список доступных алгоритмов:
-- crc32, md5, sha1, sha-256, sha-512, sha3-512, whirlpool
--
-- Регистр в названии команд и в названии алгоритмов не учитывается.
--
-- Плагин возвращает рассчитанный хеш файла, сообщения об ошибках отключены
-- заданием параметра Quiet = true.
--
-- Пользователь может прервать вычисления нажав ESC и подтвердив отмену операции
-- в диалоге плагина.

-- Пример вызова плагина для файла под курсором на активной панели

Macro {
  description="Calculate hash for the file under the cursor";
  area="Shell";
  key="CtrlShiftH";
  action=function()
  local Quiet,ICID = true,"E186306E-3B0D-48C1-9668-ED7CF64C0E65";
  far.Show (Plugin.SyncCall(ICID,"gethash","md5",APanel.Path0.."\\"..APanel.Current,Quiet))
  end;
}

-- Пример вызова плагина в прерываемом цикле для текущего каталога на активной панели

Macro {
  description="Calculate hash for current folder";
  area="Shell";
  key="AltShiftH";
  action=function()
  local Quiet,ICID,s0,sum = true,"E186306E-3B0D-48C1-9668-ED7CF64C0E65","","";
  for j=1,APanel.ItemCount do
   s0 = Plugin.SyncCall(ICID,"gethash","md5",Panel.Item(0,j,0),Quiet)
   if s0 == "userabort" then
    far.Show ("User press ESC button, all next operations is canceled.")
    break
   else
    sum = sum.."\n"..tostring(s0)
   end
  end;
   far.Show(sum)
 end
}