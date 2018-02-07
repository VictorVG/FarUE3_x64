Short story: On Windows Vista, you need to perform a few additional
jumps to use the plugin.
* Unzip dshow_marshal.dll somewhere outside the FAR plugins directory.
* Open up an *elevated* command prompt or FAR.
* Navigate to the directory where dshow_marshal.dll is located.
* Cast the following spell:
    regsvr32 dshow_marshal.dll


Long story... (way technical; if you're not a COM developer, I do not
guarantee comprehensibility)

One nice sunny day I was reading the FAR Manager forum and stumbled upon
a post that listed plugins that stopped working after upgrading to
Windows Vista. Yeah, you've guessed it: SSA Editor was in that list.

Big deal, I say to myself, it's not final yet.

Then it goes RTM and is readily available in p2p networks :) I decide to
give it a try.

Sh*t, it really doesn't work. As soon as I try to attach the plugin to
an instance of Media Player Classic, it crashes trying to access
0x00000000.

A little better error checking, a few rebuilds and I know the cause.
Media Player Classic's filter graph manager is not giving me the
IMediaSeeking interface which I absolutely cannot live without, as it
tells me the position of the file being currently played, so that I
might move the editor cursor to the corresponding line. Also, GraphEdt
does not see MPC's filter graph manager at all.

Okay, the player developers must have screwed something up in a way that
only started making a difference with Vista. Microsoft guys wouldn't
break compatibility, would they?

Head over to Doom9, report the problem. The devs say Vista is not a
priority but that I'm welcome to play around and see if anything is
wrong.

So I download the sources and start trying to build a debug version. It
turns out to be a royal pain in the tail, since they have migrated to
Visual Studio 2005 and I'm still on VS2003. I end up having to install
VS2005 in that Vista virtual machine. And the latest DirectX SDK. And
the DirectX SDK Extras, because since some time ago the DirectShow SDK
is not in the main DXSDK.

Finally, I have a debug build. Open up my debugger, start it up, open a
file, start FAR, edit a file, try to attach.

Surprise! MPC yields the interface all right -- or so my debugger tells
me. Yet the plugin over there in FAR can't get hold of it.

Well, looks like the time has come to get my chemical protection suit on
and dive into disassembly.

I step out of MPC's CFGManager::QueryInterface and find myself in a
function not unlike this:

===
ole32!00034312:

pObject = pObj;
if (pObject == 0)
{
    pObject = #####->ole32!00032539();
    if (pObject == 0) goto ole32!0008CBCC;
}

if (IID_IUnknown == riid) goto ole32!000273AB;

IUnknown* pInterface = 0;
if (FAILED(pObject->QueryInterface(riid, &pInterface)))
    goto ole32!000343F6;

pObj = 0;
HRESULT hResult = ole32!00034477(riid, pInterface, &###, &pObj, ###);
if (FAILED(hResult)) goto ole32!0002017C;
===

And what do you think, this last call fails with an hResult of
0x80040155 which winerror.h describes as REGDB_E_IIDNOTREG.

A quick trip to Google...

As you might know, cross-process COM calls cannot be done
directly and have to be marshaled. Marshaling works like this. A client
obtains a proxy for an interface. When it calls a method on the proxy,
the proxy packages up the arguments and sends them to the server
process. An object known as a stub receives the package, unpacks it, and
calls the real object. It then repackages the results and sends them
back to the proxy, which returns the data to the client.

Marshaling must be done separately on each interface, even though
several interfaces can be (and often are) implemented by a single
object.

An interface can be marshaled in one of three ways:
* It might be described in a type library, in which case the standard
type library marshaler will know how to deal with it. This is mostly
limited to COM Automation-compatible interfaces.
* It might have a marshaler DLL, also known as a proxy/stub DLL, usually
generated from the IDL definition of the interface.
* Or the object that implements the interface might also implement
IMarshal. This is called custom marshaling, is done as a performance
optimization, and is way too complex.

Now, it turns out that DirectX 9 in Windows XP implements a marshaler
for most (if not all) DirectShow interfaces, and it resides in
quartz.dll. On the other hand, when I look in my Vista registry, I see
no traces of those interfaces. It is almost as if someone forgot to
register the marshaler library.

Okay. Let's try that first.

===
$ cd "%systemroot%\system32"
$ regsvr32 quartz.dll
DllRegisterServer in quartz.dll succeeded.
===

Succeeded my ass. Same error. Go figure.

Okay. Let's copy the registry keys from XP, in an attempt to talk
quartz.dll into doing the marshaling for us.

As if. Now it fails with E_NOINTERFACE. No, it's not a glitch. Comrades,
we've been betrayed. quartz.dll no longer marshals DirectShow
interfaces.

Tough luck. All right, looks like we'll have to implement our own
marshaler for them. Luckily, I still remember some COM basics.

One invocation of midl -Oicf strmif.idl... some library hunting to make
it link... a flash of insight to understand that the remaining 8
functions are not going to be found in any lib file and that I have to
actually code them up myself... another trip to Google to understand
what they want from me. Compile, link, register. Start player, open
file, start GraphEdt, connect to player's graph. Success. Start FAR,
attach plugin to player. Success.
