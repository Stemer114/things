//-----------------------------------------------------------------------------------
// signaling strip for optical endstop
// can be attached to platform 
// for my custom Mendel90
// for the y min endstop (the endstop holder is screwed onto the base plate)
// (c) 2013 by Stemer114
// License: licensed under the Creative Commons - GNU GPL license.
//          http://www.gnu.org/licenses/gpl-2.0.html
//-----------------------------------------------------------------------------------

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
//configuration settings
//-----------------------------------------------------------------------------------

//endstop pcb size plus tolerance
P1 = 40;  //top width
P2 = 8;   //plate thickness
P3 = 4;   //bracket thickness
P4 = 28.5 - P3; //strip length
P41 = 10;     //lower strip length
P5 = 10;  //strip widh
P6 = 2.4;   //strip thickness
P61 = 1.2;  //strip lower thickness
P7 = 10;  //bracket width
P8 = 3;   //slot hole offset from edge
P9 = 3.2; //slot hole dia
P10 = 12;  //slot hole length

//-----------------------------------------------------------------------------------
// libraries
//-----------------------------------------------------------------------------------
//include <lib/common.scad>

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------


//transparent 10mm cube for debugging
//translate([0, 0, -10])
//% cube(10, 10, 10);

Strip();


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

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

//polyhole by nophead
//see http://hydraraptor.blogspot.de/2011/02/polyholes.html
module polyhole(h, d) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}


/* creates a cube with rounded corners in z direction
   with the corners array it can be specified, which corners are rounded
   (default: all)
   */
module CubeRounded(x, y, z, r, corners=[1, 1, 1, 1]) {
    $fn=20;

    hull() {
        //lower left
        translate([r, r, 0]) 
            CubeCorner(r, z, corners[0]);

        //lower right
        translate([x-r, r, 0])
            CubeCorner(r, z, corners[1]);

        //upper left
        translate([r, y-r, 0])
            CubeCorner(r, z, corners[2]);

        //upper right
        translate([x-r, y-r, 0])
            CubeCorner(r, z, corners[3]);
    }
}

module CubeCorner(r, z, cornermode) {
    if (cornermode==1) {
        cylinder(h=z, r=r);
    } else {
        translate([0, 0, z/2])
            cube([2*r, 2*r, z], center=true);
    }
} 
