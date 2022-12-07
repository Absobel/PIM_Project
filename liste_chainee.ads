generic
    type T_Donnee is private;
package Liste_Chainee is

    type T_Cellule;
    type T_Liste_Chainee is access T_Cellule;
    type T_Cellule is private;

    -- Faudrait rajouter les postconditions ig
    procedure Initialiser(Liste: in out T_Liste_Chainee);
    function  Taille(Liste: T_Liste_Chainee) return Integer;
    procedure Ajouter(Liste: in out T_Liste_Chainee; Donnee: in T_Donnee);
    procedure AjouterApres(Liste: in out T_Liste_Chainee; Donnee: in T_Donnee; Index: in Integer);
    procedure Supprimer(Liste: in out T_Liste_Chainee; Index: in Integer);
    function  Obtenir(Liste: T_Liste_Chainee; Index: Integer) return T_Donnee;
    function  IndexDe(Liste: T_Liste_Chainee; Donnee: T_Donnee) return Integer;
    function  EstDans(Liste: T_Liste_Chainee; Donnee: T_Donnee) return Boolean;
    procedure Detruire(Liste : in out T_Liste_Chainee);

private

    type T_Cellule is record
        Donnee : T_Donnee;
        Suivant : T_Liste_Chainee;
    end record;

end Liste_Chainee;
