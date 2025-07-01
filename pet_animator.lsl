// Copyright © Josch Wolf, 2025
//
// The scripts may be freely copied and distributed,
// BUT only in its complete and unmodified form,
// and this copyright notice must remain intact and unaltered.
//
// You are NOT allowed to modify, edit, or extract parts of my script.
// Any use of my script requires it to remain exactly as provided,
// including this copyright notice.
//
// Any modification or partial use of my script requires
// the explicit permission of the author, Josch Wolf,
// inworld in adult-life.de.
//
// Violations will be pursued under applicable copyright law.


integer currentPrim = 2;
integer currentFace = 0;
integer active = FALSE;
integer primCount = 0;

default
{
    state_entry()
    {
        primCount = llGetNumberOfPrims();

        // Root-Prim unsichtbar machen
        integer face;
        integer totalFaces = llGetNumberOfSides();
        for (face = 0; face < totalFaces; face++)
        {
            llSetAlpha(0.0, face); // Root-Prim vollständig unsichtbar
        }

        llOwnerSay("🐢 Klicke den Root (unsichtbar) zum Starten/Stoppen der Dreh-Animation.");
    }

    touch_start(integer total_number)
    {
        if (!active)
        {
            active = TRUE;
            currentPrim = 2;
            currentFace = 0;
            llSetTimerEvent(0.5); // Timer für Animation

            // Rotation starten (um Y-Achse)
            vector axis = <0, 1, 0> * llGetLocalRot(); // lokale Y-Achse
            llTargetOmega(axis, 1.0, 1.0); // 1.0 = Geschwindigkeit, 1.0 = Glätte
        }
        else
        {
            active = FALSE;
            llSetTimerEvent(0.0);

            // ➤ Alle Child-Prims wieder sichtbar machen (Flächen 0–7)
            integer i;
            integer f;
            for (i = 2; i <= primCount; i++)
            {
                for (f = 0; f <= 7; f++)
                {
                    llSetLinkAlpha(i, 1.0, f);
                }
            }

            // Rotation stoppen
            vector axis = <0, 1, 0> * llGetLocalRot();
            llTargetOmega(axis, 1.0, 0.0);
        }
    }

    timer()
    {
        // ➤ Alle Flächen 0–7 aller Child-Prims unsichtbar
        integer i;
        integer f;
        for (i = 2; i <= primCount; i++)
        {
            for (f = 0; f <= 7; f++)
            {
                llSetLinkAlpha(i, 0.0, f);
            }
        }

        // ➤ Aktuelle Fläche des aktuellen Child-Prims einblenden
        llSetLinkAlpha(currentPrim, 1.0, currentFace);

        // ➤ Nächste Fläche vorbereiten
        currentFace++;
        if (currentFace > 7)
        {
            currentFace = 0;
            currentPrim++;
            if (currentPrim > primCount)
            {
                currentPrim = 2;
            }
        }
    }
}
