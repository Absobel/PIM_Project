with Ada.Text_IO; use Ada.Text_IO;
with LCA;
with exceptions; use exceptions;

procedure test_liste_chainee is

    package LC is new LCA(Integer, Integer);
    use LC;

    Liste : T_LCA;
begin
    Initialiser(Liste);
    -- []
    pragma assert(Taille(Liste) = 0);
    Put_Line("Initialisation : OK");

    Enregistrer(Liste, 0, 23);
    -- [23]
    pragma assert(Taille(Liste) = 1);
    pragma assert(La_Donnee(Liste, 1) = 23);
    Enregistrer(Liste, 1, 183);
    -- [23, 183]
    pragma assert(Taille(Liste) = 2);
    pragma assert(La_Donnee(Liste, 2) = 183);
    Put_Line("Ajout : OK");

    Enregistrer(Liste, 3, 364);
    -- [364, 23, 183]
    pragma assert(Taille(Liste) = 3);
    pragma assert(La_Donnee(Liste, 0) = 364);
    Put_Line("Ajout après : OK");

    Supprimer(Liste, 1);
    -- [364, 183]
    pragma assert(Taille(Liste) = 2);
    pragma assert(La_Donnee(Liste, 1) = 183);
    Put_Line("Suppression : OK");

    pragma assert(Cle_Presente(Liste, 0));
    pragma assert(not Cle_Presente(Liste, 2));
    Put_Line("Est dans : OK");

    begin
        Supprimer(Liste, 3863);
    exception
        when IndexOutofRange => Put_Line("Cle_Absente_Exception : OK");
    end;

    Vider(Liste);

    pragma assert(Taille(Liste) = 0);
    pragma assert(Est_Vide(Liste));
    Put_Line("Vidage : OK");

    New_Line;Put_Line("Fin des tests : OK");
end;
