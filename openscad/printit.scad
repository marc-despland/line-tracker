use <chassis.scad>
use <tracker.scad>
use <servo.scad>
use <bille.scad>
use <led.scad>
use <support_servo.scad>
use <electronic_board.scad>


step =5;

if (step==1) {
    // print it black
    rotate([0,0,45]) translate([0,0,-3.5]) chassis();
}
if (step==2) {
    // print it orange
    translate([0,0,wheelRadius()]) rotate([180,0,0]) {
        support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=false);
        translate([0,40,0]) support_servo_bas(chassis_height=sensorHeight()+10,security=0.2,mask_security=0,with_screw=false);
    }
    translate([0,40,0]) rotate([0,0,90]) chapeau_cube();
}
if (step==3) {
    // print it orange
    translate([0,0,-wheelRadius()+5]) chassis_haut();
}
if (step==4) {
    // print it translucide
    led(20);
    translate([35,0,0])leds();
}

if (step==5) {
    // print it black
    translate([0,0,4]) rotate([180,0,0]) capot_led();
    entretoises(90,45,25, security=0.2);
}