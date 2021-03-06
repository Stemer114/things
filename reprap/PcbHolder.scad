//-----------------------------------------------------------------------------------
// printed PCB holder
// based on Optical endstop holder
// see https://github.com/Stemer114/things/tree/master/reprap
// can be either hot-glued or mounted using screws or both
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
F01 = true;  //enable cutout for hot glue mounting to base
F02 = true;  //enable mounting bracket (for slot holes)

//endstop pcb size plus tolerance
P1 = 36;
P2 = 12;
P3 = 3;  //frame width
P4 = 8;  //fixing bracket width
P5 = 20; //fixing bracket length
P6 = 3.2; //fixing slot width
P7 = 14;  //fixing slot length

P10 = 6;  //holder thickness
P11 = 4;   //depth of pcb bed
P12 = 4;   //fixing bracket thickness

P20 = 1;   //corner radius for large block

P21 = 3;  //width of frame for hot glue cutout

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

HolderBase();

//mounting brackets (with slot holes)
if (F02) {
    //move the holders epsilon (de) into the base, so we are surly manifold
    translate([(P1+2*P3-P5)/2, -P4+de, 0])
        Bracket();

    //ditto
    translate([P5+(P1+2*P3-P5)/2, P4+P2+2*P3-de, 0])
        rotate([0, 0, 180])
        Bracket();
}



//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module HolderBase()
{
    difference()
    {
        union()
        {
            //cube([P3+P1+P3, P3+P2+P3, P10], center=false);
            CubeRounded(P3+P1+P3, P3+P2+P3, P10, P20, corners=[1, 1, 1, 1]);

        }  //end union

        union()
        {
            //cutout for PCB
            translate([P3, P3, P10-P11-de])
                cube([P1, P2, P11+2*de], center=false);

            if (F01) {
                //optionally cutout for hot glue mounting to base
                translate([P3+P21, P3+P21, -de])
                    cube([P1-2*P21, P2-2*P21, P10-P11+2*de], center=false);
            }
        } //end union

    }  //end difference
}  //end module HolderBase

module Bracket()
{
    difference()
    {
        union()
        {
            CubeRounded(P5, P4, P12, P20, corners=[1, 1, 0, 0]);
            //cube([P5, P4, P12], center=false);
        }

        union()
        {
            hull() {
            translate([(P5-P7)/2+P6/2, P4/2, -de])
                polyhole(P12+2*de, P6);
            translate([(P5-P7)/2+P7-P6/2, P4/2, -de])
                polyhole(P12+2*de, P6);
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
