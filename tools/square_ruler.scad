//-----------------------------------------------------------------------------------
// square ruler
// (German: Schlosserwinkel mit Anschlag)
//
// http://www.thingiverse.com/thing:145693
// https://github.com/Stemer114/things/tree/master/tools 
//
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
de = 0.1; //delta param, so differences do not become manifold
fn_hole = 12;  //fn setting for round holes/bores (polyhole)
ex = 0;  //offset for Explosivdarstellung, set to 0 for none

//-----------------------------------------------------------------------------------
// parametric settings (in mm)
//-----------------------------------------------------------------------------------

show_mirrored = false;
//show_mirrored = true;

P1  = 50;  //side 1 length
P2  = 50;  //side 2 length
P3  = 20;  //side 1 width
P4  = 15;  //side 2 width
P5  =  5;  //leg thickness
P10 = 10;  //guide thickness (Anschlag)
P11 = 5;  //guide width
P20 =  2;  //groove width
P21 =  2;  //groove depth
P30 =  4;  //corner cutout diameter (polyhole)

//-----------------------------------------------------------------------------------
// libraries
//-----------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------


//transparent 10mm cube for debugging
//translate([0, 0, -10])
//% cube(10, 10, 10);

if (show_mirrored) {
    mirror([ 0, 1, 0 ]) SquareRuler();
} else {
    SquareRuler();
}


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module SquareRuler()
{
    difference()
    {
        union()
        {
            //side 1
            translate([0, 0, 0])
                cube([P1, P3, P5], center=false);

            //side 2
            translate([0, 0, 0])
                cube([P4, P2, P5], center=false);

            //guide
            translate([0, 0, 0])
                cube([P1, P11, P10], center=false);

        }  //end union

        union()
        {
            //groove
            translate([-de, P11, P5+de-P21])
                cube([P1+2*de, P20, P21], center=false);

            //corner cutout
            translate([P4, P3, -de])
                polyhole(P5+2*de, P30);
 
 
        } //end union

    }  //end difference

}  //end module SquareRuler


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
