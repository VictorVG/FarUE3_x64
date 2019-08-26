Event
{
  group="EditorEvent"; filemask="*.php,*.lua,*.moon";
  action=function(id,event,param)
    if event==far.Flags.EE_READ then
      editor.SetParam(nil,far.Flags.ESPT_SETBOM,false)
    end
  end
}