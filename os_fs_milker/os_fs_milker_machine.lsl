//os_fs_milker_machine.lsl
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


string PRODUCT_OBJECT = "SF Milk";
vector rez_offset = <0.0, 0.5, 0.3>;
rotation rez_rot = llEuler2Rot(<0, 0, 90> * DEG_TO_RAD);

key lastActor; 

rezProduct() {
    vector pos = llGetPos() + rez_offset;
    llRezObject(PRODUCT_OBJECT, pos, ZERO_VECTOR, rez_rot, 0);

    if (lastActor) {
        llRegionSayTo(lastActor, 0, "🥛 SF Milk wurde produziert.");
    } else {
        llSay(0, "🥛 SF Milk wurde produziert.");
    }

    llMessageLinked(LINK_SET, 1003, "CYCLE_DONE", "os_sf_milker");
}

default {
    state_entry() {
        llSay(0, "🧠 os_sf_milker bereit.");
    }

    link_message(integer sender, integer num, string msg, key id) {
        if (llSubStringIndex(msg, "REZ_MILK|") == 0) {
            list parts = llParseStringKeepNulls(msg, ["|"], []);
            if (llGetListLength(parts) >= 2) {
                lastActor = llList2Key(parts, 1);
            } else {
                lastActor = NULL_KEY;
            }
            rezProduct();
        }
        else if (msg == "START_MILKING") {
            llSay(0, "🍼 Melkvorgang wurde vom Plugin gestartet.");
        }
    }

    object_rez(key id) {
        llOwnerSay("📦 Produkt rezzt: " + (string)id);
    }
}


