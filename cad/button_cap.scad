$fn = $preview ? 30 : 200;

include <helpers.scad>

gap = 0.2;

w_head = 2.4 + gap;
w_clip = w_head - 0.5;

h_clip = 1.0;  // height of the hook shaped clip
h_head = 1.8 + gap;  // height of the cube head of the button
h_stamp = h_clip + h_head;  // total height of the negative area

h_button = 8 + 7; // total height of the button measured from the _PCB_
h_cap = h_stamp + h_button - 7.3;
echo(h_cap);

module half_stamp() {
	polygon(points=[
		[0, 0],
		[-w_head / 2, 0],
		[-w_clip / 2, h_clip],
		[-w_head / 2, h_clip],
		[-w_head / 2, h_stamp],
		[0, h_stamp],
	]);
}

// half_stamp();

module stamp() {
	translate([0, w_head / 2, 0])
		rotate([90, 0, 0])
			linear_extrude(w_head)
				union() {
					half_stamp();
					mirror([1, 0, 0]) half_stamp();
				}
}

module cap(){
	difference() {
		union() {
			// Outer diameter of the cap (which needs to fit in the 5 mm hole of the FP)
			cylinder(h=h_cap, d=5 - gap * 2);
			// larger diameter for the inside part
			cylinder(h=h_stamp + 8 - 7.3 - 2 * gap, d=6);
		}
		stamp();
		// the slot
		cube(size=[gap, 10, 10], center=true);
		// chamfer the edges on the top
		translate([0, 0, h_cap - 5.25])
			cone();
	}
}

module cone()
	rotate_extrude()
		translate([5 * sqrt(2), 0, 0])
			rotate([0, 0, 45])
				square([10, 10]);


// simulate the switch head
// translate([0, 0, 7.3 - 1.8])
// 	cube_(size=[2.4, 2.4, 1.8]);

echo("button z", -h_stamp + 7.3 + gap / 2);

intersection() {
	translate([0, 0, -h_stamp + 7.3 + gap / 2])
		!cap();
	translate([0, 50, 0])
		cube(size=[100, 100, 100], center=true);
}

