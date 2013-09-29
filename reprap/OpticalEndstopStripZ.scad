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

show_block1 = true;  //holding block with strip
show_block2 = true;  //holding block at rear of rod

//-----------------------------------------------------------------------------------
//parametric settings
//-----------------------------------------------------------------------------------

//holding blocks
P20 = 1.0;   //gap width between holding blocks

//holding block - strip side
P21 = 8;    //rod diameter
P22 = 9;    //block width beside rod
P23 = 10;   //block depth
P24 = 16;   //block length in rod direction
P25 = 3;    //dia for cable tie bore
P26 = 5;    //offset of cable tie bore from left side (here: upper side)
P27 = 10;   //dia of notch for tigthening cable tie
P28 = 3;    //offset of notch at back of holding block

//holding block - rear side
P33 = 6;    //depth (thinner)
P34 = 10;   //length (shorter)
P35 = 5.5;  //nut trap wrench size
P36 = 3.5;  //nut trap depth (nyloc nut)

//strip
P11 = 6;    //width
P12 = 30-P22;   //length (up to rod underside)
P13 = 2.0;  //thickness
P14 = 1.2;  //lower thickness
P15 = 15;   //length of lower thickness




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
            //holding block with strip
            if (show_block1) {
            //strip
            translate([0, 0, 0])
                union() {
                    //upper part (base thickness)
                    translate([P15, 0, 0]) cube([P12-P15, P11, P13], center=false);
                    //lower part (thinner)
                    cube([P15, P11, P14], center=false);
                }

            //holding block - strip side
            translate([P12, 0, 0])
                cube([P21+2*P22, P23, P24], center=false);

            //notch for tigthening cable tie
            //translate([P12+P22+P21/2, P27/2-P28, 0])
                //polyhole(h=P24, d=P27);
            }


            //holding block at rear of rod, gap to holding block 1
            if (show_block2) {
                translate([P12, P23+P20, P24-P34])
                    cube([P21+2*P22, P33, P34], center=false);

            }
        }

        union()
        {
            //cutout in blocks for rod
            //(moved half gap width into gap)
            translate([P12+P22+P21/2, P23+P20/2, -de])
                polyhole(h=P24+2*de, d=P21);

                //upper bore (here: right bore)
                translate([P12+P22+P21+P22/2, -de, P24-P26])
                rotate([-90, 0, 0])
                polyhole(h=P23+P20+P33+2*de, d=P25);

            //lower bore (here: left bore)
            translate([P12+P22/2, -de, P24-P26])
                rotate([-90, 0, 0])
                polyhole(h=P23+P20+P33+2*de, d=P25);

            //nut trap in block2 left
            translate([P12+P22/2, P23+P20+P33-P36+de, P24-P26])
                rotate([-90,90,0])
                cylinder(r = P35 / 2 / cos(180 / 6) + 0.05, h=P36, $fn=6);
            //nut trap in block2 right
            translate([P12+P22+P21+P22/2, P23+P20+P33-P36+de, P24-P26])
                rotate([-90,90,0])
                cylinder(r = P35 / 2 / cos(180 / 6) + 0.05, h=P36, $fn=6);


        }
    }
}



//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------
