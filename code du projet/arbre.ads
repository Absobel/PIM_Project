with adresseip ;  use adresseip;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;

package arbre is

   type T_LA is limited private;


 Procedure Initialiser (arbre : in out T_LA) with
  	post => taille(arbre) = 0;

 --Obtenir la taille de l'arbre
 function taille (arbre : in T_LA) return integer;


 Procedure Supprimer (Courant : in Integer ; Arbre : in out T_LA);


 -- tariter une adresse.
 Procedure Lire (Courant : in Integer ; Cle : in T_AdresseIP  ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in out T_LA);


 --Enregistrer une cle dans l'arbre.
 Procedure Enregistrer (Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : in Unbounded_String ; Arbre : in out T_LA);


 --Afficher l'arbre.
 Procedure Afficher (arbre : in T_LA);

 procedure vider (arbre : in out T_LA);


private

 type T_Noeud;

 type T_LA is access T_Noeud;

 type T_Noeud is
    record
        Cle : T_AdresseIP ;
        Valeur: Unbounded_String;
        Consultation : Integer;
        Gauche : T_LA ;   -- fils gauche.
        Droite : T_LA ;  -- fils droit
 end record;

end arbre;
