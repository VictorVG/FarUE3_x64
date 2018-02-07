    local MEDIA_INFO_ID = "919C1FC6-A571-4642-99DF-BDACE840ED18"

    local function image_media_info()
       if not APanel.Folder then
          Keys("F11")
                if Menu.Select("Media Info",2) > 0 then
                   Keys("Enter")
                else
                   Keys("Esc")
                end
         end
    end

    local function image_media_condition()
       return (Dlg.Id == MEDIA_INFO_ID)
    end

    local function image_media_prev()
       if not APanel.Bof and Panel.Item(0,Panel.SetPosIdx(0,0)-1,0)~=".." then
          Keys("Esc Up")
          image_media_info()
       end
    end

    local function image_media_next()
       if not APanel.Eof then
          Keys("Esc Down")
          image_media_info()
       end
    end

    -- Вызов плагинов
    Macro { area="Shell Search"; key="CtrlAltM"; description="Get MEdiaInfo"; action=image_media_info; }

    -- Перемещение между файлами
    Macro { area="Dialog"; key="Up"; description="Navigation Up"; condition=image_media_condition; action=image_media_prev; }
    Macro { area="Dialog"; key="Down"; description="Navigation Down"; condition=image_media_condition; action=image_media_next; }