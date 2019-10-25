-- Integrity Checker by Ariman
--
-- Скрипт решает две задачи - вызов главного меню плагина и проверку хэшей
-- с подавлением записи об этом в историю (без мусора оно как спокойнее).
-- Вторая его функция добавлена чтобы вышвырнуть запись из БД ассоциаций
-- ибо там у всех и без того зоопарка хватает. Перед выполнением макроса
-- проверяется расширение файла и коли он не пройдёт проверку, то просто
-- будет молча проигнорирован.
--
-- Ну а с возможностями управления плагином - как всегда, хочется больше,
-- но у плагина GUID-о не хватает. Я бы хотел иметь GUID для для пунктов
-- создания хэшей, сравнения панелей и проверки через буфер обмена чтобы
-- не городить капризный многоэтажный огород с выбором пунктов диалога,
-- но и набор команд управления меня бы полностью устроил...
--
-- Макрос специально назначен на Alt-H чтобы не перекрывал функционал хоткея
-- Ctrl-H - 'Убрать/показать файлы с атрибутом "Скрытый" и "Системный"' Far-а
-- (см. Справку Far-а: "Клавиатурные команды" - "Команды управления панелями"
-- раздел "Команды файловой панели").
--
-- VictorVG @ VikSoft.Ru/
--
-- v1.0 - initial version
-- Wds Jan 15 02:16:30 +0300 2014
-- v1.1 - refactoring
-- Mon Jun 15 06:32:20 +0300 2015
-- v1.1.1 - refactoring
-- Tue Jun 16 23:25:04 +0300 2015
-- v1.2 - рефакторинг
-- Mon Jun 22 05:40:42 +0300 2015
-- v1.2.1 - рефакторинг
-- Thu Aug 04 15:09:30 +0300 2016
-- v1.2.2 - добавлена поддержка SHA3-512
-- 07.11.2017 17:09:21 +0300
-- v1.3 - рефакторинг и срабатывание макроса на MsLClick по Double Click
-- 17.11.2017 16:12:57 +0300
-- v1.3.1 - рефакторинг
-- 17.11.2017 20:53:52 +0300
-- v1.4 - добавлен новый макрос на Alt-G - "Integrity Checker: calc hash for
-- the file under cursor" умеющий выводить хэш на экран, в буфер обмена ОС или
-- в хэш файл с именем файла и расширением зависящим от алгоритма в форматах
-- BSD UNIX или GNU Linux. Макрос написан в виде пошагового мастера с выводом
-- подсказок в заголовке диалога ввода. Одно символьные хоткеи команд мастера
-- указаны перед ":" или "-", например 1:CRC32,  G - GNU. Доступные команды в
-- списке разделены ";". Это сделано для снижения риска ошибок, и справка по
-- командам стала не нужна.
-- 18.03.2019 02:40:23 +0300
-- v1.4.1 - Исправим ошибку с пробелами в путях
-- 18.03.2019 10:35:23 +0300
-- v1.4.2 - уточнение v1.4.1
-- 18.03.2019 13:48:54 +0300
-- v1.4.3 - при непустой командной строке если курсор стоит на хэше спросим
-- оператора что делать? Ok - выполним командную строку, Canсel - проверим хэш.
-- 23.03.2019 22:41:07 +0300
-- v1.4.4 - мелкий рефакторинг, вопрос к пользователю задаётся по русски,
-- а чтобы LuaCheck не ругался на длинную строку в mf.msgbox вынесем сообщение
-- в отдельный оператор local так, чтобы вывелась только одна строка
-- 22.04.2019 17:53:12 +0300
-- v1.5.0 - рефакторинг, макрос Integrity Checker: calc hash for the file under
-- cursor переписано с использованием chashex(), реализован расчёт хешей для всех
-- или выбранных файлов в текущем каталоге;
-- 02.10.2019 08:58:55 +0300
-- v1.6.0 - расчёт хэшей для указанного пользователем файла или дерева каталогов, рефакторинг;
-- 07.10.2019 22:00:27 +0300
-- v1.7.0 - считаем хэши для всех файлов в локальном каталоге и его подкаталогах, рефакторинг;
-- 09.10.2019 19:01:24 +0300
-- v1.8.0 - автовыбора режима счёта "папка/файл" для UNC пути с коррекцией ошибок ввода и
-- проверкой их существания, хэши сохраняются в обрабатываемый UNC каталог, рефакторинг.
-- 13.10.2019 00:02:14 +0300

local ICId,ICMID="E186306E-3B0D-48C1-9668-ED7CF64C0E65","A22F9043-C94A-4037-845C-26ED67E843D1";
local Mask="/.+\\.(md5|sfv|sha(1|3|256|512)|wrpl)/i";
local MsB,MsF=Mouse.Button,Mouse.EventFlags;
local Msg="Командая строка не пуста, но под курсором хэш файл. Что выполнить? Команду: Ok или Проверку: Cancel";
local NmMsg,md,fn,dn,err,nm="Please, input path to file or folder",0;

