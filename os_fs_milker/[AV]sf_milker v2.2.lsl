//[AV]sf_milker v2.2.lsl
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


integer channel = 1111;
integer addon_channel = -727003;

float timer_normal = 600.0;
float timer_boosted = 300.0;

key cow;
key bull;
integer breeding = FALSE;
integer boostCounter = 0;

integer particleLink1 = -1;
key particleTarget = NULL_KEY;

float currentCycleDuration = 0.0;
float elapsedTime = 0.0;

updateHoverText() {
    if (currentCycleDuration > 0.0) {
        float percent = (elapsedTime / currentCycleDuration) * 100.0;
        if (percent > 100.0) percent = 100.0;
        string label = breeding ? "Breeding" : "Milking";
        llSetText(label + ": " + (string)((integer)percent) + " %", <1,1,1>, 1.0);
    } else {
        llSetText("", ZERO_VECTOR, 0.0);
    }
}

stopParticles() {
    if (particleLink1 != -1) {
        llLinkParticleSystem(particleLink1, []);
    }
}

startParticles() {
    if (particleLink1 != -1 && particleTarget != NULL_KEY) {
        llLinkParticleSystem(particleLink1, [
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
            PSYS_PART_FLAGS,
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK |
                PSYS_PART_TARGET_POS_MASK |
                PSYS_PART_FOLLOW_SRC_MASK,
            PSYS_PART_START_COLOR, <1, 1, 1>,
            PSYS_PART_END_COLOR, <1, 1, 1>,
            PSYS_PART_START_ALPHA, 1.0,
            PSYS_PART_END_ALPHA, 0.0,
            PSYS_PART_START_SCALE, <0.04, 0.04, 0.0>,
            PSYS_PART_END_SCALE, <0.04, 0.04, 0.0>,
            PSYS_PART_MAX_AGE, 1.5,
            PSYS_SRC_BURST_PART_COUNT, 10,
            PSYS_SRC_BURST_RATE, 0.01,
            PSYS_SRC_ACCEL, <0, 0, 0>,
            PSYS_SRC_ANGLE_BEGIN, 0.0,
            PSYS_SRC_ANGLE_END, 0.0,
            PSYS_SRC_TARGET_KEY, particleTarget,
            PSYS_SRC_MAX_AGE, 0.0
        ]);
    }
}

startMilking(float duration) {
    currentCycleDuration = duration;
    elapsedTime = 0.0;
    startParticles();
    llSetTimerEvent(1.0);
    llRegionSay(channel, "START_MILKING_ANIM");
    llMessageLinked(LINK_SET, 1001, "START_MILKING", "sf_milker_plugin");
    llRegionSay(addon_channel, "COW_TITLE_ON|" + (string)cow);
    announce("🍼 Melkvorgang startet für " + (string)((integer)(duration / 60)) + " Minuten...");
}

startBreeding() {
    breeding = TRUE;
    currentCycleDuration = timer_boosted;
    elapsedTime = 0.0;
    llSetTimerEvent(1.0);
    llRegionSay(channel, "START_BREED_COW");
    llRegionSay(channel, "START_BREED_BULL");
    announce("🐂 Breeding gestartet. 5 Minuten verbleiben...");
}

findParticleLinks() {
    integer count = llGetNumberOfPrims();
    for (integer i = 2; i <= count; i++) {
        string desc = llList2String(llGetLinkPrimitiveParams(i, [PRIM_DESC]), 0);
        if (llToLower(desc) == "particle_1") particleLink1 = i;
        else if (llToLower(desc) == "particle_2") particleTarget = llGetLinkKey(i);
    }
}

integer checkCowAddon() {
    list attached = llGetAttachedList(cow);
    integer i;
    for (i = 0; i < llGetListLength(attached); ++i) {
        string name = llKey2Name(llList2Key(attached, i));
        if (llSubStringIndex(llToLower(name), "cowaddon") != -1) {
            return TRUE;
        }
    }
    return FALSE;
}

announce(string msg) {
    if (cow) llRegionSayTo(cow, 0, msg);
    if (bull) llRegionSayTo(bull, 0, msg);
    llSay(0, msg);
}

default {
    state_entry() {
        findParticleLinks();
        llOwnerSay("✅ [AV]sf_milker Plugin geladen");
    }

    link_message(integer sender, integer num, string msg, key id) {
        if (num == 90045) { 
            list data = llParseStringKeepNulls(msg, ["|"], []);
            string pose = llList2String(data, 1);

            if (pose == "Cow Milking") {
                cow = id;
                if (!checkCowAddon()) {
                    announce("❌ Please attach CowAddon.");
                    llUnSit(cow);
                    return;
                }
                llRegionSay(addon_channel, "COW_SIT|" + (string)cow);
                if (!breeding && boostCounter < 3) {
                    startMilking(timer_normal);
                } else {
                    announce("🔄 Breeding erforderlich – Boost-Limit erreicht.");
                    llRegionSay(addon_channel, "COW_BREED_REQUIRED|" + (string)cow);
                }
            }
            else if (pose == "Breeding" && id != cow) {
                bull = id;
                if (cow) startBreeding();
            }
        }

        if (num == 90065) { 
            integer seat = (integer)msg;
            if (seat == 0) {
                llRegionSay(addon_channel, "COW_UNSIT|" + (string)cow);
                cow = NULL_KEY;
                stopParticles();
                llSetTimerEvent(0.0);
                llSetText("", ZERO_VECTOR, 0.0);
            } else if (seat == 1) {
                bull = NULL_KEY;
            }
        }

        if (num == 1003 && msg == "CYCLE_DONE") {
            if (cow && boostCounter < 3) {
                boostCounter++;
                startMilking(timer_boosted);
            } else {
                boostCounter = 0;
                announce("🔁 Melkzyklus beendet. Breeding erforderlich.");
                llRegionSay(addon_channel, "COW_BREED_REQUIRED|" + (string)cow);
            }
        }
    }

    timer() {
        elapsedTime += 1.0;
        updateHoverText();
        if (elapsedTime >= currentCycleDuration) {
            llSetTimerEvent(0.0);
            llSetText("", ZERO_VECTOR, 0.0);
            if (breeding) {
                breeding = FALSE;
                boostCounter = 0;
                if (bull) {
                    llUnSit(bull);
                }
                startMilking(timer_boosted);
                boostCounter++;
            } else {
                llMessageLinked(LINK_SET, 1002, "REZ_MILK|" + (string)cow, "sf_milker_plugin");
            }
        }
    }

    on_rez(integer i) { llResetScript(); }
}


