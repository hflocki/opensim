// ============================
// 🛏️ AVSITTER HEALER
// ============================
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


integer HEAL_CHECK_CHANNEL = -9002;  // dein HUD-Heal-Channel
float   HEAL_AMOUNT         = 10.0;
float   HEAL_INTERVAL       = 66.0;
key     seated_avatar;

default
{
    link_message(integer sender, integer num, string msg, key id)
    {
        if (num == 90045)
        {
            seated_avatar = id;
            llInstantMessage(id, "🛌 Regeneration gestartet.");
            llSetTimerEvent(HEAL_INTERVAL);
        }
        else if (num == 90065)
        {
            llInstantMessage(id, "🏃 Regeneration beendet.");
            seated_avatar = NULL_KEY;
            llSetTimerEvent(0.0);
        }
    }

    timer()
    {
        if (seated_avatar != NULL_KEY)
        {
            // numeric heal: "heal:10.0:sit"
            llRegionSayTo(
                seated_avatar,
                HEAL_CHECK_CHANNEL,
                "heal:" + (string)HEAL_AMOUNT + ":sit"
            );
        }
    }
}
