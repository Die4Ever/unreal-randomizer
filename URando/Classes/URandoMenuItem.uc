class URandoMenuItem extends UMenuModMenuItem;

function Setup()
{
    /// Called when the menu item is created
    log("URandoMenuItem Setup()");
}

function Execute()
{
    // Called when the menu item is chosen
    log("URandoMenuItem Execute()");
    MenuItem.Owner.Root.CreateWindow(Class'URandoNewGameMenuFrame', 20, 20, 200, 200);
}

defaultproperties
{
    MenuCaption="Unreal &Randomizer"
    MenuHelp="Unreal Randomizer"
}
