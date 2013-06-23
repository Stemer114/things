//-----------------------------------------------------------------------------------
// 2013-06-23
// oogoo mould for rubber feet (for mendel90)
// http://www.thingiverse.com/thing:107445
// (c) 2013 by Stemer114
// License: Printable parametric mold for oogoo feet for reprap printer 
//          by Stemer114 is licensed under the Creative Commons - GNU GPL license.
//          http://www.gnu.org/licenses/gpl-2.0.html
//
// latest version:
//   https://github.com/Stemer114/things
//-----------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//display settings
//-----------------------------------------------------------------------------------

//color settings

//-----------------------------------------------------------------------------------
//global configuration settings
//-----------------------------------------------------------------------------------
de = 0.1; //delta param, so differences are scaled and do not become manifold
fn_hole = 12;  //fn setting for holes/bores

//-----------------------------------------------------------------------------------
//configuration settings
//-----------------------------------------------------------------------------------
//show_positive = true; //true: show positive Version of feet

P1  = 25;  //foot outer diameter
P2  = 11;  //fixing cutout diameter (for washer)
P3  = 3.2; //fixing bore diameter (for screw)
P4  = 6;   //foot height
P5  = 4;   //fixing dimple depth
P6  = 10;  //groove length
P7  = 2;   //groove width
P8  = 2;   //groove depth
P9  = 5;   //groove offset from center
P10 = 4;   //groove count

P21 = 1;   //number of feet in x direction
P22 = 1;   //number of feet in y direction
P23 = 3;   //offset between feet
P24 = 2;   //thickness of base plate for mould

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

difference()
{

MouldBase();

translate([P1/2+P23, P1/2+P23, de])
    FeetMatrix();
}

if (show_positive)
{
translate([0, 0, -30])
    Foot();
}



//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module MouldBase()
{
    cube([((P1+P23)*P21)+P23, ((P1+P23)*P22)+P23, P24+P4]);
}

//rows by column number of feet
module FeetMatrix()
{
    for (iy = [0:P22-1])
    {
        for (ix = [0:P21-1])
        {
            translate([(P1+P23)*ix, (P1+P23)*iy, P24])
                Foot();
        }
    }
}


module Foot()
{
    difference()
    {
        union()
        {
            //foot main body, and move to center
            //translate([0, 0, P4-1/2])
                //cube([P1, P1, 1], center=true);
            cylinder(P4, P1/2, P1/2, center=false);


        }

        union()
        {
            //fixing bore
            translate([0, 0, -de])
                cylinder(P4+2*de, P3/2, P3/2, $fn=fn_hole);

            //fixing dimple
            translate([0, 0, -de])
                cylinder(P5+de, P2/2, P2/2, $fn=fn_hole);

            //grooves
            for ( i = [0 : P10-1] )
            {
                rotate( [0, 0, i * 360 / P10]) translate([P9+P6/2, 0, P8/2-de])
                    cube([P6, P7, P8], center=true);
            }

        }
    }
}


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------


