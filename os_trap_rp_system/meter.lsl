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

integer HUD_DAMAGE_CHAN = -9001;
float CHECK_INTERVAL     = 0.2;
float DAMAGE_PER_SECOND  = 4.0;

integer fall_ticks       = 0;

default
{
    state_entry()
    {
        llSetTimerEvent(CHECK_INTERVAL);
    }

    timer()
    {
        integer agent = llGetAgentInfo(llGetOwner());

        // Nur zählen, wenn in Luft UND NICHT fliegend
        if ((agent & AGENT_IN_AIR) && !(agent & AGENT_FLYING))
        {
            fall_ticks++;
        }
        else
        {
            if (fall_ticks > 0)
            {
                float secs = fall_ticks * CHECK_INTERVAL;

                if (secs > 1.0)
                {
                    integer dmg = (integer)(secs * DAMAGE_PER_SECOND);
                    llRegionSayTo(llGetOwner(), HUD_DAMAGE_CHAN,
                        "damage:fall=" + (string)dmg);
                }

                fall_ticks = 0;
            }
        }
    }
}

