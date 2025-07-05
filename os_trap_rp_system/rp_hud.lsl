// ---------------------------
// RP_HUD – Health & Death HUD
// version 1.4 mit Persistenz in Link 2
// HUD need 3 prims 
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

string notecard_name       = "config";
integer DAMAGE_CHANNEL     = -9001;
integer HEAL_CHECK_CHANNEL = -9002;

float   health             = 100.0;
float   max_health         = 100.0;
integer cooldown           = 15;
integer last_heal_time     = 0;

vector  save_position      = <0,0,0>;
vector  save_lookat        = <0,0,0>;

integer is_dead            = FALSE;
string  death_anim         = "death";
integer permissions_granted= FALSE;
integer revive_delay_active = FALSE;
integer teleport_pending   = FALSE;

list    damage_table       = [];

key     config_query;
integer read_line          = 0;

// ----------------------------------------------------------------
// Hilfsfunktionen
// ----------------------------------------------------------------

updateHoverText()
{
    integer pct = (integer)health;
    string  txt = pct < (integer)max_health ? (string)pct + "%" : "100%";
    vector  col = <0,1,0>;
    if      (health < 25.0) col = <1,0,0>;
    else if (health < 50.0) col = <1,0.5,0>;
    else if (health < 75.0) col = <1,1,0>;
    llSetText("HP: " + txt, col, 1.0);
}

autoHeal(float amount)
{
    health += amount;
    if (health > max_health) health = max_health;
    updateHoverText();
}

manualHeal(float amount)
{
    integer now = llGetUnixTime();
    if (now - last_heal_time < cooldown)
    {
        llOwnerSay("⏳ Cooldown noch aktiv.");
        return;
    }
    last_heal_time = now;
    health += amount;
    if (health > max_health) health = max_health;
    updateHoverText();
}

// ----------------------------------------------------------------
// Hauptskript
// ----------------------------------------------------------------

