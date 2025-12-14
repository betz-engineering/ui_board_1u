// PLCC6 RGB LED
// https://jlcpcb.com/api/file/downloadByFileSystemAccessId/8588884074492125184

$fn = $preview ? 30 : 100;

include <helpers.scad>

difference() {
	cube_([3.5, 3.5, 2.8]);
	translate([0, 0, 2])
		roundedcubez(size = [3.2, 3.0, 5], radius = 1);
	translate([2.2, -2.2, 2.5])
		rotate([0, 0, 45])
			cube_([2, 2, 2]);
}

color("grey")
	for (x=[-1, 1])
		for (y=[-1, 0, 1])
			translate([(3.7 - 0.9) / 2 * x, (2.8 - 0.6) / 2 * y, -0.01])
				cube_([0.9, 0.6, 1.0]);
