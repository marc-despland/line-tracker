
    rayon_bille=6;
    rayon_fixation_vis=2.9;
    rayon_corps=15.5/2;
    rayon_tete_vis=2;
    hauteur_corps=11.5;
    hauteur_fixation_vis=max(8.2,hauteur_corps);
    hauteur=15;
    largeur=22;
    hauteur_tete_vis=1.8;
    cote_carre=5;
    diamettre_petite_bille=3;


module bille(security=0) {
    //petite bille
    translate([cote_carre,cote_carre,hauteur-hauteur_corps]){
        cylinder(hauteur_corps+security,d=diamettre_petite_bille+2*security,$fn=32);
    }
    translate([cote_carre,-cote_carre,hauteur-hauteur_corps]){
        cylinder(hauteur_corps+security,d=diamettre_petite_bille+2*security,$fn=32);
    }
   translate([-cote_carre,cote_carre,hauteur-hauteur_corps]){
        cylinder(hauteur_corps+security,d=diamettre_petite_bille+2*security,$fn=32);
    }
    translate([-cote_carre,-cote_carre,hauteur-hauteur_corps]){
        cylinder(hauteur_corps+security,d=diamettre_petite_bille+2*security,$fn=32);
    }
    
    decallage_centre_vis=(largeur-(2*rayon_corps)-(2*rayon_fixation_vis))/2;
    //tete vis droite
    translate([0,decallage_centre_vis+rayon_corps,hauteur]){
        cylinder(hauteur_tete_vis+security,d=2*(rayon_tete_vis+security),$fn=32);
    }
     //tete vis gauche
    translate([0,-1*(decallage_centre_vis+rayon_corps),hauteur]){
        cylinder(hauteur_tete_vis+security,d=2*(rayon_tete_vis+security),$fn=32);
    }
   //fixation vis droite
    translate([0,decallage_centre_vis+rayon_corps,hauteur-hauteur_fixation_vis]){
        cylinder(hauteur_fixation_vis+security,d=2*(rayon_fixation_vis+security),$fn=32);
    }
    //fixation vis gauche
    translate([0,-1*(decallage_centre_vis+rayon_corps),hauteur-hauteur_fixation_vis]){
        cylinder(hauteur_fixation_vis+security,d=2*(rayon_fixation_vis+security),$fn=32);
    }
    //corps
    translate([0,0,hauteur-hauteur_corps]){
        cylinder(hauteur_corps+security,d=2*(rayon_corps+security),$fn=32);
    }
    //bille
    translate([0,0,rayon_bille]){
        sphere(rayon_bille);
    }
}

module bille_box(size=5, security=0.2) {
   difference() {
       //translate([-(rayon_corps+size),-(rayon_corps+rayon_fixation_vis+size),hauteur-hauteur_corps]) cube([2*(rayon_corps+size),2*(rayon_corps+rayon_fixation_vis+size), hauteur_corps+hauteur_tete_vis+security]);
       translate([0,0,hauteur-hauteur_corps]) resize([2*(rayon_corps+size),0,0]) cylinder(hauteur_corps+hauteur_tete_vis+security+size,d=2*(rayon_corps+rayon_fixation_vis+size),$fn=64);
       #bille(security);
   }
}

bille_box(5,0.2);
