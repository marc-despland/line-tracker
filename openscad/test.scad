
use <servo.scad>
use <bille.scad>


translate([0,-40,0]){
    servo_wheel(true,true);
}

translate([0,40,wheelRadius()*2]){
    rotate([0,180,180]) {
        servo_wheel(true,true);
    }
}

translate([40,0,0]){
    bille();
}

translate([-40,0,0]){
    bille();
}