-------------------------------------------------------------------------------
--                 Подсказки к файлам. © SimSU
-------------------------------------------------------------------------------
-- Требуется плагин FarHints © Максим Русов (FarHints.dll).
-------------------------------------------------------------------------------
-- После консультации с shmuel устранён конфликт хоткеев в управлении размером 
-- хинта с клавиатуры путём замены Num+/Num- на RAltUp/RAltDown. Иначе выделение
-- файлов и каталогов работает только после гашения хинта - конфликт. /VictorVG/

local GUIDfarhints = "CDF48DA0-0334-4169-8453-69048DD3B51C"

Macro {
area="Shell Tree"; key="Space"; flags="EmptyCommandLine"; description="Показать подсказку (плагин FarHints © Максим Русов) © SimSU";
condition = function() return Plugin.Exist(GUIDfarhints) end;
priority = 0;
action = function()
  if not Plugin.Call(GUIDfarhints,"Hide") then
    Plugin.Call(GUIDfarhints,"Show",2)
  end
end;
}

Macro {
area="Shell Tree"; key="Esc"; description="Скрыть подсказку(плагин FarHints © Максим Русов), очистить командную строку, скрыть панели © SimSU";
condition = function() return Plugin.Exist(GUIDfarhints) end;
priority = 55;
action = function()
  if not Plugin.Call(GUIDfarhints,"Hide") then
    if CmdLine.Empty then
      Keys("CtrlO")
    else
      Keys("Esc")
    end
  end
end;
}

Macro {
area="Shell Tree"; key="Alt"; description="Показать/скрыть подсказку (плагин FarHints © Максим Русов) © SimSU";
condition = function() return Plugin.Exist(GUIDfarhints) end;
priority=99;
condition= function() return win.GetEnv("FarHint") == "1" end;
action = function()
  Plugin.Call(GUIDfarhints,"Hide")
end;
}

Macro {
area="Shell Tree"; key="Alt"; description="Показать/скрыть подсказку (плагин FarHints © Максим Русов) © SimSU";
condition = function() return Plugin.Exist(GUIDfarhints) end;
priority = 49;
action = function()
  Plugin.Call(GUIDfarhints,"Show",2)
end;
}

Macro {
 area="Shell Tree"; key="RAltUp RAltDown"; description="FarHints: Keyboard change hint size (plugin FarHints © Максим Русов) © Max Rusov";
 condition= function() return win.GetEnv("FarHint") == "1" end;
 priority=99;
 action = function()
 Plugin.Call(GUIDfarhints, "Size", akey(2) == "RAltUp" and 1 or -1)
 end;
}

Macro {
area="Shell Tree"; key="MsWheelUp MsWheelDown"; description="FarHints: Mouse change hint size (plugin FarHints © Максим Русов) © Max Rusov";
priority=99;
condition= function() return win.GetEnv("FarHint") == "1" end;
action = function()
  Plugin.Call(GUIDfarhints, "Size", akey(2):sub(-2) == "Up" and 1 or -1)
end;
} 
