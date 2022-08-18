class URandoNewGameMenu extends UWindowDialogClientWindow;

var UWindowEditControl SeedEdit;
var UWindowSmallButton CloseButton;

function Created()
{
    local int y, controlHeight, yPadding;

    controlHeight = 20;
    yPadding = 10;
    y = yPadding;

    SeedEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', 50, y, 200, controlHeight));
    SeedEdit.SetText("Seed");
    SeedEdit.SetHelpText("Seed");
    SeedEdit.SetFont(F_Normal);
    SeedEdit.SetNumericOnly(True);
    SeedEdit.SetMaxLength(9);
    SeedEdit.SetValue(string(Rand(999999)));
    SeedEdit.Align = TA_Right;
    y += controlHeight + yPadding;

    CloseButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 50, y, 200, controlHeight));
    CloseButton.SetText( "Start Game" );
    y += controlHeight + yPadding;
}

function Notify(UWindowDialogControl C, byte E)
{
    switch(E) {
    case DE_Click:
        switch(C) {
        case CloseButton:
            StartGame();
            break;
        }
        break;
    }
}

function StartGame()
{
    local URDataStorage ds;
    local PlayerPawn p;
    local string map;
    local int seed;

    seed = int(SeedEdit.GetValue());
    log("URandoNewGameMenu StartGame(), seed: " $ seed);

    p = GetPlayerOwner();
    log(p @ p.Level.Game);

    p.Level.Game.DiscardInventory(p);
    ds = p.spawn(class'URDataStorage');
    log(self$" spawned "$ds);
    p.AddInventory(ds);
    ds.seed = seed;

    map = "..\\maps\\Vortex2.unr?Game=URando.URandoGameInfo?Difficulty=1?GameSpeed=1";
    p.ClientTravel(map, TRAVEL_Absolute, true);
    Root.Console.CloseUWindow();
    Close();
}
