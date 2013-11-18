//-----------------------------------------------------------------------------------
// hotend fan
// mounted on left side of Mendel90 x-carriage
// for cooling the hotend insulator (always on)
//
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
nozzle_size = 0.5;  //needed for thickness of support structure

//-----------------------------------------------------------------------------------
// parametric settings (in mm)
//-----------------------------------------------------------------------------------

//duct with mounting bracket - P01xx
P0110 = 30;  //width
P0111 = 20;  //height
P0112 = 16;  //length
P0115 = 2;   //wall thickness
P0130 = 3;   //bracket offset from back of mounting plate
P0131 = 6;   //bracket height (P0221 ./. thickness of x carriage)
P0132 = P0112-P0130;  //bracket foot length
P0133 = P0132-P0131;      //bracket top length
echo("bracket foot length", P0132);
echo("bracket top length",  P0133);
P0135 = 15;           //bracket width
P0140 = 3.2;          //mounting hole diameter
P0141 = P0131+P0115;  //mounting hole length
P0142 = 4;            //mounting hole offset from edge
P0145 = 5.5;     //nut trap wrench size
P0146 = 3;       //nut trap length

//mounting plate - P02xx
P0210 = 40;  //width
P0211 = 40;  //height
P0212 = 6;   //thickness
P0220 = 5;   //offset width direction
P0221 = 8;   //offset height direction
P0230 = 3.3; //fan mounting hole diameter
P0231 = 4;   //fan mounting hole offset from edges
P0232 = 6;   //screw head diameter
P0233 = 2;   //screw head depth
P0240 = 35;  //fan cutout diameter
P0241 = 3;   //fan cutout depth
//support structure for duct
//to be broken away after printing
P0250 = nozzle_size;   //thickness (filament thickness)



//-----------------------------------------------------------------------------------
// libraries
//-----------------------------------------------------------------------------------
use <MCAD/polyholes.scad>

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

FanMount();
SupportStructure();


//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module FanMount()
{
    difference()
    {
        union()
        {
            //mounting plate
            translate([0, 0, 0])
                cube([P0212, P0210, P0211], center=false);

            //duct body
            translate([P0212, P0220, P0211-P0111-P0221])
                cube([P0112, P0110, P0111], center=false);

            //mounting bracket (mounting to x-carriage)
            hull()
            {
                //bottom plate
                translate([P0212+P0130, P0220+P0110/2-P0135/2, P0211-P0221-de])
                    cube([P0132, P0135, de]);
                //top plate
                translate([P0212+P0112-P0133, P0220+P0110/2-P0135/2, P0211-P0221+P0131])
                    cube([P0133, P0135, de]);
            }

//# cylinder(r = P0145 / 2 / cos(180 / 6) + 0.05, h=P0146+2*de, $fn=6);


        }  //end union

        union()
        {
            //cutout
            //(through mounting plate and duct)
            translate([-de, P0220+P0115, P0211-P0111-P0221+P0115])
                cube([P0212+P0112+2*de, P0110-2*P0115, P0111-2*P0115], center=false);

            //fan mounting holes
            translate([-de, P0231, P0231]) rotate([0, 90, 0]) polyhole(h=P0212+2*de, d=P0230);
            translate([-de, P0210-P0231, P0231]) rotate([0, 90, 0]) polyhole(h=P0212+2*de, d=P0230);
            translate([-de, P0210-P0231, P0211-P0231]) rotate([0, 90, 0]) polyhole(h=P0212+2*de, d=P0230);
            translate([-de, P0231, P0211-P0231]) rotate([0, 90, 0]) polyhole(h=P0212+2*de, d=P0230);
            //fan mounting holes - screw heads
            translate([P0212-P0233+de, P0231, P0231]) rotate([0, 90, 0]) polyhole(h=P0233+de, d=P0232);
            translate([P0212-P0233+de, P0210-P0231, P0231]) rotate([0, 90, 0]) polyhole(h=P0233+de, d=P0232);
            translate([P0212-P0233+de, P0210-P0231, P0211-P0231]) rotate([0, 90, 0]) polyhole(h=P0233+de, d=P0232);
            translate([P0212-P0233+de, P0231, P0211-P0231]) rotate([0, 90, 0]) polyhole(h=P0233+de, d=P0232);


            //fan cutout
            translate([-de, P0210/2, P0211/2]) 
                rotate([0, 90, 0]) 
                polyhole(h=P0241+de, d=P0240);

            //mounting hole in bracket
            translate([P0212+P0112-P0142, P0220+P0110/2, P0211-P0221-P0115-de])
                union()
                {
                    //bore
 polyhole(h=P0141+3*de, d=P0140);
                    //nut trap
            //source: http://forum.openscad.org/Drawing-tools-td4551i20.html
 cylinder(r = P0145 / 2 / cos(180 / 6) + 0.05, h=P0146+2*de, $fn=6);

                }

 
        } //end union

    }  //end difference

}  //end module 


module SupportStructure()
{

    difference()
    {
    translate([0, P0220+P0115-P0250, P0211-P0221-P0111+P0115-P0250])
        cube([P0212, P0110-2*P0115+2*P0250, P0111-2*P0115+2*P0250], center=false);

    translate([0, P0220+P0115-P0250, P0211-P0221-P0111+P0115-P0250])
        translate([-de, P0250, P0250])
        cube([P0212+2*de, P0110-2*P0115, P0111-2*P0115], center=false);
    }

}


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------
