with Ada.Unchecked_Deallocation;
with exceptions; use exceptions;

package body Liste_Chainee is

	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Liste_Chainee);

    procedure Initialiser(Liste: in out T_Liste_Chainee) is
    begin
        Liste := null;
    end Initialiser;

    function  Taille(Liste: T_Liste_Chainee) return Integer is
        Cpt: Integer := 0;
        Aux: T_Liste_Chainee := Liste;
    begin
        while Aux /= null loop
            Cpt := Cpt + 1;
            Aux := Aux.all.Suivant;
        end loop;
        return Cpt;
    end Taille;

    procedure Ajouter(Liste: in out T_Liste_Chainee; Donnee: in T_Donnee) is
        Nouveau: T_Liste_Chainee;
    begin
        while Liste /= null loop
            Liste := Liste.all.Suivant;
        end loop;
        Nouveau := new T_Cellule'(Donnee, null);
        Liste := Nouveau;
    end;

    procedure AjouterApres(Liste: in out T_Liste_Chainee; Donnee: in T_Donnee; Index: in Integer) is
        Nouveau: T_Liste_Chainee;
        Aux: T_Liste_Chainee := Liste;
    begin
        if Index >= Taille(Liste) then
            raise IndexOutofRange;
        else
            for Cpt in 1 .. Index loop
                Aux := Aux.all.Suivant;
            end loop;
            Nouveau := new T_Cellule'(Donnee, Aux.all.Suivant);
            Aux.all.Suivant := Nouveau;
        end if;
    end;

    procedure Supprimer(Liste: in out T_Liste_Chainee; Index: in Integer) is
        Aux: T_Liste_Chainee := Liste;
        A_Supprimer: T_Liste_Chainee;
    begin
        if Index >= Taille(Liste) then
            raise IndexOutofRange;
        elsif Index = 0 then
            Liste := Liste.all.Suivant;
            Free(Aux);
        else
            for Cpt in 1 .. Index-1 loop
                Aux := Aux.all.Suivant;
            end loop;
            A_Supprimer := Aux.all.Suivant;
            Aux.all.Suivant := A_Supprimer.all.Suivant;
            Free(A_Supprimer);
        end if;
    end;

    function  Obtenir(Liste: T_Liste_Chainee; Index: Integer) return T_Donnee is
        Aux: T_Liste_Chainee := Liste;
    begin
        if Index >= Taille(Liste) then
            raise IndexOutofRange;
        else
            for Cpt in 1 .. Index loop
                Aux := Aux.all.Suivant;
            end loop;
            return Aux.all.Donnee;
        end if;
    end;

    function  IndexDe(Liste: T_Liste_Chainee; Donnee: T_Donnee) return Integer is
        Aux: T_Liste_Chainee := Liste;
        Cpt: Integer := 0;
    begin
        while Aux /= null or else Aux.all.Donnee /= Donnee loop
            Aux := Aux.all.Suivant;
            Cpt := Cpt+1;
        end loop;
        if Aux = null then
            raise DonneeManquante;
        else
            return Cpt;
        end if;
    end;

    function  EstDans(Liste: T_Liste_Chainee; Donnee: T_Donnee) return Boolean is
        Aux: T_Liste_Chainee := Liste;
    begin
        while Aux /= null or else Aux.all.Donnee /= Donnee loop
            Aux := Aux.all.Suivant;
        end loop;
        if Aux = null then
            return false;
        else
            return true;
        end if;
    end;

    procedure Detruire(Liste : in out T_Liste_Chainee) is
        Aux: T_Liste_Chainee := Liste;
    begin
        while Liste /= null loop
            Liste := Liste.all.Suivant;
            Free(Aux);
            Aux := Liste;
        end loop;
    end;

end Liste_Chainee;
