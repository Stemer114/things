//-----------------------------------------------------------------------------------
// 2013-07-09
// holder for optical endstop (Gen7 v1.1 opto endstop)
// for my custom Mendel90
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
P1 = 41;
P2 = 21;
P3 = 3;  //frame width
P4 = 8;  //fixing bracket width
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

//move the holders de into the base, so we are surly manifold
translate([(P1+2*P3-P5)/2, -P4+de, 0])
    Bracket();

//ditto
translate([P5+(P1+2*P3-P5)/2, P4+P2+2*P3-de, 0])
rotate([0, 0, 180])
    Bracket();


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
module polyhole(h, d) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

/** Create a hexagon.
 *  with different sizes for base and top
 *  based on common.scad hexagon
 *  now abandonde because normal cylinder was used
 *
 * The 'size' parameter specifies the distance from the center of the
 * hexagon to the center of one of the six straight edges. The 'depth'
 * parameter specifies the size in the Z axis. The resulting object
 * is centered on the origin.
 */
module hexagon2(length1, length2, depth = 2) {
    width1 = 2 * length1 * tan(30);
    union() {
        cube(size = [ length1 * 2, width1, depth ], center = true);
        rotate(a = [ 0, 0, 60 ]) {
            cube(size = [ length1 * 2, width1, depth ], center = true);
        }
        rotate(a = [ 0, 0, -60 ]) {
            cube(size = [ length * 2, width, depth ], center = true);
        }
    }
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
