default
{

    on_rez(integer Dummy)
     {
     llResetScript();
     }

    link_message(integer sender, integer num, string msg, key id)
        {
        if(num == 90060) /|/ OnSit start particle
                {
                   col = <1,1,1>;    /|/ start color = white;
                   alpha = "0.8";
                }

        if(num == 90065)  /|/ OnStand stop particle
                {
                   alpha = "0.0";
                }

        /|/ Colors for AV menu
        
         if(num == -1864099)
                {
                      alpha = "0.0";
                }

        if(num == -1864098)
                {
                   col = <0.86,0.0,0.14>;   /|/ red
                      alpha = "0.8";
                }

        if(num == -1864097)
                {
                   col = <0,0.9,0>;      /|/ green;
                      alpha = "0.8";
                }

        if(num == -1864096)
                {
                   col = <1,1,1>;    /|/ white;
                      alpha = "0.8";
                }

        if(num == -1864095)
                {
                   col =  <0.12,0.1,0.12>;    /|/ black;
                      alpha = "0.8";
                }

         if(num == -1864094)
                {
                   col =  <0.27,0.51,0.71>;    /|/ steel
                      alpha = "0.8";
                }

         if(num == -1864093)
                {
                   col =  <0.1,0.31,0.98>;    /|/blue
                      alpha = "0.8";
                }

         if(num == -1864092)
                {
                   col = <1,.6,0>;    /|/ orange;
                      alpha = "0.8";
                }

         if(num == -1864091)
                {
                   col =  <1,1,0.1>;    /|/ yellow;
                      alpha = "0.8";
                }

         if(num == -1864090)
                {
                   col =  <0.5,0.25,0>;    /|/ brown;
                      alpha = "0.8";
                }

         if(num == -1864089)
                {
                   col =  <0.85,0,0.75>;    /|/ pink;
                      alpha = "0.8";
                }

         if(num == -1864088)
                {
                   col =  <0.8,0.21,0.8>;    /|/ purple;
                      alpha = "0.8";
                }

         if(num == -1864087)
                {
                   col =  <0.18,0.75,0.34>;    /|/ lime;
                      alpha = "0.8";
                }

         if(num == -1864086)
                {
                   col =  <0.53,0.81,0.92>;    /|/ sky;
                      alpha = "0.8";
                }

         if(num == -1864085)
                {
                   col =  <0.2,0.2,0.4>;    /|/lavendar;
                      alpha = "0.8";
                }

         llParticleSystem([
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK
                |PSYS_PART_BOUNCE_MASK
                |PSYS_PART_EMISSIVE_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE ,
            PSYS_PART_START_ALPHA,alpha,
            PSYS_PART_END_ALPHA,0,
            PSYS_PART_START_COLOR,col,
            PSYS_PART_END_COLOR,<1,1,1> ,
            PSYS_PART_START_SCALE,<0.25,0.25,0>,
            PSYS_PART_END_SCALE,<0.03125,0.25,0>,
            PSYS_PART_MAX_AGE,2.5,
            PSYS_SRC_MAX_AGE,0,
            PSYS_SRC_ACCEL,<0,0,1>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,1.25,
            PSYS_SRC_BURST_RATE,0.01,
            PSYS_SRC_BURST_SPEED_MIN,0,
            PSYS_SRC_BURST_SPEED_MAX,0,
            PSYS_SRC_ANGLE_BEGIN,1.53125,
            PSYS_SRC_ANGLE_END,3.5625,
            PSYS_SRC_OMEGA,<0,0,1>,
            PSYS_SRC_TEXTURE, _texture,
            PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
         ]);
    }
}*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 6.3.9.58205 - Joschua Black
//last_compiled 08/18/2020 08:29:06
//mono


















 key _texture ="ad362edf-a193-472f-9d0e-03cef4a2bb26";  







vector col;
float alpha;


default
{

    on_rez(integer Dummy)
     {
     llResetScript();
     }

    link_message(integer sender, integer num, string msg, key id)
        {
        if(num == 90060) 
                {
                   col = <1,1,1>;    
                   alpha = "0.8";
                }

        if(num == 90065)  
                {
                   alpha = "0.0";
                }

        
        
         if(num == -1864099)
                {
                      alpha = "0.0";
                }

        if(num == -1864098)
                {
                   col = <0.86,0.0,0.14>;   
                      alpha = "0.8";
                }

        if(num == -1864097)
                {
                   col = <0,0.9,0>;      
                      alpha = "0.8";
                }

        if(num == -1864096)
                {
                   col = <1,1,1>;    
                      alpha = "0.8";
                }

        if(num == -1864095)
                {
                   col =  <0.12,0.1,0.12>;    
                      alpha = "0.8";
                }

         if(num == -1864094)
                {
                   col =  <0.27,0.51,0.71>;    
                      alpha = "0.8";
                }

         if(num == -1864093)
                {
                   col =  <0.1,0.31,0.98>;    
                      alpha = "0.8";
                }

         if(num == -1864092)
                {
                   col = <1,.6,0>;    
                      alpha = "0.8";
                }

         if(num == -1864091)
                {
                   col =  <1,1,0.1>;    
                      alpha = "0.8";
                }

         if(num == -1864090)
                {
                   col =  <0.5,0.25,0>;    
                      alpha = "0.8";
                }

         if(num == -1864089)
                {
                   col =  <0.85,0,0.75>;    
                      alpha = "0.8";
                }

         if(num == -1864088)
                {
                   col =  <0.8,0.21,0.8>;    
                      alpha = "0.8";
                }

         if(num == -1864087)
                {
                   col =  <0.18,0.75,0.34>;    
                      alpha = "0.8";
                }

         if(num == -1864086)
                {
                   col =  <0.53,0.81,0.92>;    
                      alpha = "0.8";
                }

         if(num == -1864085)
                {
                   col =  <0.2,0.2,0.4>;    
                      alpha = "0.8";
                }

         llParticleSystem([
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK
                |PSYS_PART_BOUNCE_MASK
                |PSYS_PART_EMISSIVE_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE ,
            PSYS_PART_START_ALPHA,alpha,
            PSYS_PART_END_ALPHA,0,
            PSYS_PART_START_COLOR,col,
            PSYS_PART_END_COLOR,<1,1,1> ,
            PSYS_PART_START_SCALE,<0.25,0.25,0>,
            PSYS_PART_END_SCALE,<0.03125,0.25,0>,
            PSYS_PART_MAX_AGE,2.5,
            PSYS_SRC_MAX_AGE,0,
            PSYS_SRC_ACCEL,<0,0,1>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,1.25,
            PSYS_SRC_BURST_RATE,0.01,
            PSYS_SRC_BURST_SPEED_MIN,0,
            PSYS_SRC_BURST_SPEED_MAX,0,
            PSYS_SRC_ANGLE_BEGIN,1.53125,
            PSYS_SRC_ANGLE_END,3.5625,
            PSYS_SRC_OMEGA,<0,0,1>,
            PSYS_SRC_TEXTURE, _texture,
            PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
         ]);
    }
}
