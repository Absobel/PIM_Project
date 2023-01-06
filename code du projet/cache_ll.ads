with Ada.Strings;                 use Ada.Strings;
with LCA;
with adresseIP;                   use adresseIP;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;

package Cache_LL is

    type T_Cache is limited private;
    type T_Cellule is limited private;



    procedure Initialiser (Cache : in out T_Cache; Taille_Max : Integer);
    procedure Afficher_Statistiques (Cache : in T_Cache);
    procedure Afficher (Cache : in T_Cache; Politique : in Unbounded_String);
    procedure Lire (Cache : in out T_Cache; Destination : in T_AdresseIP; Politique : Unbounded_String ; DestInterface : out Unbounded_String; A_Trouve : out Boolean);
    procedure Ajouter (Cache : in out T_Cache; Destination : in T_AdresseIP; DestInterface : in Unbounded_String; Politique : in Unbounded_String);
    procedure Incrementer_Defauts (Cache : in out T_Cache);

    -- Tests
    function Taille (Cache : in T_Cache) return Integer;
    function Est_Vide (Cache : in T_Cache) return Boolean;
    function Nb_Appels_Destination (Cache : in T_Cache; Destination : in T_AdresseIP) return Integer;

private

    type T_Cellule is record
        DestInterface : Unbounded_String;
        Nb_Appels_Adresse : Integer;
    end record;

    package Liste_Adresse_Cellule is new LCA (T_Cle => T_AdresseIP, T_Donnee => T_Cellule);
    use Liste_Adresse_Cellule;

    type T_Cache is record
        Liste : T_LCA;
        Taille_Max : Integer;
        Nb_Appels : Integer;
        Nb_Defauts : Integer;
    end record;

end Cache_LL;