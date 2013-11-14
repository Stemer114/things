//-----------------------------------------------------------------------------------
// drill adapter for 15mm PTFE 
//
// http://www.thingiverse.com/thing:
// https://github.com/Stemer114/things/tree/master/tools 
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

P1 = 15.2;  //PTFE rod diameter
P2 = 24;    //OD
P3 = P2+2*10;  //bracket length
P4 = 2;       //gap width
P5 = 8;       //bracket thickness
P6 = 8;       //wrench size for bolt
P7 = 5.1;     //bore size for bolt

P10 = 12;  //chuck depth
P11 = 4;   //hex head depth
P12 = 4;   //bottom plate depth
P13 = 3.2; //bracket bores diameter
P15 = P10+P11+P12;  //adapter total height (calulated)


//-----------------------------------------------------------------------------------
// libraries
//-----------------------------------------------------------------------------------
use <MCAD/polyholes.scad>

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

ptfe_drill_adapter();




//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module ptfe_drill_adapter()
{
    difference()
    {
        union()
        {
            //bracket
            translate([0, 0, P15/2])
                cube([P3, P5, P15 ], center=true);

            //adapter main body
            translate([0, 0, 0])
                polyhole(h=P15, d=P2);


        }  //end union

        union()
        {
            //adapter bore 
            translate([0, 0, P11+P12+de])
                polyhole(h=P10+de, d=P1);

            //bracket gap
            translate([0, 0, P10/2+P11+P12+de])
                cube([P3+2*de, P4, P10 ], center=true);

            //nut trap for bolt
            //source: http://forum.openscad.org/Drawing-tools-td4551i20.html
            translate([0, 0, P12])
            //rotate([0,90,0])
                cylinder(r = P6 / 2 / cos(180 / 6) + 0.05, h=P11+2*de, $fn=6);

            //bore for bolt
            translate([0, 0, -de])
                polyhole(h=P12+2*de, d=P7);

            //bores for bracket bolts
            translate([P2/2+(P3-P2)/4, P5/2+de, P15-P10/2])
                rotate([90, 90, 0])
                polyhole(h=P5+2*de, d=P13);

            translate([-(P2/2+(P3-P2)/4), P5/2+de, P15-P10/2])
                rotate([90, 90, 0])
                polyhole(h=P5+2*de, d=P13);





 
        } //end union

    }  //end difference

}  //end module SquareRuler


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------
