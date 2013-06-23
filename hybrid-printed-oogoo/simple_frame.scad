//-----------------------------------------------------------------------------------
// simple frame
//
// (c) 2013 by Stemer114
// License: licensed under the Creative Commons - GNU GPL license.
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
show_zoffset  = -30;  //offset in z direction for showing positive 

//for tuning to your printer, express thickness values (P1, P2)
//as multiples of P0, rather than absolute values
P0  = 0.4;  //layer thickness of 3d printer

P1  = 1.2;   //frame base thickness
P2  = 5.8;   //frame reinforcement height
P3  = 2;   //frame base offset
P4  = 20;  //frame cutout dimension (quadratic)

P5  = 1.5;   //frame reinforcement thickness
P6  = 3;   //frame outer thickness (must be larger than P5)
P7  = P4*0.7; //cutout wing dimension (can be expressed relative to cutout dimension)
P8  = 2;      //cutout wing thickness

P10 = 3;   //number of cutouts in x direction
P11 = 2;   //number of cutouts in y direction
//n.b. frame outer dimensions are 
// in x direction: P10*P4 + (P10-1)*P5 + 2*P6
// in y direction likewise with P11


//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

translate([0, 0, P1+P2])
mirror([0, 0, 1])
{
    difference()
    {

        FrameBlock();

        //subtract cutouts twice, once +delta higher
        //once -delta lower, so manifolds are prevented
        translate([P6, P6, de])
            CutoutMatrix();
        translate([P6, P6, -de])
            CutoutMatrix();
    }
}

if (show_positive)
{
    translate([P6, P6, show_zoffset])
    {
        * Cutout();
        CutoutMatrix();
    }
}



//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

// the frame block without the cutouts
// the cutout matrix will be subtracted from this block
// giving the frame to print
// FrameBlock is already translated so lower left corner is at origin
module FrameBlock()
{
    //cube([((P5+P4)*P10)+P5, ((P5+P4)*P11)+P5, P1+P2]);
    cube([ P10*P4 + (P10-1)*P5 + 2*P6, P11*P4 + (P11-1)*P5 + 2*P6, P1+P2]);
}

//rows by column number of cutouts
//translated so that lower left corner is at origin
module CutoutMatrix()
{
    translate([P4/2, P4/2, 0])
    {
        for (iy = [0:P11-1])
        {
            for (ix = [0:P10-1])
            {
                translate([(P4+P5)*ix, (P4+P5)*iy, 0])
                    Cutout();
            }
        }
    }
}


module Cutout()
{
    difference()
    {
        union()
        {
            //cutout main body
            translate([0, 0, P2/2])
                cube([P4, P4, P2], center=true);
            //cutout base
            translate([0, 0, P2+P1/2])
                cube([P4-2*P3, P4-2*P3, P1], center=true);
            //cutout wings x direction
            translate([0, 0, P8/2])
                cube([P4+P5+de, P7, P8], center=true);
             //cutout wings y direction
            translate([0, 0, P8/2])
                cube([P7, P4+P5+de, P8], center=true);
 

        }

        union()
        {

        }
    }
}


//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------


