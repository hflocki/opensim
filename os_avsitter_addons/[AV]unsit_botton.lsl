/*
Add in AVpos NC
BUTTON UNSIT|-3455

*/





default{
    link_message(integer sender, integer num, string msg, key id){
        if(msg=="UNSIT"){
            integer count = llGetNumberOfPrims();
            list avatars;
            while (llGetAgentSize(llGetLinkKey(count)) != ZERO_VECTOR){ // prim is an avatar!
                if(llGetLinkKey(count)!=id){ // not the avatar who pressed the BUTTON
                    llUnSit(llGetLinkKey(count)); // unsit them!
                }
                count--;
            }                
        }
    }
}