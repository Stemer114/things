//-----------------------------------------------------------------------------------
// printed spool holder
// derived from Mendel90 spool holder (customizable)
// (http://www.thingiverse.com/thing:77004)
// by CookieMonster
//
// scad written from scratch because I am still learning
// see https://github.com/Stemer114/things/tree/master/reprap
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

P1 = 90;  //spool holder length atop stays
P2 = 5;   //bracket thickness
P3 = 15;  //bracket depth
P4 = 40;  //bracket length

P5 = 10.2;  //hole dia (for rod)
P6 = 15;    //hole cutout length
P7 = 20;    //holder top width
P8 = 20;    //holder top length
P9 = P1-P8; //holder bottom length
P101 = 5;    //arm upper thickness (after cutout has been removed)
P102 = 8;    //arm lower thickness

P20 = 5;    //bracket thickness against stay
P21 = 12;   //stay (MDF) thickness
P22 = P20+P21;  //spool holder thickness

P30 = 4.2;  //fixing hole dia
P31 = 25;   //fixing hole spacing apart


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

HolderTop();


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module HolderTop()
{
    difference()
    {
        union()
        {
            //holder top is convex hull of two cubes
            hull() {
                translate([0, -P7/2, 0])
                    cube([P8, P7, P22], center=false);
                translate([P7+P9, -P4/2, 0])
                    cube([P2, P4, P22], center=false);
            }

            //bracket lower part which will rest against stays
            translate([P8+P9+P2, -P4/2, 0])
                cube([P3, P4, P20], center=false);
 

        }  //end union

        union()
        {
            //fixing holes in mounting bracket
            translate([P1+P2+P3/2, P31/2, -de])
                polyhole(P20+2*de, P30);
            translate([P1+P2+P3/2, -P31/2, -de])
                polyhole(P20+2*de, P30);

            //slot for rod
            hull() {
                translate([-P5/2+P6, 0, -de])
                    polyhole(P22+2*de, P5);
                translate([-de, -P5/2, -de])
                    cube([10*de, P5, P22+2*de], center=false);
            }

            //cutout in holder
            hull() {
                translate([(P7-2*P101)/2+P8, 0, -de])
                    polyhole(P22+2*de, P7-2*P101);
                translate([-10*de+P1, -(P4-2*P102)/2, -de])
                    cube([10*de, P4-2*P102, P22+2*de], center=false);
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
