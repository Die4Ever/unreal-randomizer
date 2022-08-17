class URandoGameInfo extends SinglePlayer;

var URando ur;

function URando GetRando()
{
    if( ur != None ) return ur;
    foreach AllActors(class'URando', ur) return ur;
    ur = Spawn(class'URando');
    log("GetRando(), ur: "$ur, self.name);
    ur.Init();// just in case we need to pass in an argument later
    return ur;
}

event InitGame( String Options, out String Error )
{
    Super.InitGame(Options, Error);

    log("InitGame", self.name);
    GetRando();
    ur.RandoAnyEntry();
}

event PostLogin(playerpawn NewPlayer)
{
    local #var(PlayerPawn) p;

    Super.PostLogin(NewPlayer);
    if( Role != ROLE_Authority ) return;

    p = #var(PlayerPawn)(NewPlayer);

    GetRando();
    log("PostLogin("$NewPlayer$") server, ur: "$ur, self.name);
    ur.PlayerLogin(p);
}

/*
function bool PickupQuery( Pawn Other, Inventory item )
{
    local DXRLoadouts loadouts;
    local #var(PlayerPawn) player;

    player = #var(PlayerPawn)(Other);
    if(player != None && item != None) {
        loadouts = DXRLoadouts(dxr.FindModule(class'DXRLoadouts'));
        if( loadouts != None && loadouts.ban(player, item) ) {
            item.Destroy();
            return false;
        }
    }

    return Super.PickupQuery(Other, item);
}

function Killed( pawn Killer, pawn Other, name damageType )
{
    Super.Killed(Killer, Other, damageType);
    class'DXREvents'.static.AddDeath(Other, Killer, damageType);
}
*/

defaultproperties
{
    GameName="Unreal Randomizer"
}
