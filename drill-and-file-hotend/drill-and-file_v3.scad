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

//-----------------------------------------------------------------------------------
// enable/disable hotend assembly components
//-----------------------------------------------------------------------------------
show_HotEnd     = false;
show_MountPlate = true;
show_Insulator  = false;



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
P211 = 4;  //thickness
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
mountplate_length        = 70;
mountplate_width         = 30;
mountplate_thickness     = 2;
P301 = 2;  //thickness
mountplate_h1_dia        = 4;      //hole dia
mountplate_h1_offset     = 25;     //hole offset from middle
mountplate_cutout_length = 35+2; //cutout dimensions
mountplate_cutout_width  = 12+2;


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

render() {
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
                HotEndv3();
        }

        if (show_MountPlate) {
            translate([-mountplate_length/2, -mountplate_width/2, P300+P300ex*ex])
                MountPlate();
        }

        if (show_Insulator) {
            translate([0, 0, P400+P400ex*ex])
                Insulatorv3();
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
module HotEndv3()
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
                    cylinder(h=P242+4*de, r=P243/2, center=false);
            }
        }
    }
}


module HotEndHolder() {
    translate([0, 0, P211/2])
        cube([P201, P203, P211], center=true);
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
module Insulatorv3()
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



//-----------------------------------------------------------------------------------
// old (v2) modules
//-----------------------------------------------------------------------------------

/* the hot end
   consisting of heater block and nozzle block
*/
module HotEnd()
{
	//rod body
	color(color_hotend, 0.5)
	{
		difference()
		{
			union()
			{
				translate([0, 0, nb_h])
					HeaterBlock();
				translate([(hb_w-nb_w)/2, 0, 0])
					NozzleBlock();
			}
	
			union()
			{
	
			}
		}
	}
}


// the heater block, 
// with bores for heating resistors and thermistor
// without the nozzle
module HeaterBlock()
{
	difference()
	{
		union()
		{
			cube([hb_w, hb_d, hb_h]);
		}
	
		union()
		{
			//heater resistor bore left
			rotate([90, 0, 0]) 
			translate([6.5, 4, -hb_d/2])
				cylinder(hb_d*1.1, dia_res/2, dia_res/2, center=true, $fn=32);

			//heater resistor bore left
			rotate([90, 0, 0]) 
			translate([hb_w-6.5, 4, -hb_d/2])
				cylinder(hb_d*1.1, dia_res/2, dia_res/2, center=true, $fn=32);

			//thermistor bore
			rotate([90, 0, 0]) 
			translate([hb_w-11.5, hb_h-3, -hb_d/2])
				cylinder(hb_d*1.1, dia_therm/2, dia_therm/2, center=true, $fn=32);

			//filament-isolator sleeve bore
			translate([hb_w/2, hb_d/2, hb_h/2])
				cylinder(hb_h*1.1, dia_centr/2, dia_centr/2, center=true, $fn=32);


		}
	}
}


// the nozzle
// with central bore
// and nozzle bore
module NozzleBlock()
{
	difference()
	{
		union()
		{
			//nozzle block upper
			translate([0, 0, 4])
				cube([nb_w, nb_d, nb_h-4]);

			//nozzle block lower
			translate([nb_w/2, nb_d/2, 0])
			rotate([0, 0, 45])
				cylinder(4, nozzle_square/sqrt(2), nb_w/sqrt(2), center=false, $fn=4);

			//translate([0, 0, nozzle_len]) 
			//	drill_hole(dia_centr, nb_h-nozzle_len+0.1, 118);

		}
	
		union()
		{
			//filament-isolator sleeve bore
			//translate([nb_w/2, nb_d/2, nozzle_len])
			//	cylinder(nb_h-nozzle_len+0.1, dia_centr/2, dia_centr/2, center=false, $fn=32);
			translate([nb_w/2, nb_d/2, nozzle_len]) 
				drill_hole(dia_centr, nb_h-nozzle_len+0.1, 118);

			//nozzle bore
			translate([nb_w/2, nb_d/2, nozzle_len/2])
				cylinder(nozzle_len+0.5, nozzle_dia/2, nozzle_dia/2, center=true, $fn=32);

		}
	}
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
			color(color_insulator_rod, 0.5)
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
				cube([mountplate_length, mountplate_width, mountplate_thickness]);
			}
		
			union()
			{

				translate([
					mountplate_length/2-mountplate_cutout_length/2,
					-mountplate_cutout_width/2+mountplate_width/2, 
					-0.1
				])
				cube([
					mountplate_cutout_length, 
					mountplate_cutout_width, 
					mountplate_thickness+0.2
				]);

				//mounting rod bore left
				translate([
					mountplate_length/2-mountplate_h1_offset, 
					mountplate_width/2, 
					mountplate_thickness/2
				])
				cylinder(
					mountplate_thickness*1.2, 
					mountplate_h1_dia/2, 
					mountplate_h1_dia/2, center=true, $fn=32
				);

				//mounting rod bore right
				translate([
					mountplate_length/2+mountplate_h1_offset, 
					mountplate_width/2, 
					mountplate_thickness/2
				])
				cylinder(
					mountplate_thickness*1.2, 
					mountplate_h1_dia/2, 
					mountplate_h1_dia/2, center=true, $fn=32
				);

				//cutout for hotend block

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

