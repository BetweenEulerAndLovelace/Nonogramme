abstract class Bouton {
  PVector pos;
  PVector taille;
  Bouton(PVector u, PVector v) {
    pos = u;
    taille = v;
  }
  abstract void afficher();
  abstract void appuyer();
  abstract void moletteHaut();
  abstract void moletteBas();
  boolean estSurvole() {
    return mouseX>=pos.x && mouseX<=pos.x+taille.x && mouseY>=pos.y && mouseY<=pos.y+taille.y;
  }
  void decalerHaut(int d) {
    pos.y-=d;
  }
  void decalerBas(int d) {
    pos.y+=d;
  }
  void decalerGauche(int d) {
    pos.x-=d;
  }
  void decalerDroite(int d) {
    pos.x+=d;
  }
}

abstract class BoutonRect extends Bouton {
  color cPassive;
  color cActive;
  String texte;
  BoutonRect(PVector u, PVector v, color ca, color cp, String t) {
    super(u,v);
    cPassive=cp;
    cActive=ca;
    texte=t;
  }
  void afficher() {
    if (estSurvole() && mousePressed) {
      fill(cActive);
    } else {
      fill(cPassive);
    }
    rect(pos.x, pos.y, taille.x, taille.y);
    fill(noir);
    text(texte, pos.x+taille.x/2, pos.y+taille.y/2);
  }
}
abstract class BoutonInvisible extends Bouton {
  String texte;
  BoutonInvisible(PVector u, PVector v, String t) {
    super(u,v);
    texte = t;
  }
  void afficher() {
    text(texte, pos.x+taille.x/2, pos.y+taille.y/2);
  }
}
abstract class BoutonReglageContrainte extends BoutonInvisible {
  int rang;
  int sousRang;
  boolean vertical;
  BoutonReglageContrainte(PVector u, PVector v, int r, int sr, boolean vert) {
    super(u,v,"1");
    rang = r;
    sousRang = sr;
    vertical = vert;
  }
}
abstract class BoutonAjouterContrainte extends BoutonRect {
  int rang;
  boolean vertical;
  BoutonAjouterContrainte(PVector u, PVector v, int r, boolean b, color ca, color cp, String t) {
    super(u, v, ca, cp, t);
    vertical = b;
    rang = r;
  }
}
