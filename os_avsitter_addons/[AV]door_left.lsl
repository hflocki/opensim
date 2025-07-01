// [AV]door_left
integer SITTER = 0;
list POSES = [" blowjob 1", " blowjob 2", " blowjob 3", " fuck 1", " fuck 2", " fuck 3", " fuck 4", " fuck 5", " fuck 6", " fuck 7", " fuck 8", " fuck 9", " fuck 10", " fuck 11", " fuck 12", " fuck 13", " fuck 14", " handjob", " MM jerking", " cockslap", " face cum"];

vector      ROTATION            = <0.0, 0.0, -105.0>; // swing for door in degrees Y is how tall this particlar door is
vector      HINGE_POSITION      = <-0.35, 0.016, 0.0>; // X is distance from edge of door defined by Z w  
float       SECONDS_TO_ROTATE   = 0.8; //Define how fast the door opens, in seconds
float       AUTO_CLOSE_TIME     = 10; // 0 to disable
key         SOUND_ON_OPEN       = "e5e01091-9c1f-4f8c-8486-46d560ff664f";
key         SOUND_ON_CLOSE      = "88d13f1f-85a8-49da-99f7-6fa2781b2229";
float       SOUND_VOLUME        = 1.0;
//.......................................................................................... 
/*
* Rotation: Define the rotation in degrees, using the door prim's local coordinate system
* Hinge: Define the position of the virtual hinge; usually this is half the door
* prim's width and thickness (Move Point in the Middle this is the half prim!)
*/
//.......................................................................................... 

integer     gClosed;            // Door state: TRUE = closed, FALSE = opened
rotation    gRotationClosed;    // Initial rotation of the door (closed)
vector      gPositionClosed;    // Initial position of the door (closed)
vector      gRotationPerSecond; // The amount to rotate each second
 
doOpenOrClose() {
    /*
     * Only perform the rotation if the door isn't root or unlinked
     */
    integer linkNumber = llGetLinkNumber();
    if (linkNumber < 2)
        return;
 
    if (gClosed) {
        /*
         * Store the initial rotation and position so we can return to it.
         *
         * Rotating back purely by calculations can in the longer term cause the door
         * to be positioned incorrectly because of precision errors
         *
         * We determine this everytime before the door is being opened in case it was
         * moved, assuming the door was closed whilst being manipulated.
         */
        gPositionClosed = llGetLocalPos();
        gRotationClosed = llGetLocalRot();

        if (SOUND_ON_OPEN)
            llPlaySound(SOUND_ON_OPEN, SOUND_VOLUME);
    }
 
    vector hingePosition = gPositionClosed + HINGE_POSITION * gRotationClosed;
 
    /*
     * Reset the timer and start moving
     */
    llResetTime();
    while (llGetTime() < SECONDS_TO_ROTATE) {
        float time = llGetTime();
        if (! gClosed)
            /*
             * Invert the timer for closing direction
             */
            time = SECONDS_TO_ROTATE - time;
 
        rotation rotationThisStep = llEuler2Rot(gRotationPerSecond * time) * gRotationClosed;
        vector positionThisStep = hingePosition - HINGE_POSITION * rotationThisStep;
        llSetLinkPrimitiveParamsFast(linkNumber, [PRIM_ROT_LOCAL, rotationThisStep, PRIM_POS_LOCAL, positionThisStep]);
    }
 
    /*
     * Set the new state
     */
    gClosed = !gClosed;
 
    if (gClosed) {
        /*
         * Finalize the closing movement
         */
        llSetLinkPrimitiveParamsFast(linkNumber, [PRIM_ROT_LOCAL, gRotationClosed, PRIM_POS_LOCAL, gPositionClosed]);
 
        /*
         * Play the closing sound and preload the opening sound
         */
        if (SOUND_ON_CLOSE)
            llPlaySound(SOUND_ON_CLOSE, SOUND_VOLUME);
        if (SOUND_ON_OPEN)
            llPreloadSound(SOUND_ON_OPEN);
    } else {
        /*
         * Finalize the opening movement
         */
        rotation rotationOpened = llEuler2Rot(ROTATION * DEG_TO_RAD) * gRotationClosed;
        vector positionOpened = hingePosition - HINGE_POSITION * rotationOpened;
        llSetLinkPrimitiveParamsFast(linkNumber, [PRIM_ROT_LOCAL, rotationOpened, PRIM_POS_LOCAL, positionOpened]);
 

        if (SOUND_ON_CLOSE)
            llPreloadSound(SOUND_ON_CLOSE);
 

        llSetTimerEvent(AUTO_CLOSE_TIME);
    }
}

default{
    
    state_entry() {
       
        gClosed = TRUE;
        gRotationPerSecond = (ROTATION * DEG_TO_RAD / SECONDS_TO_ROTATE);
        if (SOUND_ON_OPEN)
            llPreloadSound(SOUND_ON_OPEN);
    }
    
    link_message(integer sender, integer num, string msg, key id){
        if(num==90045){
            list data = llParseStringKeepNulls(msg,["|"],[]);
            integer SITTER_NUMBER = (integer)llList2String(data,0);
            if(SITTER==-1 || SITTER==SITTER_NUMBER){
                string POSE_NAME = llList2String(data,1);
                if(llListFindList(POSES,[POSE_NAME])!=-1){                  
                     if (! gClosed)
                    doOpenOrClose();
                }
                else{
                   
                    doOpenOrClose();
                }
            }            
        }
        else if(num==90065){//sitter stands up
            if(llGetAgentSize(llGetLinkKey(llGetNumberOfPrims()))==ZERO_VECTOR || (integer)msg==SITTER){             
                     if (! gClosed)
                    doOpenOrClose();
            }
        }
    }
}
