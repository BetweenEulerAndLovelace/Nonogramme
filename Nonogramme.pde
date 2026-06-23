import java.util.LinkedList;
color blanc = #FFFFFF;
color gris = #AAAAAA;
color noir = #000000;
color vert = #00FF00;
color vertFonce = #00AA00; 
int phase = 0; // 0 (taille de la grille), 1 (contraintes), 2 (réponse)
final int largeurCase = 30;
final int debutGrille = 240;
int tg = 10;
//ArrayList<Bouton> boutons = new ArrayList<Bouton>();
Grille grille;

void setup() {
  fullScreen();
  background(blanc);
  textAlign(CENTER, CENTER);
  grille = new Grille(tg);
  /*BoutonRect tailleReglage = new BoutonRect(new PVector(debutGrille-largeurCase,debutGrille-largeurCase), new PVector(largeurCase, largeurCase), vertFonce, vert, "+") {
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
  boutons.add(tailleReglage);*/
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

/*void debutContraintes() {
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
}*/

void draw() {
  background(blanc);
  grille.afficherGrille();
  /*for (int i=0; i<boutons.size(); i++) {
    boutons.get(i).afficher();
  }*/
}

void mousePressed() {
  /*for (int i=0; i<boutons.size(); i++) {
    Bouton b = boutons.get(i);
    if (b.estSurvole())
      b.appuyer();
  }*/
  grille.appuyer();
}
void mouseWheel(MouseEvent e) {
  /*for (Bouton b : boutons) {
    if (b.estSurvole() && e.getCount()<0) {
      b.moletteHaut();
    } else if (b.estSurvole() && e.getCount()>0) {
      b.moletteBas();
    }
  }*/
  if (e.getCount()<0) {
    grille.moletteHaut();
  } else {
    grille.moletteBas();
  }
}
void printGrille(ArrayList<ArrayList<Case>> grille) {
  for (int i=0; i<tg; i++) {
    for (int j=0; j<tg; j++) {
      if (grille.get(i).get(j).blanc()) {
        print("o");
      } else if (grille.get(i).get(j).noir()) {
        print("X");
      } else {
        print(".");
      }
    }
    println();
  }
}
ArrayList<ArrayList<ArrayList<Case>>> resoudre(ArrayList<ArrayList<Case>> grille, ArrayList<LinkedList<Integer>> ctrV, ArrayList<LinkedList<Integer>> ctrH) {
  ArrayList<ArrayList<ArrayList<Case>>> res = new ArrayList<ArrayList<ArrayList<Case>>>();
  ArrayList<Integer> casesLibresLignes = new ArrayList<Integer>();
  ArrayList<Integer> casesLibresColonnes = new ArrayList<Integer>();
  for (int i=0; i<tg; i++) { // Liste des cases libres à remplir
    for (int j=0; j<tg; j++) {
      if (grille.get(i).get(j).libre()) {
        casesLibresLignes.add(i);
        casesLibresColonnes.add(j);
      }
    }
  }
  // On compte les cases apparentes, on fait une boucle sur i<<n, on vérifie les grilles complètes que ça donne, on garde les cohérentes
  for (int i=0; i<1<<casesLibresLignes.size(); i++) {
    ArrayList<ArrayList<Case>> test = (ArrayList<ArrayList<Case>>)grille.clone();
    for (int j=0; j<casesLibresLignes.size(); j++) {
      int ligne = casesLibresLignes.get(j);
      int colonne = casesLibresColonnes.get(j);
      test.get(ligne).set(colonne, ((i>>j)%2==0)?Case.NOIR:Case.BLANC);
      printGrille(test);
      println();
      if (testCoherence(test, ctrV, ctrH)) {
        res.add(test);
      }
    }
  }
  return res;
}
boolean testCoherence(ArrayList<ArrayList<Case>> grille, ArrayList<LinkedList<Integer>> ctrV, ArrayList<LinkedList<Integer>> ctrH) {
  for (int i=0; i<tg; i++) {
    // Lignes, empirique
    ArrayList<Integer> seriesObservees = new ArrayList<Integer>();
    int noirsAccus = 0;
    for (int j=0; j<tg; j++) {
      if (grille.get(i).get(j).blanc()) {
        if (noirsAccus>0) {
          seriesObservees.add(noirsAccus);
          noirsAccus = 0;
        }
      } else {
        noirsAccus+=1;
      }
      if (j==tg-1 && noirsAccus>0) {
        seriesObservees.add(noirsAccus);
      }
    }
    // Lignes, cohérence
    if (ctrH.size()!=seriesObservees.size())
      return false;
    for (int j=0; j<ctrH.get(i).size(); j++)
      if (ctrH.get(i).get(j)!=seriesObservees.get(j))
        return false;
    // Colonnes, empirique
    seriesObservees = new ArrayList<Integer>();
    noirsAccus = 0;
    for (int j=0; j<tg; j++) {
      if (grille.get(j).get(i).blanc()) {
        if (noirsAccus>0) {
          seriesObservees.add(noirsAccus);
          noirsAccus = 0;
        }
      } else {
        noirsAccus+=1;
      }
      if (j==tg-1 && noirsAccus>0) {
        seriesObservees.add(noirsAccus);
      }
    }
    // Colonnes, cohérence
    if (ctrV.size()!=seriesObservees.size())
      return false;
    for (int j=0; j<ctrV.get(i).size(); j++)
      if (ctrV.get(i).get(j)!=seriesObservees.get(j))
        return false;
  }
  // Flying colours
  return true;
}
ArrayList<ArrayList<Boolean>> getPossibilites(LinkedList<Integer> contraintes, int longueur) {
  ArrayList<ArrayList<Boolean>> res = new ArrayList<ArrayList<Boolean>>();
  int somme = 0;
  for (int x : contraintes)
    somme+=x;
  if (somme==longueur) {
    // On construit la seule possibilité
    res.add(solutionTriviale(contraintes, longueur));
  } else if (somme<longueur) {
    // On diminue la longueur
    ArrayList<ArrayList<Boolean>> pos = getPossibilites(contraintes, longueur-1);
    for (ArrayList<Boolean> p : pos) {
      p.add(0, false);
      res.add(p);
    }
    // On ajoute une contrainte au début
    LinkedList<Integer> cAmputee = new LinkedList<Integer>(contraintes); int l = cAmputee.removeFirst();
    res.addAll(getPossibilites(cAmputee, longueur-l));
  }
  return res;
}
ArrayList<Boolean> solutionTriviale(LinkedList<Integer> contraintes, int longueur) {
  ArrayList<Boolean> truc = new ArrayList<Boolean>(longueur);
  int curseur = 0;
  for (int x : contraintes) {
    for (int j=0; j<x; j++) {
      truc.set(curseur+j, true);
    }
    if (curseur+x+1<tg)
      truc.set(curseur+x+1, false);
    curseur+=x+1;
  }
  return truc;
}
