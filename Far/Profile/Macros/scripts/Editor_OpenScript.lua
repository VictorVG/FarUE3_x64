Event
{
  group="EditorEvent"; filemask="*.lua,*.moon";
  action=function(id,event,param)
    if event==far.Flags.EE_READ then
      editor.SetParam(nil,far.Flags.ESPT_CODEPAGE,65001)
      editor.SetParam(nil,far.Flags.ESPT_SETBOM,true)
      editor.SetParam(nil,far.Flags.ESPT_EXPANDTABS,true)
    end
  end
}