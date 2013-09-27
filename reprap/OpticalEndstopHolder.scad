//-----------------------------------------------------------------------------------
// printed holder for optical endstop 
// Gen7 v1.3.1 opto endstop, veroboard version
// by Traumflug
// see http://reprap.org/wiki/Gen7_Endstop_1.3.1
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
/* bracket alignment:
   0 - brackets parallel to sides 1
   1 - brackets perpendicular to sides 1 (and in line with each other)
   (the latter makes it easier sliding the holder lengthwise, as one screw guides
   while the other screw can be loosened or tightened)
   I use the configuration for the z end stop for easy calibration
 */
bracket_alignment = 1; // 0 - parallel (at sides), 1 - in line (top and bottom)

//endstop pcb size plus tolerance
P1 = 41; //length side 1 (which side is longer is up to you, depending
P2 = 21; //length side 2  where you want the brackets located)
P3 = 3;  //frame width
P4 = 10;  //fixing bracket width
P5 = 20; //fixing bracket length
P6 = 3.2; //fixing slot width
P7 = 14;  //fixing slot length

P10 = 10;  //holder thickness
P11 = 4;   //depth of pcb bed
P12 = 4;   //fixing bracket thickness

P20 = 1;   //corner radius for large block

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

if (bracket_alignment == 0) {
    //bracket configuration: two parallel brackets at the sides

    //move the holders de into the base, so we are surly manifold
    translate([(P1+2*P3-P5)/2, -P4+de, 0])
        ParallelBracket();

    //ditto
    translate([P5+(P1+2*P3-P5)/2, P4+P2+2*P3-de, 0])
        rotate([0, 0, 180])
        ParallelBracket();

} else if (bracket_alignment == 1) {
    //bracket configuration: two in line brackets at top and bottom
    // (this configuration allows for better (parallel) alignment of the holder)

    //move the holders de into the base, so we are surly manifold
    translate([(P1+2*P3)/2 - P4/2, de, 0])
        rotate([0, 0, -90])
        PerpendicularBracket();

    //ditto
    translate([(P1+2*P3)/2 - P4/2, P2+2*P3+P5-de, 0])
        rotate([0, 0, -90])
        PerpendicularBracket();
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

        }

        union()
        {
            translate([P3, P3, P10-P11+de])
            cube([P1, P2, P11+de], center=false);

        }
    }
}

module ParallelBracket()
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


module PerpendicularBracket()
{
    difference()
    {
        union()
        {
            CubeRounded(P5, P4, P12, P20, corners=[0, 0, 0, 0]);
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
