with Ada.Strings;                 use Ada.Strings;
with LCA;
with adresseIP;                   use adresseIP;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;

package Cache_LL is

    type T_Cache is limited private;
    type T_Cellule is limited private;

    package Liste_Adresse_Cellule is new LCA (T_Cle => T_AdresseIP, T_Donnee => T_Cellule);
    use Liste_Adresse_Cellule;

    procedure Initialiser (Cache : in out T_Cache; Taille_Max : Integer);
    procedure Afficher_Statistiques (Cache : in T_Cache);
    procedure Afficher (Cache : in T_Cache);
    procedure Lire (Cache : in out T_Cache; Destination : in T_AdresseIP; Politique : Unbounded_String ; DestInterface : out String; A_Trouve : out Boolean);
    procedure Ajouter (Cache : in out T_Cache; Destination : in T_AdresseIP; DestInterface : in String; Politique : in Unbounded_String);

private

    type T_Cellule is record
        DestInterface : String;
        Nb_Appels_Adresse : Integer;
    end record;

    type T_Cache is record
        Liste : T_LCA;
        Taille_Max : Integer;
        Nb_Appels : Integer;
        Nb_Defauts : Integer;
    end record;

end Cache_LL;