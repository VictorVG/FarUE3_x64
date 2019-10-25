-- Demo скрипт для вызова плагина
--
-- Параметры вызова: "команда", "алгоритм", "путь к файлу"
-- Поддерживается пока одна команда "gethash" - получить хеш одного файла
-- Список доступных алгоритмов:
-- crc32, md5, sha1, sha-256, sha-512, sha3-512, whirlpool
-- Регистр в названии команд и в названии алгоритмов не учитывается.
-- Вызов возвращает расчитанный хеш файла, сообщения об ошибках отключены.

Macro {
  description="Calculate hash for the file under the cursor";
  area="Shell";
  key="CtrlShiftH";
  action=function()
  local Quiet,ICID=true,"E186306E-3B0D-48C1-9668-ED7CF64C0E65";
  far.Show (Plugin.SyncCall(ICID,"gethash","md5",APanel.Path0.."\\"..APanel.Current,Quiet))
  end;
}