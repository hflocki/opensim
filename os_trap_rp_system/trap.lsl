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

integer DAMAGE_CHANNEL = -9001;
float last_trigger_time = 0.0;

// 💡 Hilfsfunktion zum Parameterabruf
string getParam(string raw, string param_key)
{
    list parts = llParseString2List(raw, [":"], []);
    integer i;
    for (i = 1; i < llGetListLength(parts); ++i)
    {
        list pair = llParseString2List(llList2String(parts, i), ["="], []);
        if (llGetListLength(pair) >= 2 && llList2String(pair, 0) == param_key)
        {
            return llList2String(pair, 1);
        }
    }
    return "";
}
 
default
{
    collision_start(integer total)
    {
        string raw = llStringTrim(llToLower(llGetObjectDesc()), STRING_TRIM);
        if (raw == "") return;

        float now = llGetTime();
        float cooldown = (float)getParam(raw, "cooldown");
        if (cooldown <= 0.0) cooldown = 5.0;

        if (now - last_trigger_time < cooldown) return; // Cooldown aktiv

        last_trigger_time = now;

        string dmg_type = llList2String(llParseString2List(raw, [":"], []), 0);
        float radius = (float)getParam(raw, "radius");
        if (radius <= 0.0) radius = 3.0;

        float chance = (float)getParam(raw, "chance");
        if (chance <= 0.0) chance = 100.0;

        for (integer i = 0; i < total; ++i)
        {
            key av = llDetectedKey(i);
            if ((llDetectedType(i) & AGENT))
            {
                vector pos = llDetectedPos(i);
                vector trap_pos = llGetPos();
                float dist = llVecDist(pos, trap_pos);

                if (dist <= radius && llFrand(100.0) <= chance)
                {
                    llRegionSayTo(av, DAMAGE_CHANNEL, "damage:" + dmg_type);
                    llInstantMessage(av, "⚠️ Du wurdest von einer Falle getroffen!");

                    // 💨 Partikeleffekt
                    llParticleSystem([
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_PART_START_COLOR, <1,0,0>,
                        PSYS_PART_END_COLOR, <1,1,0>,
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 0.0,
                        PSYS_PART_START_SCALE, <0.2,0.2,0>,
                        PSYS_PART_END_SCALE, <0.4,0.4,0>,
                        PSYS_SRC_TEXTURE, "*",
                        PSYS_PART_MAX_AGE, 2.0,
                        PSYS_SRC_BURST_RATE, 0.1,
                        PSYS_SRC_BURST_PART_COUNT, 20,
                        PSYS_SRC_BURST_RADIUS, 0.0,
                        PSYS_SRC_BURST_SPEED_MIN, 0.2,
                        PSYS_SRC_BURST_SPEED_MAX, 0.6,
                        PSYS_SRC_MAX_AGE, 1.5,
                        PSYS_PART_FLAGS,
                            PSYS_PART_INTERP_COLOR_MASK |
                            PSYS_PART_INTERP_SCALE_MASK |
                            PSYS_PART_EMISSIVE_MASK |
                            PSYS_PART_WIND_MASK
                    ]);
                }
            }
        }
    }
}
