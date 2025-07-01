// to animate a waterfall in a linkset for saving scripts in each child prim

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

list gLinks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
list gHoriz = [4, 4, 4, 4, 4, 4, 4, 4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4];
list gVert  = [5, 5, 5, 5, 5, 5, 5, 5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5];
list gSpeed = [7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0];

integer side_of_prim = ALL_SIDES;

default
{
    state_entry()
    {
        integer count = llGetListLength(gLinks);
        integer i;

        for (i = 0; i < count; i++)
        {
            integer prim = llList2Integer(gLinks, i);
            integer horiz = llList2Integer(gHoriz, i);
            integer vert = llList2Integer(gVert, i);
            float speed = llList2Float(gSpeed, i);
            integer totalFrames = horiz * vert;

            llSetLinkTextureAnim(
                prim,
                ANIM_ON | LOOP,
                side_of_prim,
                horiz,
                vert,
                0,
                totalFrames,
                speed
            );
        }

    }

    touch_start(integer total_number)
    {
        integer count = llGetListLength(gLinks);
        integer i;

        for (i = 0; i < count; i++)
        {
            integer prim = llList2Integer(gLinks, i);
            llSetLinkTextureAnim(prim, FALSE, side_of_prim, 0, 0, 0, 0, 0);
        }

        llSleep(0.2);

        for (i = 0; i < count; i++)
        {
            integer prim = llList2Integer(gLinks, i);
            integer horiz = llList2Integer(gHoriz, i);
            integer vert = llList2Integer(gVert, i);
            float speed = llList2Float(gSpeed, i);
            integer totalFrames = horiz * vert;

            llSetLinkTextureAnim(
                prim,
                ANIM_ON | LOOP,
                side_of_prim,
                horiz,
                vert,
                0,
                totalFrames,
                speed
            );
        }

      
    }
}
