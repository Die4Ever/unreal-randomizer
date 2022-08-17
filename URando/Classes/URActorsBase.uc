class URActorsBase extends URBase;

var class<Actor> _skipactor_types[6];

function SwapAll(class<Actor> c, float percent_chance)
{
    local Actor temp[4096];
    local Actor a, b;
    local int num, i, slot;

    SetSeed( "SwapAll " $ c.name );
    num=0;
    foreach AllActors(c, a)
    {
        if( SkipActor(a) ) continue;
        temp[num++] = a;
    }

    for(i=0; i<num; i++) {
        if( percent_chance<100 && !chance_single(percent_chance) ) continue;
        slot=rng(num-1);// -1 because we skip ourself
        if(slot >= i) slot++;
        Swap(temp[i], temp[slot]);
    }
}

function bool SkipActorBase(Actor a)
{
    if( (a.Owner != None) || a.bStatic || a.bHidden || a.bMovable==False )
        return true;
    return false;
}

function bool SkipActor(Actor a)
{
    local int i;
    if( SkipActorBase(a) ) {
        return true;
    }
    for(i=0; i < ArrayCount(_skipactor_types); i++) {
        if(_skipactor_types[i] == None) break;
        if( a.IsA(_skipactor_types[i].name) ) return true;
    }
    return false;
}


function bool Swap(Actor a, Actor b, optional bool retainOrders)
{
    local vector newloc, oldloc;
    local rotator newrot;
    local bool asuccess, bsuccess;
    local Actor abase, bbase;
    local bool AbCollideActors, AbBlockActors, AbBlockPlayers;
    local EPhysics aphysics, bphysics;

    if( a == b ) return true;

    l("swapping "$a$" and "$b$" distance == " $ VSize(a.Location - b.Location) );

    AbCollideActors = a.bCollideActors;
    AbBlockActors = a.bBlockActors;
    AbBlockPlayers = a.bBlockPlayers;
    a.SetCollision(false, false, false);

    oldloc = a.Location;
    newloc = b.Location;

    bsuccess = SetActorLocation(b, oldloc + (b.CollisionHeight - a.CollisionHeight) * vect(0,0,1), retainOrders );
    a.SetCollision(AbCollideActors, AbBlockActors, AbBlockPlayers);
    if( bsuccess == false ) {
        warning("bsuccess failed to move " $ ActorToString(b) $ " into location of " $ ActorToString(a) );
        return false;
    }

    asuccess = SetActorLocation(a, newloc + (a.CollisionHeight - b.CollisionHeight) * vect(0,0,1), retainOrders);
    if( asuccess == false ) {
        warning("asuccess failed to move " $ ActorToString(a) $ " into location of " $ ActorToString(b) );
        SetActorLocation(b, newloc, retainOrders);
        return false;
    }

    newrot = b.Rotation;
    b.SetRotation(a.Rotation);
    a.SetRotation(newrot);

    aphysics = a.Physics;
    bphysics = b.Physics;
    abase = a.Base;
    bbase = b.Base;

    a.SetPhysics(bphysics);
    if(abase != bbase) a.SetBase(bbase);
    b.SetPhysics(aphysics);
    if(abase != bbase) b.SetBase(abase);

    return true;
}

function string ActorToString( Actor a )
{
    local string out;
    out = a.Class.Name$"."$a.Name$"("$a.Location$") "$a.tag;
    if( a.Base != None && a.Base.Class!=class'LevelInfo' )
        out = out $ " (Base:"$a.Base.Name$")";
    return out;
}

function bool SetActorLocation(Actor a, vector newloc, optional bool retainOrders)
{
    local ScriptedPawn p;

    if( ! a.SetLocation(newloc) ) return false;

    p = ScriptedPawn(a);
    if( p != None && p.Orders == 'Patrolling' && !retainOrders ) {
        p.Orders = 'Wandering';
        //p.HomeTag = 'Start';
        //p.HomeLoc = p.Location;
    }

    return true;
}

function SwapNames(out Name a, out Name b) {
    local Name t;
    t = a;
    a = b;
    b = t;
}

function SwapVector(out vector a, out vector b) {
    local vector t;
    t = a;
    a = b;
    b = t;
}

function SwapProperty(Actor a, Actor b, string propname) {
    local string t;
    t = a.GetPropertyText(propname);
    a.SetPropertyText(propname, b.GetPropertyText(propname));
    b.SetPropertyText(propname, t);
}

function bool HasBased(Actor a) {
    local Actor b;
    foreach a.BasedActors(class'Actor', b)
        return true;
    return false;
}


