class URandoNewGameMenu extends UWindowDialogClientWindow;

var UWindowComboControl GameCombo;
var UWindowComboControl SkillCombo;

var UWindowEditControl SeedEdit;
var UWindowSmallButton CloseButton;

function Created()
{
    local int y, controlHeight, yPadding, xPos, controlWidth;

    xPos = 50;
    controlWidth = 200;
    controlHeight = 20;
    yPadding = 10;
    y = yPadding;

    // add game menu (Unreal vs. Mission Pack)
    GameCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', xPos, y, controlWidth, controlHeight));
    GameCombo.SetText("Game:");
    GameCombo.SetHelpText("Select the game you wish to play.");
    GameCombo.SetFont(F_Normal);
    GameCombo.SetEditable(False);
    GameCombo.AddItem("Unreal");
    GameCombo.AddItem("Return to Na Pali");
    GameCombo.SetSelectedIndex(0);
    y += controlHeight + yPadding;

    // Skill Level
    SkillCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', xPos, y, controlWidth, controlHeight));
    SkillCombo.SetText("Skill Level:");
    SkillCombo.SetHelpText("Select the difficulty you wish to play at.");
    SkillCombo.SetFont(F_Normal);
    SkillCombo.SetEditable(False);
    SkillCombo.AddItem("Easy");
    SkillCombo.AddItem("Medium");
    SkillCombo.AddItem("Hard");
    SkillCombo.AddItem("Unreal");
    SkillCombo.AddItem("Godlike");
    SkillCombo.SetSelectedIndex(1);
    //SkillLabel = UMenuLabelControl(CreateWindow(class'UMenuLabelControl', xPos, y, controlWidth, controlHeight));
    //SkillLabel.SetText(SkillStrings[GetLevel().Game.Difficulty]);
    //SkillLabel.Align = TA_Center;
    y += controlHeight + yPadding;

    // Seed
    SeedEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', xPos, y, controlWidth, controlHeight));
    SeedEdit.SetText("Seed");
    SeedEdit.SetHelpText("Seed");
    SeedEdit.SetFont(F_Normal);
    SeedEdit.SetNumericOnly(True);
    SeedEdit.SetMaxLength(9);
    SeedEdit.SetValue(string(Rand(999999)));
    SeedEdit.Align = TA_Right;
    y += controlHeight + yPadding;

    CloseButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', xPos, y, controlWidth, controlHeight));
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
    local int seed, Difficulty;

    seed = int(SeedEdit.GetValue());
    log("URandoNewGameMenu StartGame(), seed: " $ seed);

    p = GetPlayerOwner();
    log(p @ p.Level.Game);

    p.Level.Game.DiscardInventory(p);
    ds = p.spawn(class'URDataStorage');
    log(self$" spawned "$ds);
    p.AddInventory(ds);
    ds.seed = seed;

    map = "..\\maps\\Vortex2.unr";
    if(GameCombo.GetSelectedIndex() != 0)
        map = "..\\maps\\UPak\\DuskFalls.unr";
    Difficulty = SkillCombo.GetSelectedIndex();
    map = map $ "?Game=URando.URandoGameInfo?Difficulty=" $ Difficulty $ "?GameSpeed=1";
    p.ClientTravel(map, TRAVEL_Absolute, true);
    Root.Console.CloseUWindow();
    Close();
}
