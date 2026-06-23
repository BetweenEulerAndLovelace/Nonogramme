class Grille {
  int tailleGrille;
  ArrayList<LinkedList<Integer>> contraintesV;
  ArrayList<LinkedList<Integer>> contraintesH;
  ArrayList<BoutonAjouterContrainte> ajouterContrainteV = new ArrayList<BoutonAjouterContrainte>(10);
  ArrayList<BoutonAjouterContrainte> ajouterContrainteH = new ArrayList<BoutonAjouterContrainte>(10);
  ArrayList<LinkedList<BoutonReglageContrainte>> reglerContraintesV = new ArrayList<LinkedList<BoutonReglageContrainte>>(10);
  ArrayList<LinkedList<BoutonReglageContrainte>> reglerContraintesH = new ArrayList<LinkedList<BoutonReglageContrainte>>(10);
  BoutonRect phase0finie = new BoutonRect(new PVector(debutGrille-2*largeurCase, debutGrille-3*largeurCase), new PVector(largeurCase*2, largeurCase), vertFonce, vert, "+/-") {
    void appuyer() {
      phase=1;
      initPhase1();
    }
    void moletteHaut() {
      tg+=1;
      tailleGrille+=1;
      contraintesV = new ArrayList<LinkedList<Integer>>(tg);
      contraintesH = new ArrayList<LinkedList<Integer>>(tg);
      for (int i=0; i<tg; i++) {
        contraintesV.add(new LinkedList<Integer>());
        contraintesH.add(new LinkedList<Integer>());
      }
    }
    void moletteBas() {
      if (tg>1) {
        tg-=1;
        tailleGrille-=1;
        contraintesV = new ArrayList<LinkedList<Integer>>(tg);
        contraintesH = new ArrayList<LinkedList<Integer>>(tg);
        for (int i=0; i<tg; i++) {
          contraintesV.add(new LinkedList<Integer>());
          contraintesH.add(new LinkedList<Integer>());
        }
      }
    }
  };
  BoutonRect phase1finie = new BoutonRect(new PVector(debutGrille-2*largeurCase, debutGrille-2*largeurCase), new PVector(largeurCase*2, largeurCase), vertFonce, vert, "Contraintes") {
    void appuyer() {
      phase=2;
      ajouterContrainteV.clear();
      ajouterContrainteH.clear();
      reglerContraintesV.clear();
      reglerContraintesH.clear();
      ArrayList<ArrayList<ArrayList<Case>>> res = resoudreDirect();
      for (ArrayList<ArrayList<Case>> aa : res) {
        printGrille(aa);
      }
    }
    void moletteHaut() {
    }
    void moletteBas() {
    }
  };
  BoutonRect phase2avant = new BoutonRect(new PVector(debutGrille-2*largeurCase, debutGrille-largeurCase), new PVector(largeurCase, largeurCase), vertFonce, vert, "<") {
    void appuyer() {
      // TODO
    }
    void moletteHaut() {
    }
    void moletteBas() {
    }
  };
  BoutonRect phase2apres = new BoutonRect(new PVector(debutGrille-largeurCase, debutGrille-largeurCase), new PVector(largeurCase, largeurCase), vertFonce, vert, ">") {
    void appuyer() {
      // TODO
    }
    void moletteHaut() {
    }
    void moletteBas() {
    }
  };
  ArrayList<ArrayList<Case>> plateau;
  Grille(int n) {
    tailleGrille = n;
    contraintesV = new ArrayList<LinkedList<Integer>>(n);
    contraintesH = new ArrayList<LinkedList<Integer>>(n);
    for (int i=0; i<n; i++) {
      contraintesV.add(new LinkedList<Integer>());
      contraintesH.add(new LinkedList<Integer>());
    }
  }
  void afficherGrille() {
    noFill();
    for (int i=0; i<tailleGrille; i++) {
      for (int j=0; j<tailleGrille; j++) {
        rect(debutGrille+i*largeurCase, debutGrille+j*largeurCase, largeurCase, largeurCase);
      }
    }
    strokeWeight(3);
    for (int i=0; i+5<=tailleGrille; i+=5) {
      for (int j=0; j+5<=tailleGrille; j+=5) {
        rect(debutGrille+i*largeurCase, debutGrille+j*largeurCase, 5*largeurCase, 5*largeurCase);
      }
    }
    strokeWeight(1);
    fill(gris);
    rect(debutGrille-largeurCase*2, debutGrille-3*largeurCase, largeurCase*2, largeurCase);
    rect(debutGrille-largeurCase*2, debutGrille-2*largeurCase, largeurCase*2, largeurCase);
    rect(debutGrille-largeurCase*2, debutGrille-largeurCase, largeurCase, largeurCase);
    rect(debutGrille-largeurCase, debutGrille-largeurCase, largeurCase, largeurCase);
    fill(noir);
    text("+/-", debutGrille-largeurCase, debutGrille-3*largeurCase+largeurCase/2);
    text("Contraintes", debutGrille-largeurCase, debutGrille-2*largeurCase+largeurCase/2);
    text("<", debutGrille-2*largeurCase+largeurCase/2, debutGrille-largeurCase+largeurCase/2);
    text(">", debutGrille-largeurCase/2, debutGrille-largeurCase+largeurCase/2);
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
    if (phase==0) {
      phase0finie.afficher();
    } else if (phase==1) {
      phase1finie.afficher();
    } else {
      phase2avant.afficher();
      phase2apres.afficher();
    }
    if (phase==2) { // Affichage des contraintes en phase 2
      for (int i=0; i<tg; i++) {
        for (int j=0; j<contraintesV.get(i).size(); j++) {
          text(contraintesV.get(i).get(j), debutGrille+i*largeurCase+largeurCase/2, debutGrille-contraintesV.get(i).size()*largeurCase+j*largeurCase+largeurCase/2);
        }
        for (int j=0; j<contraintesH.get(i).size(); j++) {
          text(contraintesH.get(i).get(j), debutGrille-contraintesH.get(i).size()*largeurCase+j*largeurCase+largeurCase/2, debutGrille+i*largeurCase+largeurCase/2);
        }
      }
    }
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
    if (phase==0 && phase0finie.estSurvole()) {
      phase0finie.appuyer();
    } else if (phase==1 && phase1finie.estSurvole()) {
      phase1finie.appuyer();
    } else if (phase==2 && phase2avant.estSurvole()) {
      phase2avant.appuyer();
    } else if (phase==2 && phase2apres.estSurvole()) {
      phase2apres.appuyer();
    }
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
    if (phase==0 && phase0finie.estSurvole()) {
      phase0finie.moletteHaut();
    } else if (phase==1 && phase1finie.estSurvole()) {
      phase1finie.moletteHaut();
    } else if (phase==2 && phase2avant.estSurvole()) {
      phase2avant.moletteHaut();
    } else if (phase==2 && phase2apres.estSurvole()) {
      phase2apres.moletteHaut();
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
    if (phase==0 && phase0finie.estSurvole()) {
      phase0finie.moletteBas();
    } else if (phase==1 && phase1finie.estSurvole()) {
      phase1finie.moletteBas();
    } else if (phase==2 && phase2avant.estSurvole()) {
      phase2avant.moletteBas();
    } else if (phase==2 && phase2apres.estSurvole()) {
      phase2apres.moletteBas();
    }
  }
  void initPhase1() {
    for (int i=0; i<tg; i++) {
      ajouterContrainteV.add(new BoutonAjouterContrainte(new PVector(debutGrille+i*largeurCase, debutGrille-largeurCase), new PVector(largeurCase, largeurCase), i, true, vertFonce, vert, "+") {
        void appuyer() {
          ajouterContrainte(1, rang, true);
        }
        void moletteHaut() {
        }
        void moletteBas() {
        }
      }
      );
      reglerContraintesV.add(new LinkedList<BoutonReglageContrainte>());
      ajouterContrainteH.add(new BoutonAjouterContrainte(new PVector(debutGrille-largeurCase, debutGrille+i*largeurCase), new PVector(largeurCase, largeurCase), i, false, vertFonce, vert, "+") {
        void appuyer() {
          ajouterContrainte(1, rang, false);
        }
        void moletteHaut() {
        }
        void moletteBas() {
        }
      }
      );
      reglerContraintesH.add(new LinkedList<BoutonReglageContrainte>());
    }
  }
  void initPhase2() {
    ajouterContrainteV.clear();
    ajouterContrainteH.clear();
    reglerContraintesV.clear();
    reglerContraintesH.clear();
  }
  void ajouterContrainte(int x, int rang, boolean v) {
    if (v) {
      if (contraintesV.size()>rang) {
        for (BoutonReglageContrainte b : reglerContraintesV.get(rang))
          b.decalerHaut(largeurCase);
        reglerContraintesV.get(rang).add(new BoutonReglageContrainte(new PVector(debutGrille+rang*largeurCase, debutGrille-largeurCase*2), new PVector(largeurCase, largeurCase), rang, contraintesV.get(rang).size(), true) {
          void appuyer() {
          }
          void moletteHaut() {
            incrContrainte(rang, sousRang, true);
          }
          void moletteBas() {
            decrContrainte(rang, sousRang, true);
          }
        }
        );
        contraintesV.get(rang).add(x);
      }
    } else {
      if (contraintesH.size()>rang) {
        for (BoutonReglageContrainte b : reglerContraintesH.get(rang))
          b.decalerGauche(largeurCase);
        reglerContraintesH.get(rang).add(new BoutonReglageContrainte(new PVector(debutGrille-2*largeurCase, debutGrille+rang*largeurCase), new PVector(largeurCase, largeurCase), rang, contraintesH.get(rang).size(), false) {
          void appuyer() {
          }
          void moletteHaut() {
            incrContrainte(rang, sousRang, false);
          }
          void moletteBas() {
            decrContrainte(rang, sousRang, false);
          }
        }
        );
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

  // Résolution
  ArrayList<ArrayList<ArrayList<Case>>> resoudreDirect() {
    ArrayList<ArrayList<ArrayList<Case>>> res = new ArrayList<ArrayList<ArrayList<Case>>>();
    // Init certains
    ArrayList<ArrayList<Case>> certains = new ArrayList<ArrayList<Case>>(tg);
    for (int i=0; i<tg; i++) {
      ArrayList<Case> l = new ArrayList<Case>(tg);
      for (int j=0; j<tg; j++)
        l.add(Case.LIBRE);
      certains.add(l);
    }
    // On cherche des colonnes et des lignes triviales
    for (int i=0; i<tg; i++) { // Colonne par colonne
      int s=0;
      for (int x : contraintesV.get(i))
        s+=x;
      if (s+contraintesV.get(i).size()-1==tg) { // On a trouvé une colonne triviale
        ArrayList<Boolean> truc = solutionTriviale(contraintesV.get(i), tg);
        // On la trace
        for (int j=0; j<tg; j++) {
          if (truc.get(j)) {
            certains.get(j).set(i, Case.NOIR);
          } else {
            certains.get(j).set(i, Case.BLANC);
          }
        }
      }
    }
    // Même chose pour les lignes
    for (int i=0; i<tg; i++) { // Ligne par ligne
      int s=0;
      for (int x : contraintesH.get(i))
        s+=x;
      if (s+contraintesH.get(i).size()-1==tg) {
        ArrayList<Boolean> truc = solutionTriviale(contraintesH.get(i), tg); // On calcule la rangée à tracer
        // On la trace
        for (int j=0; j<tg; j++) {
          if (truc.get(j)) {
            if (certains.get(i).get(j).blanc()) // Contradiction
              return res;
            certains.get(i).set(j, Case.NOIR);
          } else {
            if (certains.get(i).get(j).noir()) // Contradiction
              return res;
            certains.get(i).set(j, Case.BLANC);
          }
        }
      }
    }
    // On a établi quelques certitudes, on passe en mode bourrin
    return resoudre(certains, contraintesV, contraintesH);
  }
}
enum Case {
  BLANC, NOIR, LIBRE;
  boolean libre() {
    return this==LIBRE;
  }
  boolean blanc() {
    return this==BLANC;
  }
  boolean noir() {
    return this==NOIR;
  }
}
