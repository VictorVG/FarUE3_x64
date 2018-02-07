Плагин для Far: LUA Format Block
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Автор: ladserg
e-mail: ladserg@mail.com
Guid: "23C16506-38EE-48D1-9874-CD1736408867"
Plugring: www: http://plugring.farmanager.com/plugin.php?pid=945&l=ru
Обсуждение: http://forum.farmanager.com/viewtopic.php?f=5&t=8912
Анонс: http://forum.farmanager.com/viewtopic.php?f=11&t=8911&p=122605

УСЛОВИЯ РАСПРОСТРАНЕНИЯ: FreeWare.

ВНИМАНИЕ: Автор не несет никакой  ответственности  за  правильную  или
неправильную работу этого плагина.

Плагин позволяет форматировать абзацы,  выравнивая  текст  по  правому
краю, левому краю, по середине, по ширине (последняя строка по  левому
краю), по  ширине  (включая  последнюю  строку),  при  этом  позволяет
обнаруживать абзацы по новой строке, по пустой строке, по отступу.

Для любителей быстрых клавиш организована возможность запуска  плагина
без диалога с последними сохраненными настройками (или настройками  по
умолчанию, если настройки не сохранялись). Для запуска в таком  режиме
нужно в качестве первого параметра передать плагину единицу:

    Plugin.Call(Guid, 1)

Полный макрос вызова плагина может выглядеть так:

    local Guid="23C16506-38EE-48D1-9874-CD1736408867"
    Macro {
        description="LUA Format Block";
        area="Editor"; key="CtrlB";
        action=function()
            Plugin.Call(Guid)
        end;
    }

    Macro {
        description="LUA Format Block(auto)";
        area="Editor"; key="CtrlShiftB";
        action=function()
            Plugin.Call(Guid, 1)
        end;
    }

Данный  макрос  вы  сможете  найти  в  каталоге   плагина,   в   файле
Addons\Macros\Editor.LFBlock.lua .
