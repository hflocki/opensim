/******************************************************************
* This example will hide a prim when certain poses are played.
* Place this script into the prim you want to make invisible.
******************************************************************/

// POSES: List of poses we want to make the prim invisible.
list POSES = ["✧ cockslap","✧ whipping 1","✧ whipping 2"];

// SITTER: If we only show/hide for a certain SITTER, or use -1 for all sitters.
integer SITTER=-1;

/******************************************************************
 * DON'T EDIT BELOW THIS UNLESS YOU KNOW WHAT YOU'RE DOING!
******************************************************************/

default{
    link_message(integer sender, integer num, string msg, key id){
        if(num==90045){
            list data = llParseStringKeepNulls(msg,["|"],[]);
            integer SITTER_NUMBER = (integer)llList2String(data,0);
            if(SITTER==-1 || SITTER==SITTER_NUMBER){
                string POSE_NAME = llList2String(data,1);
                if(llListFindList(POSES,[POSE_NAME])!=-1){
                    llSetLinkAlpha(8, 0,ALL_SIDES);//invisible
                    llSetLinkAlpha(9, 0,ALL_SIDES);//invisible
                    llSetLinkAlpha(10, 0,ALL_SIDES);//invisible
                }
                else{
                    llSetLinkAlpha(8 ,1,ALL_SIDES);//visible
                    llSetLinkAlpha(9 ,1,ALL_SIDES);//visible
                    llSetLinkAlpha(10 ,1,ALL_SIDES);//visible

                }
            }            
        }
        else if(num==90065){//sitter stands up
            if(llGetAgentSize(llGetLinkKey(llGetNumberOfPrims()))==ZERO_VECTOR || (integer)msg==SITTER){
                llSetLinkAlpha(8, 1,ALL_SIDES);//visible
                llSetLinkAlpha(9 ,1,ALL_SIDES);//visible
                llSetLinkAlpha(10 ,1,ALL_SIDES);//visible
            }
        }
    }
}