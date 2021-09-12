    local ffi = require("ffi")
    local nls = ffi.load("normaliz.dll")
    local NormalizationC, ERROR_SUCCESS, RenameGUID = 1, 0, '89664EF4-BB8C-4932-A8C0-59CAFD937ABA'

    local ModifiedToCombine = false -- true
    local m = "ˋ´ˊˆ˜¯ˉ˘˙¨˚˝ˇ" -- modified as single characters
    local c = "̀́́̂̃̄̄̆̇̈̊̋̌" -- combined modifiers
    local M = win.Utf8ToUtf16(m)
    local C = win.Utf8ToUtf16(c)

    ffi.cdef([[
    int NormalizeString(int NormForm, const wchar_t* src, int slen, wchar_t* dst, int dlen);
    BOOL IsNormalizedString(int NormForm, const wchar_t* name, int len);
    DWORD GetLastError(void);
    void SetLastError(DWORD);
    ]])

    local function need_normalize(name)
      local need = false
      if (nls ~= nil and #name > 0) then
        local namew = win.Utf8ToUtf16(name .. "\0")
        local ptrw = ffi.new("wchar_t[?]", #namew/2)
        ffi.copy(ptrw, namew)
        ffi.C.SetLastError(ERROR_SUCCESS)
        local norm = nls.IsNormalizedString(NormalizationC, ptrw, -1)
        local errc = ffi.C.GetLastError()
        need = norm ~= 1 and errc == ERROR_SUCCESS
        if not need and ModifiedToCombine then
          for i=1,#namew-2,2 do
            local b, e = string.find(M, string.sub(namew,i,i+1), nil, true)
            if b and b%2 == 1 and e == b+1 then
              need = true
              break
            end
          end
        end
      end
      return need
    end

    local function normalize(name)
      local nname = ""
      if (nls ~= nil and #name > 0) then
        local namew = win.Utf8ToUtf16(name)
        if ModifiedToCombine then
          for i=1,#namew-2,2 do
            local b, e = string.find(M, string.sub(namew,i,i+1), nil, true)
            if b and b % 2 == 1 and e == b+1 then
              namew = string.sub(namew,1,i-1) .. string.sub(C,b,e) .. string.sub(namew,i+2)
            end
          end
        end
        local ptrw = ffi.new("wchar_t[?]", #namew/2)
        ffi.copy(ptrw, namew)
        local outw = ffi.new("wchar_t[?]", #namew)
        local len = nls.NormalizeString(NormalizationC, ptrw, #namew/2, outw, #namew)
        if len > 0 then
          nname = win.Utf16ToUtf8(ffi.string(outw, len*2))
        end
      end
      return nname
    end

    Macro {
      area="Shell"; key="CtrlShiftN"; flags="NoPluginPanels"; description="Rename with NFC normalization";
      condition = function()
        return APanel.FilePanel and APanel.Visible and need_normalize(APanel.Current)
      end;
      action = function()
        local nname = normalize(APanel.Current)
        Keys 'ShiftF6'
        if Area.Dialog and Dlg.Id == RenameGUID and #nname > 0 then
          Keys 'CtrlY'
          print(nname)
          --Keys 'Enter'
        end
      end;
    }

    Macro {
      area="Shell"; key="CtrlAltN"; flags="NoPluginPanels"; description="Rename All/Selected with NFC normalization";
      condition = function()
        return APanel.FilePanel and APanel.Visible
      end;
      action = function()
        local n_all, n_sel, n_fnd = APanel.ItemCount, APanel.SelCount, 0
        local found = {};
        for i = 1, n_all do
          local item = panel.GetPanelItem(nil, 1, i)
          if item then
            if n_sel <= 0 or band(item.Flags, far.Flags.PPIF_SELECTED) ~= 0 then
              if need_normalize(item.FileName) then
                n_fnd = n_fnd + 1;
                found[n_fnd] = item.FileName
                if n_sel > 0 and n_fnd >= n_sel then break end
              end
            end
          end
        end
        if n_fnd > 0 then
          for i = 1, #found do
            win.RenameFile(APanel.Path .. "\\" .. found[i], APanel.Path .. "\\" .. normalize(found[i]))
          end
          panel.RedrawPanel(nil, 1)
        end
      end;
    }