use <threadlib/threadlib.scad>;

intersection() {
    union() {
        difference() {
            cylinder(r = 15, h = 10.9);
            tap("G1/2", length = 11);
        }
        bolt("G1/2", length = 11);
    }
    translate([-20, 0, 0])
    cube([40, 20, 20]);
}