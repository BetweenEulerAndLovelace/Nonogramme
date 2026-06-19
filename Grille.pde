class Grille {
  int taille;
  ArrayList<LinkedList<Integer>> contraintesV;
  ArrayList<LinkedList<Integer>> contraintesH;
  ArrayList<BoutonAjouterContrainte> ajouterContrainteV = new ArrayList<BoutonAjouterContrainte>(10);
  ArrayList<BoutonAjouterContrainte> ajouterContrainteH = new ArrayList<BoutonAjouterContrainte>(10);
  ArrayList<LinkedList<BoutonReglageContrainte>> reglerContraintesV = new ArrayList<LinkedList<BoutonReglageContrainte>>(10);
  ArrayList<LinkedList<BoutonReglageContrainte>> reglerContraintesH = new ArrayList<LinkedList<BoutonReglageContrainte>>(10);
  Grille(int n) {
    taille = n;
    contraintesV = new ArrayList<LinkedList<Integer>>(n);
    contraintesH = new ArrayList<LinkedList<Integer>>(n);
    for (int i=0; i<n; i++) {
      contraintesV.add(new LinkedList<Integer>());
      contraintesH.add(new LinkedList<Integer>());
    }
  }
  void afficherGrille() {
    noFill();
    for (int i=0; i<taille; i++) {
      for (int j=0; j<taille; j++) {
        rect(debutGrille+i*largeurCase, debutGrille+j*largeurCase, largeurCase, largeurCase);
      }
    }
    strokeWeight(3);
    for (int i=0; i+5<=taille; i+=5) {
      for (int j=0; j+5<=taille; j+=5) {
        rect(debutGrille+i*largeurCase, debutGrille+j*largeurCase, 5*largeurCase, 5*largeurCase);
      }
    }
    strokeWeight(1);
    for (BoutonAjouterContrainte b : ajouterContrainteV)
      b.afficher();
    for (BoutonAjouterContrainte b : ajouterContrainteH)
      b.afficher();
    for (LinkedList<BoutonReglageContrainte> ll : reglerContraintesV)
      for (BoutonReglageContrainte b : ll)
        b.afficher();
    for (LinkedList<BoutonReglageContrainte> ll : reglerContraintesH)
      for (BoutonReglageContrainte b : ll)
        b.afficher();
    
  }
  void appuyer() {
    for (BoutonAjouterContrainte b : ajouterContrainteV)
      if (b.estSurvole())
        b.appuyer();
    for (BoutonAjouterContrainte b : ajouterContrainteH)
      if (b.estSurvole())
        b.appuyer();
    for (LinkedList<BoutonReglageContrainte> ll : reglerContraintesV)
      for (BoutonReglageContrainte b : ll)
        if (b.estSurvole())
          b.appuyer();
    for (LinkedList<BoutonReglageContrainte> ll : reglerContraintesH)
      for (BoutonReglageContrainte b : ll)
        if (b.estSurvole())
          b.appuyer();
  }
  void moletteHaut() {
    for (BoutonAjouterContrainte b : ajouterContrainteV)
      if (b.estSurvole())
        b.moletteHaut();
    for (BoutonAjouterContrainte b : ajouterContrainteH)
      if (b.estSurvole())
        b.moletteHaut();
    for (int i=0; i<reglerContraintesV.size(); i++) {
      LinkedList<BoutonReglageContrainte> ll = reglerContraintesV.get(i);
      for (int j=0; j<ll.size(); j++) {
        BoutonReglageContrainte b = ll.get(j);
        if (b.estSurvole())
          b.moletteHaut();
      }
    }
    for (int i=0; i<reglerContraintesH.size(); i++) {
      LinkedList<BoutonReglageContrainte> ll = reglerContraintesH.get(i);
      for (int j=0; j<ll.size(); j++) {
        BoutonReglageContrainte b = ll.get(j);
        if (b.estSurvole())
          b.moletteHaut();
      }
    }
  }
  void moletteBas() {
    for (BoutonAjouterContrainte b : ajouterContrainteV)
      if (b.estSurvole())
        b.moletteBas();
    for (BoutonAjouterContrainte b : ajouterContrainteH)
      if (b.estSurvole())
        b.moletteBas();
    for (int i=0; i<reglerContraintesV.size(); i++) {
      LinkedList<BoutonReglageContrainte> ll = reglerContraintesV.get(i);
      for (int j=0; j<ll.size(); j++) {
        BoutonReglageContrainte b = ll.get(j);
        if (b.estSurvole())
          b.moletteBas();
      }
    }
    for (int i=0; i<reglerContraintesH.size(); i++) {
      LinkedList<BoutonReglageContrainte> ll = reglerContraintesH.get(i);
      for (int j=0; j<ll.size(); j++) {
        BoutonReglageContrainte b = ll.get(j);
        if (b.estSurvole())
          b.moletteBas();
      }
    }
  }
  void initPhase1() {
    for (int i=0; i<tg; i++) {
      ajouterContrainteV.add(new BoutonAjouterContrainte(new PVector(debutGrille+i*largeurCase, debutGrille-largeurCase), new PVector(largeurCase, largeurCase), i, true, vertFonce, vert, "+") {
        void appuyer() {
          ajouterContrainte(1, rang, true);
        }
        void moletteHaut() {}
        void moletteBas() {}
      });
      reglerContraintesV.add(new LinkedList<BoutonReglageContrainte>());
      ajouterContrainteH.add(new BoutonAjouterContrainte(new PVector(debutGrille-largeurCase, debutGrille+i*largeurCase), new PVector(largeurCase, largeurCase), i, false, vertFonce, vert, "+") {
        void appuyer() {
          ajouterContrainte(1, rang, false);
        }
        void moletteHaut() {}
        void moletteBas() {}
      });
      reglerContraintesH.add(new LinkedList<BoutonReglageContrainte>());
    }
  }
  void ajouterContrainte(int x, int rang, boolean v) {
    if (v) {
      if (contraintesV.size()>rang) {
        for (BoutonReglageContrainte b : reglerContraintesV.get(rang))
          b.decalerHaut(largeurCase);
        reglerContraintesV.get(rang).add(new BoutonReglageContrainte(new PVector(debutGrille+rang*largeurCase, debutGrille-largeurCase*2), new PVector(largeurCase, largeurCase), rang, contraintesV.get(rang).size(), true) {
          void appuyer() {}
          void moletteHaut() {
            incrContrainte(rang, sousRang, true);
          }
          void moletteBas() {
            decrContrainte(rang, sousRang, true);
          }
        });
        contraintesV.get(rang).add(x);
      }
    } else {
      if (contraintesH.size()>rang) {
        for (BoutonReglageContrainte b : reglerContraintesH.get(rang))
          b.decalerGauche(largeurCase);
        reglerContraintesH.get(rang).add(new BoutonReglageContrainte(new PVector(debutGrille-2*largeurCase, debutGrille+rang*largeurCase), new PVector(largeurCase, largeurCase), rang, contraintesH.get(rang).size(), false) {
          void appuyer() {}
          void moletteHaut() {
            incrContrainte(rang, sousRang, false);
          }
          void moletteBas() {
            decrContrainte(rang, sousRang, false);
          }
        });
        contraintesH.get(rang).add(x);
      }
    }
  }
  void incrContrainte(int rang, int sousRang, boolean v) {
    if (v) {
      if (contraintesV.size()>rang && contraintesV.get(rang).size()>sousRang) {
        int val = contraintesV.get(rang).get(sousRang);
        contraintesV.get(rang).set(sousRang, val+1);
        reglerContraintesV.get(rang).get(sousRang).texte = Integer.toString(val+1);
      }
    } else {
      if (contraintesH.size()>rang && contraintesH.get(rang).size()>sousRang) {
        int val = contraintesH.get(rang).get(sousRang);
        contraintesH.get(rang).set(sousRang, val+1);
        reglerContraintesH.get(rang).get(sousRang).texte = Integer.toString(val+1);
      }
    }
  }
  void decrContrainte(int rang, int sousRang, boolean v) {
    if (v) {
      if (contraintesV.size()>rang && contraintesV.get(rang).size()>sousRang) {
        int val = contraintesV.get(rang).get(sousRang);
        contraintesV.get(rang).set(sousRang, val-1);
        reglerContraintesV.get(rang).get(sousRang).texte = Integer.toString(val-1);
        if (val-1<=0) { // Partie suppression
          contraintesV.get(rang).remove(sousRang);
          reglerContraintesV.get(rang).remove(sousRang);
          for (int i=0; i<sousRang; i++) {
            reglerContraintesV.get(rang).get(i).decalerBas(largeurCase);
          }
          for (int i=sousRang; i<reglerContraintesV.get(rang).size(); i++) {
            reglerContraintesV.get(rang).get(i).sousRang -= 1;
          }
        }
      }
    } else {
      if (contraintesH.size()>rang && contraintesH.get(rang).size()>sousRang) {
        int val = contraintesH.get(rang).get(sousRang);
        contraintesH.get(rang).set(sousRang, val-1);
        reglerContraintesH.get(rang).get(sousRang).texte = Integer.toString(val-1);
        if (val-1<=0) { // Partie suppression
          contraintesH.get(rang).remove(sousRang);
          reglerContraintesH.get(rang).remove(sousRang);
          for (int i=0; i<sousRang; i++) {
            reglerContraintesH.get(rang).get(i).decalerDroite(largeurCase);
          }
          for (int i=sousRang; i<reglerContraintesH.get(rang).size(); i++) {
            reglerContraintesH.get(rang).get(i).sousRang -= 1;
          }
        }
      }
    }
  }
}
