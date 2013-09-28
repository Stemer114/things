/*
-----------------------------------------------------------------------------------
 signaling strip for optical endstop
 Z-endstop
 can be attached to platform 
 for my custom Mendel90

 (c) 2013 by Stemer114
 License: licensed under the Creative Commons - GNU GPL license.
          http://www.gnu.org/licenses/gpl-2.0.html
-----------------------------------------------------------------------------------
 Credits: 
 
 MCAD Library - Parametric Involute Bevel and Spur Gears by GregFrost
 It is licensed under the Creative Commons - GNU LGPL 2.1 license.
 http://www.thingiverse.com/thing:3575 and http://www.thingiverse.com/thing:3752

-----------------------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------------
//libraries
//-----------------------------------------------------------------------------------
use <MCAD/polyholes.scad>

//-----------------------------------------------------------------------------------
//display settings
//-----------------------------------------------------------------------------------

//color settings

//-----------------------------------------------------------------------------------
//global configuration settings
//-----------------------------------------------------------------------------------
de = 0.1; //delta param, so differences are scaled and do not become manifold
fn_hole = 12;  //fn setting for round holes/bores (polyhole)
ex = 0;  //offset for Explosivdarstellung, set to 0 for none

//-----------------------------------------------------------------------------------
//parametric settings
//-----------------------------------------------------------------------------------

//holding block
P21 = 8;    //rod diameter
P22 = 5;    //block width beside rod
P23 = 10;   //block depth
P24 = 14;   //block length in rod direction
P25 = 3;    //dia for cable tie bore
P26 = 5;    //offset of cable tie bore from left side (here: upper side)
P27 = 10;   //dia of notch for tigthening cable tie
P28 = 3;    //offset of notch at back of holding block

//strip
P11 = 6;    //width
P12 = 30-P22;   //length (up to rod underside)
P13 = 2;  //thickness




//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

StripZ();


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------


module StripZ()
{
    difference()
    {
        union()
        {
            //strip
           translate([0, 0, 0])
               cube([P12, P11, P13], center=false);

           //holding block
           translate([P12, 0, 0])
               cube([P21+2*P22, P23, P24], center=false);

           //notch for tigthening cable tie
            translate([P12+P22+P21/2, P27/2-P28, 0])
                polyhole(h=P24, d=P27);


        }

        union()
        {
            //cutout in block for rod
            translate([P12+P22+P21/2, P23, -de])
                //rotate([0, 0, 0])
                polyhole(h=P24+2*de, d=P21);

            //upper cable tie bore (here: right bore)
            translate([P12+P22+P21+P22/2, -de, P24-P26])
                rotate([-90, 0, 0])
                polyhole(h=P23+2*de, d=P25);

            //lower cable tie bore (here: left bore)
            translate([P12+P22/2, -de, P24-P26])
                rotate([-90, 0, 0])
                polyhole(h=P23+2*de, d=P25);

        }
    }
}



module Strip()
{
    difference()
    {
        union()
        {
            //holder
           cube([P2+P3, P1, P6], center=false);

           //strip upper part
           translate([P2+P3, (P1-P5)/2, 0])
               cube([P4-P41, P5, P6], center=false);

           //strip lower part (thinner)
           translate([P2+P3+P4-P41, (P1-P5)/2, 0])
               cube([P41, P5, P61], center=false);


           //bracket transversal
           translate([P2, 0, 0])
               cube([P3, P1, P7], center=false);

           //bracket longitudinal
           translate([P2+P3, P1/2-P3/2, 0])
               cube([P4-P41, P3, P7], center=false);


        }

        union()
        {
            //slot hole left
            hull() {
            translate([P2/2, P8+P9/2, -de])
                polyhole(P3+2*de, P9);
            translate([P2/2, P8+P10-P9/2, -de])
                polyhole(P3+2*de, P9);
            }

            //slot hole right 
            translate([0, -P8+P1-P8-P10])
            hull() {
            translate([P2/2, P8+P9/2, -de])
                polyhole(P3+2*de, P9);
            translate([P2/2, P8+P10-P9/2, -de])
                polyhole(P3+2*de, P9);
            }


        }
    }
}


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------
