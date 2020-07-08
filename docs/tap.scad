/*
Create nice previews for documentation

:Author: Bryan Varner
:Date: 2020-06-08
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M6";
turns = 5;
higbee_arc = 45;

tap(type, turns, higbee_arc=higbee_arc);
