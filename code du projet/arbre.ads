with adresseip; use adresseip;

generic
    type T_Valeur is private;
    ValeurParDefaut : T_Valeur;
package arbre is

   type T_LA is limited private;


 Procedure Initialiser (arbre : in out T_LA) with
  	post => taille(arbre) = 0;

 --Obtenir la taille de l'arbre
 function taille (arbre : in T_LA) return integer;

 -- Suuprime un élément à partir de sa clé
 Procedure Supprimer (Cle : in T_AdresseIP ; Arbre : in out T_LA);


 -- Lire une adresse dans l'arbre.
 Procedure Lire (Cle : in T_AdresseIP  ; Valeur : out T_Valeur ; A_Trouve : out Boolean ; Arbre : in out T_LA);


 --Enregistrer une cle dans l'arbre.
 Procedure Enregistrer (Cle : in T_AdresseIP ; Valeur : in T_Valeur ; Arbre : in out T_LA);


 --Afficher l'arbre selon la procédure AfficherNoeud.
 generic
    with procedure AfficherNoeud (Cle : in T_AdresseIP ; Valeur : in T_Valeur);
 Procedure Afficher (arbre : in T_LA);

 -- Vider l'arbre.
 procedure Vider (arbre : in out T_LA);

 -- Applique Traiter à chaque noeud de l'arbre.
 generic
    with procedure Traiter(Cle: in T_AdresseIP ; Valeur: in T_Valeur);
 procedure PourChaque(Arbre : in T_LA);


private

 type T_Noeud;

 type T_LA is access T_Noeud;

 type T_Noeud is
    record
        Cle : T_AdresseIP ;
        Valeur: T_Valeur;
        Gauche : T_LA ;   -- fils gauche.
        Droite : T_LA ;  -- fils droit
 end record;

end arbre;
