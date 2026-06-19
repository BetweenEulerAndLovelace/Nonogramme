import java.util.LinkedList;
color blanc = #FFFFFF;
color noir = #000000;
color vert = #00FF00;
color vertFonce = #00AA00; 
int phase = 0; // 0 (taille de la grille), 1 (contraintes), 2 (réponse)
final int largeurCase = 30;
final int debutGrille = 240;
int tg = 10;
ArrayList<Bouton> boutons = new ArrayList<Bouton>();
Grille grille;

void setup() {
  fullScreen();
  background(blanc);
  textAlign(CENTER, CENTER);
  grille = new Grille(tg);
  BoutonRect tailleReglage = new BoutonRect(new PVector(debutGrille-largeurCase,debutGrille-largeurCase), new PVector(largeurCase, largeurCase), vertFonce, vert, "+") {
    void appuyer() {
      boutons.clear();
      grille.initPhase1();
    }
    void moletteHaut() {
      tg+=1;
      grille = new Grille(tg);
    }
    void moletteBas() {
      if (tg>1) {
        tg-=1;
        grille = new Grille(tg);
      }
    }
  };
  boutons.add(tailleReglage);
  /*BoutonRect bTest = new BoutonRect(new PVector(400, 100), new PVector(40, 10), vertFonce, vert, "T"){
    void appuyer() {
      print("=");
    }
    void moletteHaut() {
      print("+");
    }
    void moletteBas() {
      print("-");
    }
  };
  boutons.add(bTest);*/
}

void debutContraintes() {
  boutons.clear();
  for (int i=0; i<tg; i++) {
    // Vertical
    boutons.add(new BoutonAjouterContrainte(new PVector(debutGrille+largeurCase*i, debutGrille-largeurCase), new PVector(largeurCase, largeurCase), i, true, vertFonce, vert, "+") {
      void appuyer() {
        grille.ajouterContrainte(1, rang, true);
      }
      void moletteHaut() {}
      void moletteBas() {}
    });
  }
}

void draw() {
  background(blanc);
  grille.afficherGrille();
  for (int i=0; i<boutons.size(); i++) {
    boutons.get(i).afficher();
  }
}

void mousePressed() {
  for (int i=0; i<boutons.size(); i++) {
    Bouton b = boutons.get(i);
    if (b.estSurvole())
      b.appuyer();
  }
  grille.appuyer();
}
void mouseWheel(MouseEvent e) {
  for (Bouton b : boutons) {
    if (b.estSurvole() && e.getCount()<0) {
      b.moletteHaut();
    } else if (b.estSurvole() && e.getCount()>0) {
      b.moletteBas();
    }
  }
  if (e.getCount()<0) {
    grille.moletteHaut();
  } else {
    grille.moletteBas();
  }
}
