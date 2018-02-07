-- 2useven10 on Tue 07 Nov, 2017 10:52
-- Макрос переписан - оптимизация, автодетект 1251 и 866, исправление выделенного текста.

    local RUS_OEMCP, RUS_ACP, LATIN1_CP = 866, 1251, 28591

    local acp_table =
    { nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,'‹', nil,nil,nil,nil --80
    , nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,'›', nil,nil,nil,nil --90
    , nil,nil,nil,nil, nil,nil,nil,nil, 'Ё','©',nil,'«', nil,nil,nil,nil --A0
    , nil,nil,nil,nil, nil,nil,nil,nil, 'ё','№',nil,'»', nil,nil,nil,nil --B0
    , 'А','Б','В','Г', 'Д','Е','Ж','З', 'И','Й','К','Л', 'М','Н','О','П' --C0
    , 'Р','С','Т','У', 'Ф','Х','Ц','Ч', 'Ш','Щ','Ъ','Ы', 'Ь','Э','Ю','Я' --D0
    , 'а','б','в','г', 'д','е','ж','з', 'и','й','к','л', 'м','н','о','п' --E0
    , 'р','с','т','у', 'ф','х','ц','ч', 'ш','щ','ъ','ы', 'ь','э','ю','я' --F0
    }
    local oemcp_table =
    { 'А','Б','В','Г', 'Д','Е','Ж','З', 'И','Й','К','Л', 'М','Н','О','П' --80
    , 'Р','С','Т','У', 'Ф','Х','Ц','Ч', 'Ш','Щ','Ъ','Ы', 'Ь','Э','Ю','Я' --90
    , 'а','б','в','г', 'д','е','ж','з', 'и','й','к','л', 'м','н','о','п' --A0
    , nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil --B0
    , nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil --C0
    , nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil, nil,nil,nil,nil --D0
    , 'р','с','т','у', 'ф','х','ц','ч', 'ш','щ','ъ','ы', 'ь','э','ю','я' --E0
    , 'Ё','ё',nil,nil, nil,nil,nil,nil, nil,nil,nil,nil, '№',nil,nil,nil --F0
    }

    local function FixSelClipboard(save_clipboard, ctrl_ins, shift_ins)
      local orig_clipboard = save_clipboard and far.PasteFromClipboard() or nil
      if ctrl_ins then Keys('CtrlIns') end
      local text = win.Utf8ToUtf16(far.PasteFromClipboard())
      local ansi7, ucs2, only_oemcp, only_acp = true, false, true, true
      for i=1,#text,2 do
        local b1, b2 = string.byte(text,i), string.byte(text, i+1)
        if b2 ~= 0 then
          ucs2 = true
          break
        end
        if b1 > 127 then
          ansi7 = false
          only_acp = only_acp and acp_table[b1-128+1]
          only_oemcp = only_oemcp and oemcp_table[b1-128+1]
        end
      end
      if not ansi7 and not ucs2 then
        local cp=RUS_ACP; if not only_acp and only_oemcp then cp=RUS_OEMCP end
        far.CopyToClipboard(win.Utf16ToUtf8(win.MultiByteToWideChar(win.WideCharToMultiByte(text, LATIN1_CP), cp)))
      end
      if shift_ins then Keys('ShiftIns') end
      if orig_clipboard then far.CopyToClipboard(orig_clipboard) end
    end

    Macro {
      description="вставка кривого юникода из буфера обмена";
      area="Common"; key="CtrlShiftV";
      action = function()
        FixSelClipboard(false, false, true)
      end;
    }

    Macro {
      description="исправление выделенного кривого юникода в редакторе";
      area="Editor"; key="CtrlShiftV"; flags="EVSelection";
      action = function()
        FixSelClipboard(true, true, true)
      end;
    }

    Macro {
      description="исправление выделенного кривого юникода в диалоге";
      area="Dialog"; key="CtrlShiftV";
      condition = function()
        return Dlg.ItemType==far.Flags.DI_EDIT and Object.Selected
      end;
      action = function()
        FixSelClipboard(true, true, true)
      end;
    }

    Macro {
      description="исправление выделенного кривого юникода в комстроке";
      area="Shell"; key="CtrlShiftV"; flags="NotEmptyCommandLine";
      condition = function()
        return CmdLine.Selected
      end;
      action = function()
        FixSelClipboard(true, true, true)
      end;
    }