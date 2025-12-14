$fn = $preview ? 30 : 100;

include <helpers.scad>

w_panel = 84;
w_flex = 60;
h_panel = 25.8;
t_panel = 2.0;


shell_thickness = 2;

// space (wiggle room) between panel and frame around it
gap = 0.5;

// How far the bottom of the panel is lifted from the carrier PCB
h_offset = 5.5;
echo("h_offset: ", h_offset);

// Total height of the part
h_total = h_offset + t_panel + gap;
echo("h_total: ", h_total);

// The rounded lip part
d_lip = 2;
y_lip = 0;

// centered on XY only
module cube_(size=[1, 1, 1])
	translate([-size[0] / 2, -size[1] / 2, 0])
		cube(size);

// centered on XY only
module roundedcubez(size = [1, 1, 1], radius = 0.5) {
	linear_extrude(height=size[2]) {
		square([size[0] - 2 * radius, size[1]], center=true);
		square([size[0], size[1] - 2 * radius], center=true);
		for (i=[-1, 1])
			for (j=[-1, 1])
				translate([i * (size[0] / 2 - radius), j * (size[1] / 2 - radius), 0])
					circle(r = radius);
	}
}

module panel() {
	color("grey")
		translate([0, 1, (t_panel - 0.75) / 2])
			cube(size=[w_panel, h_panel - 2, t_panel - 0.75], center=true);
	color("lightgrey")
		translate([0, 0, t_panel - 0.75 / 2])
			cube(size=[w_panel, h_panel, 0.75], center=true);
	translate([0, -10 - h_panel / 2, 1.20])
		cube(size=[w_flex, 25, 0.1], center=true);
}

module oled_frame() {
	difference() {
		roundedcubez(size=[w_panel + shell_thickness * 2, 30, h_total], radius=3);

		// pocket for the display
		translate([0, 0, h_offset])
			cube_(size=[w_panel + gap, h_panel + gap, 10]);

		// Opening for the flex
		// remove the lip to shape it better
		translate([0, -10 - (h_panel + gap) / 2 - y_lip, 0])
			cube_(size=[w_flex + 2 * gap, 20, 10]);

		// Clear out the top
		translate([0, -25, h_offset])
			cube_(size=[w_flex + 2 * gap, 50, 10]);

		// Clear out the bottom
		cube(size=[w_flex + 2 * gap, 100, (h_offset - d_lip) * 2], center=true);

		// slots for M2.5 square nuts
		for (i=[-1, 1]) {
			translate([40 * i, 0, 3]) {
				translate([2 * i, 0, 0])
					cube(size=[10, 5.1 + gap / 3, 1.7 + gap / 3], center=true);
				translate([0, 0, -1])
					cylinder(h=10, d=2.8, center=true);
			}

			// Dog bones
			for (j=[-1, 1])
				translate([i * ((w_panel + gap) / 2 - 0.8), j * ((h_panel + gap) / 2 - 0.8), 5 + h_offset])
					cylinder(h=10, d=3, center=true);
		}
	}

	// The rounded lip
	translate([0, -(h_panel + gap) / 2 - y_lip, -d_lip/2 + h_offset]) {
		rotate([0, 90, 0])
			cylinder(h=w_flex + 2 * gap, d=d_lip, center=true);
	}
}

// translate([0, 0, h_offset + gap])
// 	panel();

intersection() {
	union() {
		oled_frame();
		// Square nut
		// translate([40, 0, 2])
		// 	cube_(size=[5.0, 5.0, 1.55]);
		// // Screw
		// translate([40, 0, -1.6])
		// 	cylinder(h=5, d=2.5);
	}
	// translate([0, 50, 0])
	// 	cube(size=[100, 100, 100], center=true);
}
