key owner_sit;
string owner_sit_text ="Only the Owner can sit here !";

default{
    changed(integer change){
          owner_sit = llGetObjectDesc();
       if(change & CHANGED_LINK)  
        {
           key av = llAvatarOnSitTarget();
            if(av){
                
                if (av != owner_sit) {
                llSay(0, owner_sit_text);
                llUnSit(av);
            }
        }
        }
}
}