local function PSplitU(p)

-- UNC функция разбора пути к файлам или каталогам с коррекцией ошибок ввода,
-- проверкой существования объекта и автовыбором режимов вызова chachex().
--
-- Логика анализатора:
--
-- если задан каталог, то считаем от него и dn == полный путь к нему,
-- fn == его имя, если задан файл, то dn == путь к его родительскому каталогу,
-- fn == его имя. Хэш файл если задана его запись всегда пишем в dn, а тот
-- указываем с полным путём чтобы знать куда писать.
--
-- аргументы вызова:
--
-- p - разбираемый путь к объекту;
--
-- возвращает:
--
-- dn - UNC путь к его родительскому каталогу;
-- fn - имя объекта для функции форматирования списка хэшей;
-- mod - режим работы chashex();
-- err - код ошибки:
--     0 - объект существует, но его доступность не проверяется, значения
--         dn, fn и mod действительны;
--     1 - объект не существует, значения dn, fn и mod не действительны;
  if (mf.substr(p,-1) == "/" or mf.substr(p,-1) == "\\") then p=mf.substr(p,0,-1) else p=tostring(p) end;
   fn=mf.substr(p,mf.rindex(p,"\\") + 1);
   if mf.fexist(p) then
       if bit64.band(mf.fattr(p),16) == 16 then  md=3; err=0;
         dn=p;
        else
         md=2; err=0;
         dn=mf.substr(p,0,mf.rindex(p,"\\"));
       end;
      else
       err=1; dn=tostring(""); fn=tostring(""); md=0;
     end
    return dn,fn,md,err
end;

local function chashex(hs,ft,md,nm,er)
-- Функция не работает с виртуальными панелями плагинов!
-- Возвращает посчитанный хэш или 0 при ошибке, или -1 если файл на
-- виртуальной панели плагина;
-- er - код ошибки ("флаг достоверности аргументов") возвращаемый PSplitU() или иным парсером путей;
-- ft - формат 1 == BSD, 0 == GNU, по умолчанию GNU;
-- hs - имя алгоритма;
-- md - режим счёта:
--    0 - файл под курсором,
--    1 - выбранные файлы или весь каталог без учёта подкаталогов;
--    2 - указанный файл;
--    3 - указанный каталог и его подкаталоги;
--    4 - локальный каталог и его подкаталоги;
-- nm - имя файла или каталога для кого считать в режимах 2 и 3
if APanel.Plugin then do return -1 end end;
local s,sv,i,j,name=tostring(""),APanel.CurPos,0,0,tostring("");
local function ch(hn,pth)
-- pth - UNC путь к проверяемому файлу;
-- hsh - имя алгоритма;
local ICId,Quiet="E186306E-3B0D-48C1-9668-ED7CF64C0E65",true;
   return mf.string(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..pth.."",Quiet));
