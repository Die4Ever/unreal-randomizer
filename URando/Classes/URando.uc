class URando extends URInfo;

var #var(PlayerPawn) Player;
var string localURL;
var int newseed;
var int seed;

var private int CrcTable[256]; // for string hashing to do more stable seeding
var URBase modules[32];
var int num_modules;

var bool bTickEnabled;// just for the tests to inspect

function Init()
{
    local int i;
    localURL = string(Level);
    i = InStr(localURL, ".");
    if(i > -1) {
        localURL = Left(localURL, i);
    }
    l(self$".Init(), localURL: "$localURL);
    CrcInit();
    SetSeed(Rand(999999));
    //Enable('Tick');
    //bTickEnabled = true;
    LoadModules();
    RandoFirstEntry();
}

function URBase LoadModule(class<URBase> moduleclass)
{
    local URBase m;
    l("loading module "$moduleclass);

    /*m = FindModule(moduleclass, true);
    if( m != None ) {
        info("found already loaded module "$m);
        if(m.dxr != Self) m.Init(Self);
        return m;
    }*/

    m = Spawn(moduleclass, None);
    if ( m == None ) {
        err("failed to load module "$moduleclass);
        return None;
    }
    modules[num_modules] = m;
    num_modules++;
    m.Init(Self);
    l("finished loading module "$m);
    return m;
}

function LoadModules()
{
    LoadModule(class'URSwapItems');
}

function RandoFirstEntry()
{
    local int i;
    for(i=0;i<num_modules;i++) {
        modules[i].PreFirstEntry();
    }
    for(i=0;i<num_modules;i++) {
        modules[i].FirstEntry();
    }
    for(i=0;i<num_modules;i++) {
        modules[i].PostFirstEntry();
    }
}

function RandoAnyEntry()
{
    local int i;
    for(i=0;i<num_modules;i++) {
        modules[i].AnyEntry();
    }
}

function PlayerLogin(#var(PlayerPawn) p)
{
    local int i;
    for(i=0;i<num_modules;i++) {
        modules[i].PlayerLogin(p);
    }
}

simulated final function int SetSeed(int s)
{
    local int oldseed;
    oldseed = newseed;
    //log("SetSeed old seed == "$newseed$", new seed == "$s);
    newseed = s;
    return oldseed;
}

simulated final function int rng(int max)
{
    local int gen1, gen2;
    gen2 = 2147483643;
    gen1 = gen2/2;
    newseed = gen1 * newseed * 5 + gen2 + (newseed/5) * 3;
    newseed = abs(newseed);
    return (newseed >>> 8) % max;
}


// ============================================================================
// CrcInit https://web.archive.org/web/20181105143221/http://unrealtexture.com/Unreal/Downloads/3DEditing/UnrealEd/Tutorials/unrealwiki-offline/crc32.html
//
// Initializes CrcTable and prepares it for use with Crc.
// ============================================================================

simulated final function CrcInit() {

    const CrcPolynomial = 0xedb88320;

    local int CrcValue;
    local int IndexBit;
    local int IndexEntry;

    for (IndexEntry = 0; IndexEntry < 256; IndexEntry++) {
        CrcValue = IndexEntry;

        for (IndexBit = 8; IndexBit > 0; IndexBit--)
        {
            if ((CrcValue & 1) != 0)
                CrcValue = (CrcValue >>> 1) ^ CrcPolynomial;
            else
                CrcValue = CrcValue >>> 1;
        }

        CrcTable[IndexEntry] = CrcValue;
    }
}


// ============================================================================
// Crc
//
// Calculates and returns a checksum of the given string. Call CrcInit before.
// ============================================================================

simulated final function int Crc(coerce string Text) {

    local int CrcValue;
    local int IndexChar;

    //if(CrcTable[1] == 0)
        //err("CrcTable uninitialized?");

    CrcValue = 0xffffffff;

    for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
        CrcValue = (CrcValue >>> 8) ^ CrcTable[Asc(Mid(Text, IndexChar, 1)) ^ (CrcValue & 0xff)];

    return CrcValue;
}

simulated function URando GetUR()
{
    return Self;
}
/*
function RunTests()
{
    local int i, failures;
    l("starting RunTests()");
    for(i=0; i<num_modules; i++) {
        modules[i].StartRunTests();
        if( modules[i].fails > 0 ) {
            failures++;
            Player.ShowHud(true);
            err( "ERROR: " $ modules[i] @ modules[i].fails $ " tests failed!" );
        }
        else
            l( modules[i] $ " passed tests!" );
    }

    if( failures == 0 ) {
        l( "all tests passed!" );
    } else {
        Player.ShowHud(true);
        err( "ERROR: " $ failures $ " modules failed tests!" );
    }
}

function ExtendedTests()
{
    local int i, failures;
    l("starting ExtendedTests()");
    for(i=0; i<num_modules; i++) {
        modules[i].StartExtendedTests();
        if( modules[i].fails > 0 ) {
            failures++;
            Player.ShowHud(true);
            err( "ERROR: " $ modules[i] @ modules[i].fails $ " tests failed!" );
        }
        else
            l( modules[i] $ " passed tests!" );
    }

    if( failures == 0 ) {
        l( "all extended tests passed!" );
    } else {
        Player.ShowHud(true);
        err( "ERROR: " $ failures $ " modules failed tests!" );
    }
}
*/
defaultproperties
{
    NetPriority=0.1
}
