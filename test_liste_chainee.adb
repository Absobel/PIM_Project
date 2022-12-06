with Ada.Text_IO; use Ada.Text_IO;
with Liste_Chainee;
with exceptions; use exceptions;

procedure test_liste_chainee is
    
    package LC is new Liste_Chainee(Integer);
    use LC;

    Liste : T_Liste_Chainee;
    A : Integer;
begin
    Initialiser(Liste);
    -- []
    pragma assert(Taille(Liste) = 0);
    Put_Line("Initialisation : OK");

    Ajouter(Liste, 23);
    -- [23]
    pragma assert(Taille(Liste) = 1);
    pragma assert(Obtenir(Liste, 1) = 23);
    Ajouter(Liste, 183);
    -- [23, 183]
    pragma assert(Taille(Liste) = 2);
    pragma assert(Obtenir(Liste, 2) = 183);
    Put_Line("Ajout : OK");
    
    AjouterApres(Liste, 364, 0);
    -- [364, 23, 183]
    pragma assert(Taille(Liste) = 3);
    pragma assert(Obtenir(Liste, 0) = 364);
    Put_Line("Ajout après : OK");

    Supprimer(Liste, 1);
    -- [364, 183]
    pragma assert(Taille(Liste) = 2);
    pragma assert(Obtenir(Liste, 1) = 183);
    Put_Line("Suppression : OK");

    pragma assert(IndexDe(Liste, 183) = 1);
    Put_Line("Index de : OK");
    pragma assert(EstDans(Liste, 183));
    pragma assert(not EstDans(Liste, 3863));
    Put_Line("Est dans : OK");

    begin
        Supprimer(Liste, 3863);
    exception
        when IndexOutofRange => Put_Line("IndexOutofRange : OK");
    end;

    begin
        A := IndexDe(Liste, 3863);
    exception
        when DonneeManquante => Put_Line("DonneeManquante : OK");
    end;

    Detruire(Liste);

    New_Line;Put_Line("Fin des tests : OK");
end;