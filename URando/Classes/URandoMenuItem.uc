class URandoMenuItem extends UMenuModMenuItem;

function Setup()
{
    /// Called when the menu item is created
    log("URandoMenuItem Setup()");
}

function Execute()
{
    //local Menu ChildMenu;
    local PlayerPawn p;
    local string map;

    // Called when the menu item is chosen
    log("URandoMenuItem Execute()");

    p = MenuItem.Owner.GetPlayerOwner();
    //p.UpdateURL("Game", "URando.URandoGameInfo", true);

    map = "..\\maps\\Vortex2.unr?Game=URando.URandoGameInfo?Difficulty=1?GameSpeed=1";
    p.ClientTravel(map, TRAVEL_Absolute, false);
    MenuItem.Owner.Root.Console.CloseUWindow();

    /*ChildMenu = p.spawn(class'URandoChooseGameMenu', p.myHUD.Owner);

    if ( ChildMenu != None )
    {
        ChildMenu.ParentMenu = p.myHUD.MainMenu;
        p.myHUD.MainMenu = ChildMenu;
        //ChildMenu.ParentMenu = p.myHUD;//MenuItem.Owner.Root;
        ChildMenu.PlayerOwner = p;
    }*/

    //MenuItem.Owner.Root.CreateWindow(Class'URandoChooseGameMenu', 20, 20, 200, 200);
}

defaultproperties
{
    MenuCaption="Unreal &Randomizer"
    MenuHelp="Unreal Randomizer"
}
