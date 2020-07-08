/*
Create nice previews for documentation

:Author: Bryan Varner
:Date: 2020-06-08
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M6";
length = 10;
higbee_arc = 180;
leadin = 1;

bolt(type, length=length, higbee_arc=higbee_arc, leadin=leadin);
