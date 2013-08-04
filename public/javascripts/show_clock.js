 <!-- hide the code from old browsers that do not support javascript

        /*
           Original: daniusr


             You are welcomed to modify this script to your needs.
          
           This script retrieves the time from the internal system clock, 
           so it is up to you to make sure the time is accurate or correct. 
        */


  function clock()
  {
     var today = new Date();
     var hours = today.getHours();
     var minutes = today.getMinutes();
     var seconds = today.getSeconds();
     var time_holder; // holds the time

       //if the first radio button is checked display 12-hours format time
       
                // add "AM" or "PM" if the 12-hours format is chosen
                var ampm = ((hours >= 12) ? " PM" : " AM");    
                
                // convert the hour to 12-hours format
                // javascript returns midnight as 0, but since the time is in the 12-hours format
                // force javascript to return 12
                hours = ((hours == 0) ? "12" : (hours > 12) ? hours - 12 : hours); 
               
                // add a leading zero if less than 10
                minutes = ((minutes < 10) ? "0" + minutes : minutes); 
                seconds = ((seconds < 10) ? "0" + seconds : seconds);
                
                time_holder = hours + ":" + minutes + ":" + seconds + ampm;
 
                 document.getElementById('jsClock').innerHTML =  time_holder;
           // keep the clock ticking
     setTimeout("clock()", 1000);
}
// end hiding -->