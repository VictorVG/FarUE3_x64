local font = {
  name = 'Courier New',
  size = 10
}
local margin = {
  x = 10,
  y = 10
}
local F = far.Flags
local ffi = require('ffi')
local C = ffi.C
local winspool = ffi.load('winspool.drv')
local safe_cdef
safe_cdef = function(def)
  return pcall(ffi.cdef, def)
end
safe_cdef([[  typedef struct _PRINTER_INFO_1W {
    DWORD Flags;
    LPWSTR pDescription;
    LPWSTR pName;
    LPWSTR pComment;
  } PRINTER_INFO_1W,*PPRINTER_INFO_1W,*LPPRINTER_INFO_1W;
]])
safe_cdef([[  typedef struct _DOCINFOW {
    int cbSize;
    LPCWSTR lpszDocName;
    LPCWSTR lpszOutput;
    LPCWSTR lpszDatatype;
    DWORD fwType;
  } DOCINFOW,*LPDOCINFOW;
]])
safe_cdef([[typedef struct tagPOINT {
  LONG x;
  LONG y;
} POINT,*PPOINT,*NPPOINT,*LPPOINT;
]])
ffi.cdef([[WINBOOL EnumPrintersW(DWORD Flags,LPWSTR Name,DWORD Level,LPBYTE pPrinterEnum,DWORD cbBuf,LPDWORD pcbNeeded,LPDWORD pcReturned);
WINBOOL GetDefaultPrinterW(LPWSTR pszBuffer,LPDWORD pcchBuffer);
void* CreateDCW(LPCWSTR pwszDriver,LPCWSTR pwszDevice,LPCWSTR pszPort,void* pdm);
WINBOOL DeleteDC(void* hdc);
int GetDeviceCaps(void* hdc,int index);
int SetMapMode(void* hdc,int iMode);
WINBOOL SetViewportOrgEx(void* hdc,int x,int y,LPPOINT lppt);
int StartDocW(void* hdc,const DOCINFOW *lpdi);
int EndDoc(void* hdc);
int StartPage(void* hdc);
int EndPage(void* hdc);
void* CreateFontW(int cHeight,int cWidth,int cEscapement,int cOrientation,int cWeight,DWORD bItalic,DWORD bUnderline,DWORD bStrikeOut,DWORD iCharSet,DWORD iOutPrecision,DWORD iClipPrecision,DWORD iQuality,DWORD iPitchAndFamily,LPCWSTR pszFaceName);
WINBOOL DeleteObject(void* ho);
void* SelectObject(void* hdc,void* h);
WINBOOL TextOutW(void* hdc,int x,int y,LPCWSTR lpString,int c);
int lstrlenW(wchar_t* lpString);
]])
local PRINTER_ENUM_LOCAL = 0x00000002
local PRINTER_ENUM_CONNECTIONS = 0x00000004
local MM_LOMETRIC = 2
local VERTSIZE = 6
local VERTRES = 10
local FW_DONTCARE = 0
local DEFAULT_CHARSET = 1
local OUT_DEFAULT_PRECIS = 0
local CLIP_DEFAULT_PRECIS = 0
local DEFAULT_QUALITY = 0
local FIXED_PITCH = 1
local FF_MODERN = 48
local sizemul = 10
font.size = math.floor(font.size * 25.4 * sizemul / 72)
margin.x = margin.x * sizemul
margin.y = margin.y * sizemul
local ToWChar
ToWChar = function(str)
  str = win.Utf8ToUtf16(str)
  local result = ffi.new('wchar_t[?]', #str / 2 + 1)
  ffi.copy(result, str)
  return result
end
local ToUtf8
ToUtf8 = function(str)
  return win.Utf16ToUtf8(ffi.string(str, 2 * C.lstrlenW(str)))
end
local DefaultPrinter
DefaultPrinter = function()
  local size = ffi.new('DWORD[1]')
  winspool.GetDefaultPrinterW(ffi.NULL, size)
  local name = ffi.new('wchar_t[?]', size[0])
  winspool.GetDefaultPrinterW(name, size)
  return ToUtf8(name)
end
local Print
Print = function()
  local ei = editor.GetInfo()
  if ei then
    local current, total = 1, ei.TotalLines
    local selection = editor.GetSelection()
    if selection then
      current, total = selection.StartLine, selection.EndLine
    end
    local getline
    getline = function(no)
      local line = editor.GetString(F.CURRENT_EDITOR, no, 0)
      if selection then
        return line.StringText:sub(line.SelStart, line.SelEnd)
      else
        return line.StringText
      end
    end
    while 0 == (getline(total)):len() do
      total = total - 1
    end
    local size = ffi.new('DWORD[1]')
    local count = ffi.new('DWORD[1]')
    winspool.EnumPrintersW(PRINTER_ENUM_LOCAL + PRINTER_ENUM_CONNECTIONS, ffi.NULL, 1, ffi.NULL, 0, size, count)
    if size[0] > 0 then
      local printers_raw = ffi.new('BYTE[?]', size[0])
      if 0 ~= winspool.EnumPrintersW(PRINTER_ENUM_LOCAL + PRINTER_ENUM_CONNECTIONS, ffi.NULL, 1, printers_raw, size[0], size, count) then
        local printers_win = ffi.cast('PRINTER_INFO_1W*', printers_raw)
        local printers = { }
        local defname = DefaultPrinter()
        for ii = 0, count[0] - 1 do
          local name = ToUtf8(printers_win[ii].pName)
          local def = name == defname
          table.insert(printers, {
            value = printers_win[ii].pName,
            text = name,
            checked = def,
            selected = def
          })
        end
        local printer = far.Menu({
          Id = win.Uuid('3a557a89-e862-4e9e-83b2-c01a1bae4a54')
        }, printers)
        if printer then
          local dc = C.CreateDCW(ffi.NULL, printer.value, ffi.NULL, ffi.NULL)
          C.SetMapMode(dc, MM_LOMETRIC)
          C.SetViewportOrgEx(dc, 0, (C.GetDeviceCaps(dc, VERTRES)), ffi.NULL)
          local pageheight = sizemul * C.GetDeviceCaps(dc, VERTSIZE)
          local docinfo = ffi.new('DOCINFOW')
          docinfo.cbSize = ffi.sizeof(docinfo)
          docinfo.lpszDocName = ToWChar(ei.FileName)
          C.StartDocW(dc, docinfo)
          local font_win = C.CreateFontW(font.size, 0, 0, 0, FW_DONTCARE, 0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FIXED_PITCH + FF_MODERN, ToWChar(font.name))
          local linesperpage = math.floor((pageheight - 2 * margin.y) / font.size)
          local pages = math.ceil((total - current + 1) / linesperpage)
          for ii = 1, pages do
            C.StartPage(dc)
            local oldfont = C.SelectObject(dc, font_win)
            for jj = 1, linesperpage do
              local line = getline(current)
              C.TextOutW(dc, margin.x, pageheight - margin.y - (jj - 1) * font.size, (ToWChar(line)), line:len())
              current = current + 1
              if current > total then
                break
              end
            end
            C.SelectObject(dc, oldfont)
            C.EndPage(dc)
          end
          C.EndDoc(dc)
          C.DeleteObject(font_win)
          return C.DeleteDC(dc)
        end
      end
    end
  end
end
return Macro({
  area = 'Editor',
  key = 'AltF5',
  description = 'Print text from editor',
  action = Print
})