default
{
    state_entry()
    {
        // 🔄 LINK 2: HP-Wert aus Beschreibung von Link 2 lesen
        string desc = llList2String(llGetLinkPrimitiveParams(2, [PRIM_DESC]), 0);
        if (llSubStringIndex(desc, "HP=") == 0)
        {
            health = (float)llGetSubString(desc, 3, -1);
            if (health < 0.0 || health > max_health) health = max_health;
        }

        read_line    = 0;
        config_query = llGetNotecardLine(notecard_name, read_line);
        llListen(DAMAGE_CHANNEL,     "", NULL_KEY, "");
        llListen(HEAL_CHECK_CHANNEL, "", NULL_KEY, "");
        updateHoverText();
        llSetTimerEvent(2.0);
    }

    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);

            // Speicherprim (Link 2) automatisch ausblenden
            llSetLinkAlpha(2, 0.0, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(2, [
                PRIM_PHYSICS, FALSE,
                PRIM_TEMP_ON_REZ, FALSE,
                PRIM_PHANTOM, TRUE
            ]);
        }
    }

    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TRIGGER_ANIMATION) != 0)
        {
            permissions_granted = TRUE;

            if (is_dead)
            {
                llStartAnimation(death_anim);
            }
        }
    }

    dataserver(key queryid, string data)
    {
        if (queryid != config_query) return;
        if (data == EOF) return;

        string line = llStringTrim(data, STRING_TRIM);

        if (line == "" || llGetSubString(line,0,0) == "#") { }
        else if (llSubStringIndex(line, "heal:cooldown=") == 0)
        {
            cooldown = (integer)llGetSubString(line,15,-1);
        }
        else if (llSubStringIndex(line, "damage:") == 0)
        {
            damage_table += [ line ];
        }
        else if (llSubStringIndex(line, "heal:potion_") == 0)
        {
            damage_table += [ line ];
        }
        else if (llSubStringIndex(line, "savespace:place=") == 0)
        {
            list c = llParseString2List(llGetSubString(line,16,-1), [","], []);
            if (llGetListLength(c) == 3)
            {
                save_position = <
                    (float)llList2String(c,0),
                    (float)llList2String(c,1),
                    (float)llList2String(c,2)
                >;
                save_lookat = save_position;
            }
        }

        read_line++;
        config_query = llGetNotecardLine(notecard_name, read_line);
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (chan == DAMAGE_CHANNEL && llSubStringIndex(msg, "damage:") == 0)
        {
            list parts1 = llParseString2List(msg, ["="], []);
            string raw   = llList2String(parts1, 0);
            string type  = llGetSubString(raw, 7, -1);
            float  value = (float)llList2String(parts1, 1);
            integer dmg  = 0;

            if (type == "fall")
            {
                dmg = (integer)value;
            }
            else
            {
                integer len = llGetListLength(damage_table);
                integer i   = 0;
                while (i < len)
                {
                    string line = llList2String(damage_table, i);
                    if (llSubStringIndex(line, "damage:" + type + "=") == 0)
                    {
                        list kv = llParseString2List(line, ["="], []);
                        dmg = (integer)llList2String(kv, 1);
                        i   = len;
                    }
                    else
                    {
                        i++;
                    }
                }
            }

            if (dmg > 0)
            {
                health -= (float)dmg;
                if (health < 0.0) health = 0.0;
                llOwnerSay("💥 -" + (string)dmg + " HP durch " + type);
                updateHoverText();

                if (health <= 0.0 && !is_dead)
                {
                    is_dead = TRUE;
                    llOwnerSay("☠️ Du bist gestorben.");
                    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
                    teleport_pending = TRUE;
                    llSetTimerEvent(2.0);
                }
            }
        }
        else if (chan == HEAL_CHECK_CHANNEL && llSubStringIndex(msg, "heal:") == 0)
        {
            list parts = llParseString2List(msg, [":"], []);
            if (llGetListLength(parts) < 3) return;

            string mid    = llList2String(parts, 1);
            string source = llList2String(parts, 2);

            if (source != "potion")
            {
                autoHeal((float)mid);
            }
            else
            {
                string keyname = mid;
                integer len = llGetListLength(damage_table);
                integer j   = 0;
                string prefix = "heal:" + keyname + "=";
                while (j < len)
                {
                    string line = llList2String(damage_table, j);
                    if (llSubStringIndex(line, prefix) == 0)
                    {
                        list kv   = llParseString2List(line, ["="], []);
                        float amt = (float)llList2String(kv, 1);
                        manualHeal(amt);
                        j = len;
                    }
                    else
                    {
                        j++;
                    }
                }
            }
        }
    }

    timer()
    {
        // 🔄 LINK 2: HP-Wert speichern
        llSetLinkPrimitiveParamsFast(2, [PRIM_DESC, "HP=" + (string)((integer)health)]);

        if (is_dead)
        {
            if (teleport_pending)
            {
                teleport_pending = FALSE;
                llSleep(15.0);
                osTeleportAgent(llGetOwner(), save_position, save_lookat);
            }

            vector myPos = llGetPos();
            float dist = llVecDist(myPos, save_position);

            if (dist <= 2.0 && health < max_health)
            {
                llSleep(5); 
                health += 2.0;
                if (health > max_health) health = max_health;
                updateHoverText();
                llOwnerSay("💚 Auto-Heilung am Save-Spot (+2 HP)");
            }

            if (health > 0.0 && permissions_granted && !revive_delay_active)
            {
                revive_delay_active = TRUE;
                llSetTimerEvent(3.0);
                return;
            }
        }

        if (revive_delay_active)
        {
            revive_delay_active = FALSE;
            is_dead = FALSE;
            llStopAnimation(death_anim);
            llOwnerSay("💚 Du bist wieder am Leben!");
            llSetTimerEvent(2.0);
        }
    }
}

