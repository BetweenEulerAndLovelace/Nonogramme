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
  LinkedList<Integer> contraintes = new LinkedList<Integer>();
  contraintes.add(1); contraintes.add(2);
  ArrayList<ArrayList<Boolean>> res = getPossibilitesSsRecurrence(contraintes, 10);
  println(res.size());
  for (int i=0; i<res.size(); i++) {
    for (int j=0; j<res.get(i).size(); j++) {
      if (res.get(i).get(j)) {
        print("X");
      } else {
        print("o");
      }
    }
    println();
  }
  /*ArrayList<ArrayList<Integer>> aa = repartBlancs(5, 3);
  for (ArrayList<Integer> a : aa) {
    for (int x : a)
      print(x);
    println();
  }*/
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

/*void draw() {
  background(blanc);
  grille.afficherGrille();
}*/

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
  // Pour chaque ligne, on liste les solutions cohérentes. Puis on vérifie de façon bourrin si c'est cohérent avec les colonnes
  ArrayList<ArrayList<ArrayList<Boolean>>> solutions = new ArrayList<ArrayList<ArrayList<Boolean>>>(); // Pour chaque ligne, toutes les solutions respectant les contraintes
  for (int i=0; i<tg; i++) {
    solutions.add(getPossibilitesSsRecurrence(ctrH.get(i), tg));}
  for (int i=0; i<2<<tg; i++) { // Tous les agencements de lignes
    ArrayList<ArrayList<Case>> grilleTest = new ArrayList<ArrayList<Case>>(grille);
    boolean valide = true;
    for (int j=0; j<tg; j++) { // j désigne la ligne
      solutions.get(j).get
      for (int k=0; k<tg; k++) { // k désigne la colonne
        Case cc = grilleTest.get(j).get(k);
        if (cc.libre()) {
          
        }
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
ArrayList<ArrayList<Boolean>> getPossibilitesSsRecurrence(LinkedList<Integer> contraintes, int longueur) { // Renvoie toutes les façons de faire une ligne de taille l en respectant les contraintes
  ArrayList<ArrayList<Boolean>> res = new ArrayList<ArrayList<Boolean>>();
  int somme = 0;
  for (int x : contraintes)
    somme+=x;
  if (longueur < contraintes.size()+somme-1) {
    return res;
  } else if(longueur == contraintes.size()+somme-1) {
    res.add(solutionTriviale(contraintes, longueur));
  } else {
    int blancsDispos = longueur-somme-contraintes.size()+1;
    ArrayList<ArrayList<Integer>> agencements = repartBlancs(blancsDispos, contraintes.size()+1);
    for (ArrayList<Integer> a : agencements) {
      for (int x : a) {
        print(x, "");
      }
      println();
    }
    for (int i=0; i<agencements.size(); i++) { // Chaque possibilité
      ArrayList<Boolean> ajout = new ArrayList<Boolean>();
      ArrayList<Integer> ag = agencements.get(i);
      for (int j=0; j<ag.size(); j++) { // Trous de blancs entre les noirs
        for (int k=0; k<ag.get(j); k++) // Pour chaque blanc...
          ajout.add(false); // On met un blanc
        if (j>0 && j<ag.size()-1)
          ajout.add(false);
        if (j<ag.size()-1) {
          for (int k=0; k<contraintes.get(j); k++)
            ajout.add(true);
        }
      }
      res.add(ajout);
    }
  }
  return res;
}
ArrayList<Boolean> solutionTriviale(LinkedList<Integer> contraintes, int longueur) {
  ArrayList<Boolean> truc = new ArrayList<Boolean>(longueur);
  int curseur = 0;
  for (int x : contraintes) {
    for (int j=0; j<x; j++) {
      truc.add(true);
    }
    if (curseur+x+1<longueur)
      truc.add(false);
    curseur+=x+1;
  }
  return truc;
}
ArrayList<ArrayList<Integer>> repartBlancs(int nbBlancs, int empls) {
  ArrayList<ArrayList<Integer>> res = new ArrayList<ArrayList<Integer>>();
  if (empls==0) {
  } else if (empls==1) {
    ArrayList<Integer> a = new ArrayList<Integer>();
    a.add(nbBlancs);
    res.add(a);
  } else {
    for (int i=0; i<nbBlancs+1; i++) {
      ArrayList<ArrayList<Integer>> aa = repartBlancs(nbBlancs-i, empls-1);
      for (ArrayList<Integer> a : aa) {
        a.add(i);}
      res.addAll(aa);
    }
  }
  return res;
}
