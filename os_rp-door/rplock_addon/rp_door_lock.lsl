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

integer pickingTime = 60;
integer listenId;
list visitor_menu = ["✊ Knock","✊✊ KNOCK", "⚒ Lockpick ⚒","Close"];
list owner_menu = ["Lock", "Unlock","Repair","Close"];
integer distance;
string animation;
integer channelDialog;
key ToucherID;
string avatarName;
string message;
integer door_state;
string door_text;
string privilegs;
integer same_group;
integer counter;

unlocking()
{
 llMessageLinked(LINK_SET, 0, "unlock", "");
 llSetAlpha(1.0,0);
}

locking()
{
  llMessageLinked(LINK_SET, 0, "lock", ""); 
  llSetAlpha(0.0,0); 
}

repairing()
{
  llWhisper(0, avatarName+ " you have repaired the broken lock.");
  llSetText("", ZERO_VECTOR, 0);
  llSetAlpha(1.0,0);
}

default
{
    state_entry()
    { 
        channelDialog = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
         if (door_state==1) 
            {
            door_text="Locked";
            } 

         if (door_state==0)
            {
            door_text="Unlocked";
            }
         privilegs=llGetObjectDesc();
         
        
    }
    
    touch_start(integer num_detected)
    {
       ToucherID = llDetectedKey(0);
       avatarName = llDetectedName(0);
        if (privilegs =="GROUP")
        {
        integer sameGroup = llSameGroup(ToucherID);
        if (sameGroup)
        {
            same_group=1;
        }
        
        else
        {
            same_group=0;
        }
     }
        vector pos = llDetectedPos(0);
        float dist = llVecDist(pos, llGetPos() );
        
        if ( dist <= 2)
        {
        if (llGetOwner() == ToucherID || same_group==1){
        message = "What do do?\nThe door is " + door_text;
        llDialog(ToucherID, message, owner_menu, channelDialog);
        }
        
        else 

        { 
        message = "What to do?\nThe door is " + door_text;
        llDialog(ToucherID, message, visitor_menu, channelDialog);
        }
        
        listenId = llListen(channelDialog, "", ToucherID, "");
        }
        
        else 
        {
           llSay (0,llKey2Name(ToucherID) +", that's to magic... Come closer...");
        }
    }
    
       listen(integer channel, string name, key id, string message)
        {  
        if (message == "✊ Knock")
        {
           llSay(0, avatarName+ " Knock the door");
        }
        
        if (message == "✊✊ KNOCK")
        {
           llShout(0, avatarName+ " KNOCK the door");
        }
        
        else if (message == "⚒ Lockpick ⚒")
        {
           llSetTimerEvent(pickingTime); 
          // Sensor prüfung sonst Abbruch
           llWhisper(0, avatarName+ " Stay here and wait, this need some time to pick the lock ....");  
           llSetTimerEvent(pickingTime);
           counter = 0;  
        }
        
        else if (message == "Lock")
        {
           door_state = 1;
           locking();  
        }
        else if (message == "Unlock")
        {
           door_state = 0;
           unlocking();
        }
        
        else if (message == "Repair")
        {
           repairing();
        }
        
        else if (message == "Close")
        {
           llListenRemove(listenId);
        }
    }
    
    timer()
    {   
     ++counter;
     llSetText(avatarName+ " have pick the lock.",<1.0,0.0,0.0>, 1);  
     llMessageLinked(LINK_SET, 0, "unlock", "");   
     llWhisper(0,"The door is now open.");
     llSetTimerEvent(0.0);
    }
  
}
