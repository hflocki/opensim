//rope climber 
// after configuration reset the scripts 
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

// Konfiguration
vector startPosition;
vector endOffset = <0, 0, 10.2>;     // Zielhöhe
float speed_up = 1.0;              // Geschwindigkeit nach oben
float speed_down = 5.0;            // Geschwindigkeit nach unten
string anim = "climb";

integer avatarOn = FALSE;
integer isMoving = FALSE;

default
{
    state_entry()
    {
        startPosition = llGetPos();
        llSitTarget(<0.0, 0.0, 0.5>, ZERO_ROTATION);
        llSetText("Sit to climb",<1.0,1.0,1.0>,1.0);
        llSetClickAction(CLICK_ACTION_SIT);

    }

    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            if (av != NULL_KEY)
            {
                llSetAlpha(0.0,ALL_SIDES);
                avatarOn = TRUE;
                llSetText("Sit to climb",<1.0,1.0,1.0>,1.0);
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
            }
            else if (avatarOn)
            {
                avatarOn = FALSE;
                llStopAnimation(anim);
                if (!isMoving)
                {

                    moveTo(startPosition, speed_down);
                    llSetText("Sit to climb",<1.0,1.0,1.0>,1.0);
                    llSetAlpha(0.25,ALL_SIDES);
                }
            }
        }
    }

    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TRIGGER_ANIMATION)
        {
            llStartAnimation(anim);
            llSetText("", ZERO_VECTOR, 0);
            vector target = startPosition + endOffset;
            moveTo(target, speed_up);
        }
    }
}


moveTo(vector targetPos, float speed)
{
    isMoving = TRUE;
    vector current = llGetPos();
    vector delta = targetPos - current;
    float distance = llVecDist(current, targetPos);
    float duration = distance / speed;

    integer steps = (integer)(duration / 0.1);
    integer i;
    for (i = 0; i <= steps; i++)
    {
        float t = (float)i / (float)steps;
        vector pos = current + delta * t;
        llSetRegionPos(pos);
        llSleep(0.1);
    }

    llSetRegionPos(targetPos);
    isMoving = FALSE;
}
