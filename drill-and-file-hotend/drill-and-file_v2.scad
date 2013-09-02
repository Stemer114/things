//-----------------------------------------------------------------------------------
// drill and file hotend
// a simple diy hotend which can be built with only a drill press and hand tools
//
// v2 - with double heating resistors and single thermistors
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
show_debugging_cube = true;  //enable for debugging
show_explode = true;  //enable for explosion view

//color settings
color_hotend           = "LightSkyBlue";
color_insulator_sleeve = "OrangeRed";
color_insulator_rod    = "DarkOrange";
color_mountplate       = "MediumSpringGreen";

//-----------------------------------------------------------------------------------
//configuration settings
//-----------------------------------------------------------------------------------

//filament
dia_filament = 3;

//PTFE insulator
insulator_od = 15;
insulator_id = 5;
insulator_len = 35;
sleeve_od = 5;  //outside diameter of sleeve
sleeve_id = dia_filament;  //filament bore in sleeve
sleeve_delta = 15;  //how much longer is sleeve compared to rod

//heater block (aluminium)
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

//mount plate (aluminium, maybe stainless steel later)
mountplate_length        = 70;
mountplate_width         = 30;
mountplate_thickness     = 2;
mountplate_h1_dia        = 4;      //hole dia
mountplate_h1_offset     = 25;     //hole offset from middle
mountplate_cutout_length = hb_w+2; //cutout dimensions
mountplate_cutout_width  = hb_d+2;

//mechanical settings
drill_bit_angle = 118;  //angle of drill bit tip (normally 118 degrees for HSS drill bit)

//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

//for debugging, show transparent cube at origin
if (show_debugging_cube)
	%cube(40);


//difference is only really used if cross section enabled
difference()  //difference is only needed if 
{
    union()
    {
        translate([-hb_w/2, -hb_d/2, 0])
            HotEnd();
        translate([0, 0, 50])
            Insulator();

        translate([-mountplate_length/2, -mountplate_width/2, -10])
            MountPlate();
    }

    //create cross section by cutting away cube
    if (show_cross_section)
    {
        translate([-0.5, -hb_d/2, -0.5]) cube([100+1, hb_d, 100+nb_h+1]);
    }

}





//-----------------------------------------------------------------------------------
// modules
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


//model a hole drilled with drill bit with tip angle (normally 118 degree)
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

