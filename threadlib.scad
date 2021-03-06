/*
threadlib
+++++++++

Create threads easily.

:Author: Adrian Schlatter
:Date: 2019-11-11
:License: 3-Clause BSD. See LICENSE.
*/

function __THREADLIB_VERSION() = 0.3;

use <thread_profile.scad>
include <THREAD_TABLE.scad>

function thread_specs(designator, table=THREAD_TABLE) =
    /* Returns thread specs of thread-type 'designator' as a vector of
       [pitch, Rrotation, Dsupport, section_profile] */
      
    // first lookup designator in table inside a let() statement:
    let (specs = table[search([designator], table, num_returns_per_match=1,
                              index_col_num=0)[0]][1])
        // verify that we found something and return it:
        assert(!is_undef(specs), str("Designator: '", designator, "' not found")) specs;
        
module thread(designator, turns, higbee_arc=20, fn=120, table=THREAD_TABLE)
{
    specs = thread_specs(designator, table=table);
    P = specs[0]; Rrotation = specs[1]; section_profile = specs[3];
    straight_thread(
        section_profile=section_profile,
        higbee_arc=higbee_arc,
        r=Rrotation,
        turns=turns,
        pitch=P,
        fn=fn);
}


// turns      - If specified, creates a supporting structure with n turns of a thread around it.
// length     - If specified, creates a supporting structure of length, with half-pitch offset to the ends.
// leadin     - 0 (default): no chamfer; 1: chamfer (45 degrees) at max-z end;
//              2: chamfer at both ends, 3: chamfer at z=0 end.
// leadfac    - scale of leadin chamfer (default: 1.0 = 1/2 thread).
module bolt(designator, turns=0, length=0, leadin=0, leadfac=1.0, higbee_arc=20, fn=120, table=THREAD_TABLE) {
    difference() {
        specs = thread_specs(str(designator, "-ext"), table=table);
        P = specs[0]; Dsupport = specs[2];
        // If length is specified, calulate the turns and height based upon the length and pitch.
        turns = (turns != 0) ? turns : length / P;
        H = (length != 0) ? length : (turns + 1) * P;
            
        union() {
            thread(str(designator, "-ext"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table);
            translate([0, 0, length != 0 ? 0 : -P / 2])
                cylinder(h=H, d=Dsupport, $fn=fn);
        };
        
        // If length is specified, trim the lower and upper half-turns of the thread from the 
        // supporting structure.
        if (length != 0) {
            int_specs = thread_specs(str(designator, "-int"), table = table);
            translate([0, 0, -P / 2])
                cylinder(h=P/2, d=int_specs[2], $fn=fn);
            translate([0, 0, H])
                cylinder(h=P/2, d=int_specs[2], $fn=fn);
        }
        
        // If a leadin is specified, trim the appropriate ends with the proper camfer form.
        if (leadin > 0) {
            int_specs = thread_specs(str(designator, "-int"), table = table);

            // chamfer max-z end
            if (leadin == 1 || leadin == 2) {
                translate([0, 0, H - P * leadfac / 2])
                    difference() {
                        cylinder(h=P * leadfac / 2, d=int_specs[2], $fn=fn);
                        cylinder(h=P * leadfac / 2, d1=int_specs[2], d2=Dsupport, $fn=fn);
                    }
            }
            
            // chamfer min-z end
            if (leadin == 3 || leadin == 2) {
                difference() {
                    cylinder(h=P * leadfac / 2, d=int_specs[2], $fn=fn);
                    cylinder(h=P * leadfac / 2, d1=Dsupport, d2=int_specs[2], $fn = fn);
                }
            }
        }
    }
};

module tap(designator, turns=0, length=0, higbee_arc=20, fn=120, table=THREAD_TABLE) {
    difference() {
        specs = thread_specs(str(designator, "-int"), table=table);
        P = specs[0]; Dsupport = specs[2];
        // If length is specified, calulate the turns and height based upon the length and pitch.
        turns = (turns != 0) ? turns : length / P;
        H = (length != 0) ? length : (turns + 1) * P;

        translate([0, 0, length != 0 ? 0 : -P / 2])
            cylinder(h=H, d=Dsupport, $fn=fn);
        
        thread(str(designator, "-int"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table);
    };
}

module nut(designator, turns, Douter, higbee_arc=20, fn=120, table=THREAD_TABLE) {
    union() {
        specs = thread_specs(str(designator, "-int"), table=table);
        P = specs[0]; Dsupport = specs[2];
        H = (turns + 1) * P;        
        thread(str(designator, "-int"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table);

        translate([0, 0, -P / 2])
            difference() {
                cylinder(h=H, d=Douter, $fn=fn);
                translate([0, 0, -0.1])
                    cylinder(h=H+0.2, d=Dsupport, $fn=fn);
            };
    };
};
