//-----------------------------------------------------------------------------------
// drill and file hotend
// a simple diy hotend which can be built with only a drill press and hand tools
//
// v3 - with double heating resistors and single thermistors
//      and with mounting bracket on top
//
// see https://github.com/Stemer114/things/tree/master/drill-and-file-hotend
// (c) 2013 by Stemer114
// License: licensed under the Creative Commons - GNU GPL license.
//          http://www.gnu.org/licenses/gpl-2.0.html
//-----------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//display settings
//-----------------------------------------------------------------------------------
show_cross_section  = false;  //enable for cross section
//show_debugging_cube = true;  //enable for debugging
//show_explode = true;  //enable for explosion view - depreciated, set ex to 1 instead
show_projection = false;   //enable for 2d projection (for dxf export)
/* projection types
   1 - side view, cut at center (fast)
   2 - side view (projected)
   3 - top view (projected)
*/
projection_type = 3;


//-----------------------------------------------------------------------------------
// which components to show
//-----------------------------------------------------------------------------------
show_HotEnd     = true;
show_MountPlate = true;
show_Insulator  = true;


//-----------------------------------------------------------------------------------
//color settings
//-----------------------------------------------------------------------------------
color_hotend           = "LightSkyBlue";
color_insulator_sleeve = "OrangeRed";
color_insulator_rod    = "DarkOrange";
color_mountplate       = "MediumSpringGreen";


//-----------------------------------------------------------------------------------
//global configuration settings
//-----------------------------------------------------------------------------------
de = 0.1; //delta param, so differences are scaled and do not become manifold
fn_hole = 12;  //fn setting for round holes/bores (polyhole)
ex = 1;  //for explosions view set to 1 (or more to scale), 0 for mounted view


/* explosion view: every component has to offset settings
   - the first offset setting is always used and controls how the components are mounted
     to compose the complete hotend
   - the second offset is added on top for explosion view, therefore the components are
     moved apart in z-direction, this offset is multiplicated by ex
   therefore, when setting ex to 0, the mounted view is rendered
              when setting ex to 1, the normal explosion view is rendered
              when setting ex to lower or higher than 1, a scaled explosion view is rendered
*/


//-----------------------------------------------------------------------------------
//configuration settings
//-----------------------------------------------------------------------------------

//filament
dia_filament = 3;

//P2: new hotend block (v3)
P200 = 0;    //z offsets for normal and exploded view
P200ex = 0;
P201 = 35;  //original width
P202 = 20;  //original height
P203 = 12;  //original thickness/depth
//holder
P211 = 4;    //thickness
P212 = 3.2;  //mounting hole diameter (for M4 thread)
P213 = 14;   //mounting hole offset from middle
//connector
P221 = 4;    //thickness
P222 = 9; //width
P223 = 12; 
//heater
P231 = 8;   //height
P232 = 22;  //width
P233 = 12; //depth
P234 = 5;    //heat resistor diameter
P235 = 1.8;  //thermistor diameter
P2361 = 7;    //resistor left offset x
P2362 = 4.5;    //              offset z
P2363 = 7;    //resistor right offset x
P2364 = 4.5;  //               offset z
P2365 = 4;    //thermistor offset x
P2366 = 1.5;    //thermistor offset z
//nozzle
P241 = 4;    //height
P242 = 1;    //nozzle length (length of 0.4/0.5 mm nozzle bore)
P243 = 0.5;  //nozzle bore diameter
P244 = 12;   //nozzle top x
P245 = 12;   //nozzle top y
P246 = 2;    //nozzle tip square (length)
//filament/insulator bore
P251 = P211 + P221 + P231 + P241-P242;  //length (calculated)
P252 = 5;    //diameter

//debug output
echo("hotend block current height (calculated): ", P211 + P221 + P231 + P241);
echo("hotend block assumed height (configured): ", P202);

//P3: mount plate (v3 will use steel)
P300 = P202;    //normal mounting position is right atop hotend
P300ex = 10;    
P301 = 2;  //thickness
P302 = 70; //length
P303 = 30; //width
P310 = 15+2;  //cutout length
P311 = 15+2;  //cutout width (insulator od needs to fit)
P320 = 4;     //outer rods mounting holes dia
P321 = 25;    //outer rods mounting holes offset from center
P330 = 4;     //hotend block screw mount diameter
P331 = P213;  //hotend block srew mount offset from center 
              //(needs to be in line with threaded holes in hotend holder)


