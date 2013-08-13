//-----------------------------------------------------------------------------------
// fan holder for custom mendel 90
// can be mounted on RHS of mendel 90 for cooling 
// sanguinololu/stepper drivers
//
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
ly = 0.4;  //layer thickness for printing

//-----------------------------------------------------------------------------------
//configuration settings
//-----------------------------------------------------------------------------------

P01 = 80;      //fan size
P02 = 1;       //offset for loose fit of fan
P1 = P01+P02;  //calulated fan size for loose fit
P2 = 85;       //fan offset (distance from mounting wall to middle of fan)

P3 = 5;   //outer wall thickness
P4 = 10;  //outer wall height
P5 = ly * 6; //base plate thickness (default 10 layers giving 4mm)

P10 = 3.6;  //mounting holes (wall) diameter
P11 = 15;   //mounting holes offset from side

P20 = 5;    //fan mounting holes diameter
P21 = 4+P02;    //fan mounting holes offset from edge
P22 = 78;   //fanguard cutout

//fanguard settings
P30 = 4;    //spoke outer dia
P31 = 4;    //spoke inner dia
P32 = P1/2; //spoke length
P33 = 2;    //spoke thickness
P34 = 6;    //spoke count
P35 = 15;   //center piece dia

//holder cutout (beside fan)
P40 = 5;  //corner diameter
P41 = 6;  //corner offset from frame
P42 = P2-P1/2-P3; //cutout dimension in x-direction (calculated)
P43 = P1/2;         //cutout dimension in y-direction (calculated)
 
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

Holder();

translate([P2, P3+P1/2, 0])
    FanGuard();


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module Holder()
{
    difference()
    {
        union()
        {
            //base plate
            translate([0, 0, 0])
                cube([P2+P1/2+P3, P1+2*P3, P5], center=false);

            //frame walls
            //fixing side
            translate([0, 0, P5])
                cube([P3, P1+2*P3, P4], center=false);
            //lateral walls
            translate([0, 0, P5])
                cube([P2+P1/2+P3, P3, P4], center=false);
            translate([0, P3+P1, P5])
                cube([P2+P1/2+P3, P3, P4], center=false);
            //fans side
            translate([P2+P1/2, 0, P5])
                cube([P3, P1+2*P3, P4], center=false);
 


        }  //end union

        union()
        {
            //mounting holes (wall side)
            translate([-de, P11, P5+P4/2])
                rotate([0, 90, 0])
                polyhole(P3+2*de, P10);
            translate([-de, P1+2*P3-P11, P5+P4/2])
                rotate([0, 90, 0])
                polyhole(P3+2*de, P10);

            //fan mounting holes and fanguard cutout
            translate([P2, P3+P1/2, 0])
            {
                translate([-P1/2+P21, -P1/2+P21, -de]) polyhole(P5+2*de, P20);
                translate([-P1/2+P21, +P1/2-P21, -de]) polyhole(P5+2*de, P20);
                translate([+P1/2-P21, -P1/2+P21, -de]) polyhole(P5+2*de, P20);
                translate([+P1/2-P21, +P1/2-P21, -de]) polyhole(P5+2*de, P20);

                translate([0, 0, -de]) polyhole(P5+2*de, P22);
            }
 
            //base plate cutout (twice)
            translate([P3+P42/2, P3+P43/2, 0])
            {
                hull() {
                    translate([-P42/2+P41, -P43/2+P41, -de]) polyhole(P5+2*de, P40);
                    translate([-P42/2+P41, +P43/2-P41, -de]) polyhole(P5+2*de, P40);
                    translate([+P42/2-P41, -P43/2+P41, -de]) polyhole(P5+2*de, P40);
                    translate([+P42/2-P41, +P43/2-P41, -de]) polyhole(P5+2*de, P40);
                }
            }
            translate([P3+P42/2, P3+P43*3/2, 0])
            {
                hull() {
                    translate([-P42/2+P41, -P43/2+P41, -de]) polyhole(P5+2*de, P40);
                    translate([-P42/2+P41, +P43/2-P41, -de]) polyhole(P5+2*de, P40);
                    translate([+P42/2-P41, -P43/2+P41, -de]) polyhole(P5+2*de, P40);
                    translate([+P42/2-P41, +P43/2-P41, -de]) polyhole(P5+2*de, P40);
                }
            }
 

            /*
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
             */

        } //end union

    }  //end difference
}  //end module HolderBase


//fanguard, 
//will be inserted into fan cutout
module FanGuard()
{
    difference()
    {
        union()
        {

            //spokes
            for ( i = [0 : P34-1] )
            {
                rotate( [0, 0, i * 360 / P34]) translate([0, 0, 0])
                    hull() {
                        translate([0, P32, 0])
                            polyhole(P33+2*de, P30);
                        translate([0, 0, 0])
                            polyhole(P33+2*de, P31);
                    }
            }

            //center piece
            polyhole(P33+2*de, P35);

        }

        union()
        {

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
