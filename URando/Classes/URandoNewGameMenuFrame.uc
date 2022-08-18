class URandoNewGameMenuFrame extends UWindowFramedWindow;

function BeginPlay()
{
    Super.BeginPlay();
    WindowTitle = "Unreal Randomizer " $ class'URVersion'.static.VersionString();
}

function Created()
{
    Super.Created();
    SetSize(400, 300);
    WinLeft = (Root.WinWidth - WinWidth) / 2;
    WinTop = (Root.WinHeight - WinHeight) / 2;
}

defaultproperties
{
    WindowTitle="Unreal Randomizer"
    ClientClass=class'URandoNewGameMenu'
    bSizable=False
}
