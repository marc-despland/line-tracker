use <servo.scad>

support_width=65;
support_deep=25;
screw=3;

function supportWidth() = support_width;
function supportDeep() =support_deep;

module support_servo_bas(chassis_height=10,security=0,mask_security=0,with_screw=false) {
    support_height=wheelRadius()-chassis_height;
    difference() {
        union() {
            difference() {
                translate([-support_width/2,0,chassis_height]) cube([support_width,support_deep,support_height]);
                #translate([-support_width/2+15,0,chassis_height]) cube([support_width-30,support_deep,2.5]);
                #servo_wheel(false,true, false,security=security);
                
                translate([support_width/2-7.5,support_deep/2,0]) cylinder(100,d=screw+2*security,$fn=16);
                translate([-support_width/2+7.5,support_deep/2,0]) cylinder(100,d=screw+2*security,$fn=16);
            }
            translate([-support_width/2+5,5,chassis_height-5]) cylinder(5,d=5+2*mask_security,$fn=16);
            translate([-support_width/2+5,support_deep-5,chassis_height-5]) cylinder(5,d=5+2*mask_security,$fn=16);
            translate([support_width/2-5,5,chassis_height-5]) cylinder(5,d=5+2*mask_security,$fn=16);
            translate([support_width/2-5,support_deep-5,chassis_height-5]) cylinder(5,d=5+2*mask_security,$fn=16);
            if (with_screw) {
                translate([support_width/2-7.5,support_deep/2,chassis_height-5-5]) cylinder(40,d=screw+2*mask_security,$fn=16);
                translate([-support_width/2+7.5,support_deep/2,chassis_height-5-5]) cylinder(40,d=screw+2*mask_security,$fn=16);
            }
        }
        support_servo_haut(security,0.2);
    } 
}

module support_servo_haut(security=0,mask_security=0) {
    support_height=10;
    level=wheelRadius();
    difference() {
        translate([-support_width/2,0,level]) cube([support_width,support_deep,support_height]);
        #servo_wheel(false,true, false,security=security);
        
        translate([support_width/2-7.5,support_deep/2,0]) cylinder(100,d=screw+2*security,$fn=16);
        translate([-support_width/2+7.5,support_deep/2,0]) cylinder(100,d=screw+2*security,$fn=16);
    }
    translate([-support_width/2+5,5,level-5]) cylinder(5,d=5+2*mask_security,$fn=16);
    translate([-support_width/2+5,support_deep-5,level-5]) cylinder(5,d=5+2*mask_security,$fn=16);
    translate([support_width/2-5,5,level-5]) cylinder(5,d=5+2*mask_security,$fn=16);
    #translate([support_width/4,support_deep/2,level-5]) cylinder(5,d=5+2*mask_security,$fn=16);
}

!support_servo_bas(security=0.2,mask_security=0.2,with_screw=false);
support_servo_haut();