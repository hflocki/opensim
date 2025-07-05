// ---------------------------
// Potion Auto-Drink Complete
// ---------------------------
// Copyright © Josch Wolf, 2025
//
// This script may be freely copied and distributed,
// BUT only in its complete and unmodified form,
// and this copyright notice must remain intact and unaltered.
//
// You are NOT allowed to modify, edit, or extract parts of this script.
// Any use of this script requires it to remain exactly as provided,
// including this copyright notice.
//
// Any modification or partial use of this script requires
// the explicit permission of the author, Josch Wolf,
// inworld in adult-life.de.
//
// Violations will be pursued under applicable copyright law.

// Stelle hier den Trank-Typ ein: "low", "small", "medium", "big" oder "ultra"

string  potion_type        = "small";


integer DAMAGE_CHANNEL     = -9001;  // für Schaden
integer HEAL_CHECK_CHANNEL = -9002;  // für Heilung
string  drink_anim         = "drink";
integer permissions_granted = FALSE;
integer used               = FALSE;

default
{
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        }
    }
    run_time_permissions(integer perms)
    {
        permissions_granted = (perms & PERMISSION_TRIGGER_ANIMATION) != 0;
        if (!permissions_granted)
        {
            llOwnerSay("⚠️ Animationen deaktiviert – Trank wirkt ohne Animation.");
        }
    }
 
    touch_start(integer total_number)
    {
        key user = llDetectedKey(0);

        if (used)
        {
            llOwnerSay("❌ Dieser Trank wurde bereits verwendet.");
            return;
        }
        used = TRUE;
        if (permissions_granted)
        {
            llStartAnimation(drink_anim);
        }
        llParticleSystem([
            PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_PART_START_COLOR,     <0,1,0>,
            PSYS_PART_END_COLOR,       <0,1,0>,
            PSYS_PART_START_ALPHA,     1.0,
            PSYS_PART_END_ALPHA,       0.0,
            PSYS_PART_START_SCALE,     <0.1,0.1,0>,
            PSYS_PART_END_SCALE,       <0.3,0.3,0>,
            PSYS_PART_MAX_AGE,         1.5,
            PSYS_SRC_BURST_RATE,       0.1,
            PSYS_SRC_BURST_PART_COUNT, 10,
            PSYS_SRC_BURST_RADIUS,     0.1,
            PSYS_SRC_BURST_SPEED_MIN,  0.1,
            PSYS_SRC_BURST_SPEED_MAX,  0.3,
            PSYS_SRC_ANGLE_BEGIN,      0,
            PSYS_SRC_ANGLE_END,        PI,
            PSYS_SRC_MAX_AGE,          2.0,
            PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK 
                           | PSYS_PART_INTERP_SCALE_MASK 
                           | PSYS_PART_EMISSIVE_MASK
        ]);

        llSleep(2.0);
        if (permissions_granted)
        {
            llStopAnimation(drink_anim);
        }
        llParticleSystem([]);

        //    Dein HUD liest aus config-Notecard heal:potion_<type>=<wert>
        llRegionSayTo(user, HEAL_CHECK_CHANNEL,
            "heal:potion_" + potion_type + ":potion");
        llSetObjectDesc(potion_type + ":1");
        string name = llGetObjectName();
        if (llSubStringIndex(name, "[delete me]") == -1)
        {
            llSetObjectName(name + " [delete me]");
        }

        llDetachFromAvatar();
        llDie();
    }
}