//P4: PTFE insulator
//z offset depends on exploded view or not
P400 = 27;     //normal mounting position is right behind nozzle
P400ex = 40;
insulator_od = 15;
insulator_id = 5;
insulator_len = 35;
sleeve_od = 4.8;  //outside diameter of sleeve (little bit smaller than 5.0 for better display)
sleeve_id = dia_filament;  //filament bore in sleeve
sleeve_delta = 15;  //how much longer is sleeve compared to rod

//P3: hotend block
hb_w = 35; //width
hb_d = 12; //depth
hb_h = 11; //height
dia_res = 5;  //heat resistor diameter
dia_therm = 1.8;  //thermistor diameter
dia_centr = sleeve_od;   //central bore for PTFE sleeve

//nozzle block (aluminium)
nb_w = 12;
nb_d = hb_d;
nb_h = 9;
nozzle_dia = 0.5;  //nozzle diameter
nozzle_len = 1.0;  //nozzle length within nozzle block
nozzle_square = 2; //nozzle square (the area surrounding the nozzle bore outside)

//mechanical settings
drill_bit_angle = 118;  //angle of drill bit tip (normally 118 degrees for HSS drill bit)

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

//for debugging, show transparent cube at origin
//if (show_debugging_cube)
//	%cube(10);

if (show_projection) {
    //projection (for dxf export)
    //in openscad compile (F6), then export to dxf
    //the dxf can be opened with librecad and e.g. measured
    if (projection_type == 1) {
        //side view, cut at center
        projection(cut=true) rotate([90, 0, 0]) HotendAssembly();
    } else if (projection_type == 2) {
        //top view, projected from outside
        projection(cut=false) rotate([90, 0, 0]) HotendAssembly();
    } else if (projection_type == 3) {
        //top view
        projection(cut=false) HotendAssembly();
    }
} else {
    //3d view
    HotendAssembly();
}




//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

// render the complete assembly, depending what components are enabled
module HotendAssembly()
{
    union()
    {
        if (show_HotEnd) {
            translate([0, 0, P200+P200ex*ex])
                HotEnd();
        }

        if (show_MountPlate) {
            translate([-P302/2, -P303/2, P300+P300ex*ex])
                MountPlate();
        }

        if (show_Insulator) {
            translate([0, 0, P400+P400ex*ex])
                Insulator();
        }

    }  //end union

}  //end module


/* the hot end v3
   consisting of
   - holder 
   - connector (for inserting bracket)
   - heater block
   - nozzle
*/
module HotEnd()
{
    color(color_hotend)
    {
        difference()
        {
            union()
            {
                translate([0, 0, P202-P211])
                    HotEndHolder();
                 translate([0, 0, P202-P211-P221])
                    HotEndConnector();
                 translate([0, 0, P202-P211-P221-P231])
                    HotEndHeater();
                 translate([0, 0, P202-P211-P221-P231-P241])
                     HotEndNozzle();
             }

            union()
            {
                //central bore
                translate([0, 0, P242+de]) 
                    drill_hole(P252, P251+de, 118);
                //nozzle bore
                translate([0, 0, -de])
                    cylinder(h=P242+4*de, r=P243/2, center=false, $fn=12);
            }
        }
    }
}


module HotEndHolder() {
    translate([0, 0, P211/2])
        difference() {
            //holder base part
            cube([P201, P203, P211], center=true);

            //mounting bore left
            translate([-P213, 0, -de])
                cylinder(h=P211+4*de, r=P212/2, center=true, $fn=12);
            //mounting bore right
            translate([P213, 0, -de])
                cylinder(h=P211+4*de, r=P212/2, center=true, $fn=12);
         }
}

module HotEndConnector() {
    translate([0, 0, P221/2])
        cube([P222, P223, P221], center=true);
}

module HotEndHeater() {

