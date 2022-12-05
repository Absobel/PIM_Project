with Ada.Unchecked_Deallocation;

package body LL is

	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Pile);

    procedure Initialiser(Liste: in out T_Liste_Chainee) is
    begin
        Liste := null;
    end Initialiser;

    function  Taille(Liste: T_Liste_Chainee) return Integer is
        Cpt: Integer := 0;
        Aux: T_Liste_Chainee := Liste;
    begin
        while Liste /= null loop
            Cpt := Cpt + 1;
            Aux := Aux.all.Suivant;
        end loop;
        return Cpt;
    end Taille;

    procedure Ajouter(Liste: in out T_Liste_Chainee; Donnee: in T_Donnee) is
        Nouveau: T_Cellule;
    begin
        Nouveau := new T_Cellule'(Donnee, Liste);
    end;

end LL;
