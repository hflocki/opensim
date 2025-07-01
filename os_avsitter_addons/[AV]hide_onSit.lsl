default
{

    on_rez(integer Dummy)
     {
     llResetScript();
     }

    link_message(integer sender, integer num, string msg, key id)
        {

// Hide onSit            
        if(num == 90060) 
                {
//                    llSetLinkAlpha(1, 0.0, ALL_SIDES);
                    llSetLinkAlpha(2, 0.0, ALL_SIDES);
                    llSetLinkAlpha(3, 0.0, ALL_SIDES); 
//                    llSetLinkAlpha(4, 0.0, ALL_SIDES);
//                    llSetLinkAlpha(5, 0.0, ALL_SIDES);
//                    llSetLinkAlpha(6, 0.0, ALL_SIDES);
//                    llSetLinkAlpha(7, 0.0, ALL_SIDES);
                    llSetLinkAlpha(8, 0.0, ALL_SIDES); 
//                    llSetLinkAlpha(9, 0.0, ALL_SIDES); 
//                    llSetLinkAlpha(10, 0.0, ALL_SIDES); 
                }

//Show OnUnsit
        if(num == 90065)  
                {
//                    llSetLinkAlpha(1, 1.0, ALL_SIDES);
                    llSetLinkAlpha(2, 1.0, ALL_SIDES);
                    llSetLinkAlpha(3, 1.0, ALL_SIDES); 
//                    llSetLinkAlpha(4, 1.0, ALL_SIDES);
//                    llSetLinkAlpha(5, 1.0, ALL_SIDES);
//                    llSetLinkAlpha(6, 1.0, ALL_SIDES);
//                    llSetLinkAlpha(7, 1.0, ALL_SIDES);
                    llSetLinkAlpha(8, 1.0, ALL_SIDES); 
//                    llSetLinkAlpha(9, 1.0, ALL_SIDES); 
//                    llSetLinkAlpha(10, 1.0, ALL_SIDES); 
                }

    

    }
}