    {
        difference()
        {
            union()
            {
                //heater base cube
                translate([0, 0, P231/2])
                    cube([P232, P233, P231], center=true);
            }

            union()
            {
                //heater resistor bore left
                translate([-P2361, 0, P2362])
                    rotate([90, 0, 0]) 
                    cylinder(h=P233+2*de, r1=P234/2, r2=P234/2, center=true, $fn=32);

                //heater resistor bore right 
                translate([P2363, 0, P2364])
                    rotate([90, 0, 0]) 
                    cylinder(h=P233+2*de, r1=P234/2, r2=P234/2, center=true, $fn=32);

                //thermistor bore
                translate([P2365, 0, P2366])
                    rotate([90, 0, 0]) 
                    cylinder(h=P233+2*de, r1=P235/2, r2=P235/2, center=true, $fn=32);

            }
        }
    }  //translate hotendheater 
}


module HotEndNozzle() {
    //nozzle block lower
    rotate([0, 0, 45])
        cylinder(P241, P246/sqrt(2), P244/sqrt(2), center=false, $fn=4);
}

// the insulator
// made from PTFE 15mm rod
// with inner PTFE sleeve made from 5mm PTFE rod
module Insulator()
{

	difference()
	{
		union()
		{
			//rod body
			color(color_insulator_rod)
			{
			translate([0, 0, sleeve_delta])
			cylinder(insulator_len, insulator_od/2, insulator_od/2, 
					  center=true, $fn=32);
			}

			//sleeve body
			color(color_insulator_sleeve, 0.5)
			{
			cylinder(insulator_len+sleeve_delta, sleeve_od/2, sleeve_od/2, 
					  center=true, $fn=32);
			}
		}
	
		union()
		{
			//inner bore in rod
			//actually need to make separate modules
			//for rod and sleeve and join them
			//translate([0, 0, sleeve_delta])
			//cylinder(insulator_len, insulator_id/2, insulator_id/2, 
			//		  center=true, $fn=32);

			//inner bore in sleeve
			cylinder(insulator_len+sleeve_delta, sleeve_id/2, sleeve_id/2, 
					  center=true, $fn=32);
		}
	}
}



// the mount plate
// with cutout for the hotend
// and with bores for the mounting rods
module MountPlate()
{
	color(color_mountplate, 0.5)
	{

		difference()
		{
			union()
			{
				cube([P302, P303, P301]);
			}
		
			union()
			{

                //cutout
				translate([
					P302/2-P310/2,
					-P311/2+P303/2, 
					-0.1
				])
				cube([
					P310, 
					P311, 
					P301+0.2
				]);

				//outer mounting rod bore left
				translate([
					P302/2-P321, 
					P303/2, 
					P301/2
				])
				cylinder(
					P301*1.2, 
					P320/2, 
					P320/2, center=true, $fn=32
				);

				//outer mounting rod bore right
				translate([
					P302/2+P321, 
					P303/2, 
					P301/2
				])
				cylinder(
					P301*1.2, 
					P320/2, 
					P320/2, center=true, $fn=32
				);

				//hole for screw for mounting hotend holder (left)
				translate([
					P302/2-P331, 
					P303/2, 
					P301/2
				])
				cylinder(
					P301*1.2, 
					P330/2, 
					P330/2, center=true, $fn=32
				);

				//hole for screw for mounting hotend holder (right)
				translate([
					P302/2+P331, 
					P303/2, 
					P301/2
				])
				cylinder(
					P301*1.2, 
					P330/2, 
					P330/2, center=true, $fn=32
				);

			}
		}
	}
}




//-----------------------------------------------------------------------------------
// utility functions
//-----------------------------------------------------------------------------------


/*
model a hole drilled with drill bit with tip angle (normally 118 degree)
parameters: 
dia: drill hole diameter
len: drill hole length from tip
angle: tip angle (normally 118 degree for HSS drill bits
*/
module drill_hole(dia, len, angle)
{
	//calulate values for tip based on angle an diameter
	tip_len = dia / 2 / tan(angle/2);
	union()
	{
		//ground bore
		translate([0, 0, tip_len-0.01]) 
			cylinder(len-tip_len+0.01, dia/2, dia/2, center=false, $fn=32);
		//tip
		cylinder(tip_len, 0, dia/2, center=false, $fn=32);
	}
}

