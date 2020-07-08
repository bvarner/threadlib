/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-10
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M6";
length = 7;
higbee_arc = 180;
crosssection = true;

P = thread_specs(str(type, "-ext"))[0];
dz = 2 * P;

if (crosssection) {
    translate([0, 0, dz])
        rotate([0, 0, 0])
            bolt(type, length=length, leadin=3, higbee_arc=higbee_arc);
}

intersection() {
    difference() {
        cylinder(d = 12, h=length, $fn = 6);
        tap(type, length=length, higbee_arc=higbee_arc);
    }
    if (crosssection) {
        translate([-100, 0, 0])
            cube([200, 200, 200]);
    }
};