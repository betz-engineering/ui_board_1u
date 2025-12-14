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
