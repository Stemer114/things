//-----------------------------------------------------------------------------------
// hotend fan
// mounted on left side of Mendel90 x-carriage
// for cooling the hotend insulator (always on)
//
// http://www.thingiverse.com/thing:
// https://github.com/Stemer114/things/tree/master/reprap 
//
// (c) 2013 by Stemer114@gmail.com
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

//duct - P01xx
P0110 = 30;  //width
P0111 = 20;  //height
P0112 = 15;  //length
P0115 = 2;   //wall thickness

//mounting plate - P02xx
P0210 = 40;  //width
P0211 = 40;  //height
P0212 = 5;   //thickness
P0220 = 5;   //offset width direction
P0221 = 8;   //offset height direction


//-----------------------------------------------------------------------------------
// libraries
//-----------------------------------------------------------------------------------
use <MCAD/polyholes.scad>

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

FanMount();




//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module FanMount()
{
    difference()
    {
        union()
        {
            //duct body
            translate([0, 0, P0212])
                cube([P0110, P0111, P0112], center=false);

            //mounting plate
            translate([0, 0, 0])
                cube([P0210, P0211, P0212], center=false);


        }  //end union

        union()
        {
            //duct cutout
            translate([0, 0, P0212])
            translate([P0115, P0115, -de])
                cube([P0110-2*P0115, P0111-2*P0115, P0112+2*de], center=false);
 
        } //end union

    }  //end difference

}  //end module SquareRuler


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------
