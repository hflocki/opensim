/*
For AVpos NC

TOMENU Sits
TOMENU Texture

MENU Texture
BUTTON [01]|301
BUTTON [02]|302
BUTTON [03]|303

*/

integer number = 301;
string message = "Texture";
default {
    
    touch_start(integer touched){
        if(llGetAgentSize(llGetLinkKey(llGetNumberOfPrims()))==ZERO_VECTOR){ // nobody sitting
            llMessageLinked(LINK_SET,number,message,llDetectedKey(0));
        }
    }
    
        
    link_message(integer sender, integer num, string msg, key id)
    {
      
          if(num==301)
          {  llSetTexture("debbc2e1-5df3-fb60-9625-8abac2f4c48f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==302)
          {  llSetTexture("8930e855-0a37-296f-4214-6757eaf3577b", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==303)
          {  llSetTexture("3a695d56-31a5-f0c2-da77-14b284bf42cd", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==304)
          {  llSetTexture("671194f7-40d0-2e54-ba85-11f9703dbb45", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==305)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==300)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==307)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21fc", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==308)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==309)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
          
          if(num==310)
          {  llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f", ALL_SIDES);
          llMessageLinked(LINK_SET,90005,"",id);//return menu
          }
            
         
    }
    

}