end
 if md == 4 then
  local hr,lr,drr,dlr=tostring(""),tostring(""),0,far.GetDirList(APanel.Path),{};
   for i=1,#drr do
    dlr[i]=drr[i].FileName
     lr=mf.substr(dlr[i],#APanel.Path + 1)
      hr=ch(hs,dlr[i])
     if hr ~= "0" then if ft == 1 then s=s..hs.." ("..lr..") = "..hr.."\n" else s=s..hr.." *"..lr.."\n" end end;
   end;
 end;
 if err == 0 then
    if md == 3 then
     local hl,dr,dl=tostring(""),far.GetDirList(nm),{};
      for i=1,#dr do
       dl[i]=dr[i].FileName
       hl=ch(hs,dl[i])
       if hl ~= "0" then if ft == 1 then s=s..hs.." ("..mf.substr(dl[i],1 + #nm)..") = "..hl.."\n"
         else s=s..hl.." *"..mf.substr(dl[i],1 + #nm).."\n" end
        end;
      end
     end;
    if md == 2 then
     if ft == 1 then s=hs.." ("..fn..") = "..ch(hs,nm) else s=ch(hs,nm).." *"..fn; end;
    end;
 end;
 if md == 1  then
  if APanel.Selected then
  j=APanel.SelCount;
   for i=1,j,1 do Panel.SetPosIdx(0,i,1);
    if not APanel.Folder then
     if ft == 1 then s=s..hs.." ("..APanel.Current..") = "..ch(hs,APanel.Current).."\n";
       else s=s..ch(hs,APanel.Current).." *"..APanel.Current.."\n";
     end;
    end
   end
   Panel.SetPosIdx(0,sv);
   else
   Panel.SetPosIdx(0,1);
   i=APanel.ItemCount
   if APanel.Root then Panel.SetPosIdx(0,2); i=i - 1; j=2; else j=1; end;
   for i=j,i,1 do Panel.SetPosIdx(0,i);
    if not APanel.Folder then
     if ft == 1 then s=s..hs.." ("..APanel.Current..") = "..ch(hs,APanel.Current).."\n"
       else s=s..ch(hs,APanel.Current).." *"..APanel.Current.."\n" end;
    end;
   end;
   Panel.SetPosIdx(0,sv);
  end;
 end;
 if md == 0 then
   if not APanel.Root then
     if not APanel.Folder then
      if ft == 1 then s=hs.." ("..APanel.Current..") = "..ch(hs,APanel.Current)
        else s=ch(hs,APanel.Current).." *"..APanel.Current
      end;
     end;
   end;
  end;
  return mf.trim(s);
end;

Macro{
  id="C7BD288F-E03F-44F1-8E43-DC7BC7CBE4BA";
  area="Shell";
  key="Enter NumEnter MsM1Click";
  description="Integrity Checker: check integrity use check summ";
  priority=60;
  flags="EnableOutput";
  condition=function() return (mf.fmatch(APanel.Current,Mask)==1 and not (MsB==0x0001 and MsF==0x0001)) end;
  action=function()
  if not CmdLine.Empty then
 if mf.msgbox("Вопрос к пользователю:",Msg,0x00020000) == 1
        then
          Keys("Enter");
        else
          Far.DisableHistory(-1) Plugin.Command(ICId,APanel.Current);
        end;
    else
      Far.DisableHistory(-1) Plugin.Command(ICId,APanel.Current);
   end;
  end;
}

Macro{
  id="3E69B931-A38E-4119-98E9-6149684B01A1";
  area="Shell";
  key="AltH";
  priority=50;
  description="Integrity Checker: show menu";
  action=function()
    Far.DisableHistory(-1) Plugin.Menu(ICId,ICMID)
  end;
}

Macro{
  id="A3C223FD-6769-4A6E-B7E6-4CC59DE7B6A2";
  area="Shell";
  key="AltG";
  description="Integrity Checker: calc hash for the file under cursor";
  priority=50;
  condition=function() return not APanel.Plugin end;
  action=function()
  local mod,tg,sem,hsum,hash,arg,hs,ext,ft,name="c","f",0,"hashlist","",2,"MD5","md5",0,"";
  arg = mf.lcase(mf.prompt("1:CRC32;2:MD5;3:SHA1;4:SHA-256;5:SHA-512;6:SHA3-512;7:Whirlpool",nil,1,nil));
  tg = mf.lcase(mf.prompt("Target: D - display; C - Windows clipboard; F - hash file",nil,1,nil))
  mod = mf.lcase(mf.prompt("A - All; C - Cur. file; D - Cur. dir; S - Sel. files; U - UNC path;",nil,1,nil));
  if mf.lcase(mf.prompt("Format: B - BSD UNIX; G - GNU",nil,1,nil)) == "b" then ft=1; else ft=0; end;
   if arg == "1" then hs="CRC32"; ext=".sfv";
     elseif arg == "2" then hs="MD5"; ext=".md5";
      else
       if arg == "3" then hs="SHA1"; ext=".sha1";
         elseif arg == "4" then hs="SHA-256"; ext=".sha256";
          else
           if arg == "5" then hs="SHA-512"; ext=".sha512";
            elseif arg == "6" then hs="SHA3-512"; ext=".sha3";
             else
              if arg == "7" then hs="Whirlpool"; ext=".wrpl";
               else
                hs="SHA-256"; ext=".sha256";
               end;
              end;
           end;
        end;
 if mod == "u" then
     name=mf.prompt(NmMsg,nil,5,nil);
     PSplitU(name);
   if err == 0 then
    if md == 3 then
      hsum=dn.."\\".."hashsum"..ext;
     elseif md == 2 then
      hsum=dn.."\\"..mf.fsplit(fn,4)..ext;
    end;
   else
     far.Message("Integrity Checker: UNC path ".."\r"..name.."\r".."not exist or access denied or server is \nshutdown or user is not log-on!","Error","Ok","w",nil,nil)
   end;
  else
   if mod == "d" then
     md=4;
     dn=APanel.Path;
     fn=APanel.Path..hashsum..ext;
     er=0;
    elseif (mod == "a" or mod == "s") then
     md=1; dn=APanel.Path; hsum=APanel.Path.."hashsum"..ext; er=0;
    else
     md=0;
     dn=APanel.Path;
     hsum=APanel.Path..mf.fsplit(fn,4)..ext;
     er=0;
   end;
 end;
 if tg == "d" then
     far.Show(chashex(hs,ft,md,name,err))
  elseif tg == "c" then
     sem=mf.clip(5,1);
     mf.clip(1,chashex(hs,ft,md,name,err));
     if sem==2 then mf.clip(5,2) end;
  else
   if Panel.FExist(hsum,0) >= 1 then win.DeleteFile(hsum) end;
           hash=chashex(hs,ft,md,name,err);
           local sum = io.open(hsum,"wb")
          sum:write(hash);
        sum:flush();
      sum:close();
    end;
end;
}