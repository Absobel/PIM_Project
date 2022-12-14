with adresseip; use adresseip;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with arbre;

package cache_la is

    type T_Noeud is record
        Destination : unbounded_string;
        DerniereConsultation : Integer;
        NombreConsultation : Integer;
    end record;

    package arbre_cache is new arbre (T_Noeud, T_Noeud'(To_Unbounded_String("Erreur"), 0, 0));
    use arbre_cache;

    type T_Cache is limited private;

    procedure Initialiser(cache: in out T_Cache ; Taille_Max : in Integer ; Politique : in Unbounded_String);

    Procedure Statistiques(cache : in T_Cache);

    procedure Lire(cache : in out T_Cache ; Adresse : in T_AdresseIP ; Destination : out Unbounded_String ; A_Trouve : out Boolean);

    procedure Enregistrer(Cache : in out T_Cache ; Adresse : in T_AdresseIP ; Masque : in T_AdresseIP ; Destination : in Unbounded_String);

    procedure Afficher(Cache : in T_Cache ; Ligne : in Integer);

    procedure Vider(Cache : in out T_Cache);

private

    type T_Cache is record
        Arbre : T_LA;
        taille : Integer;
        taille_max : Integer;
        Politique : Unbounded_String;
        Consultation : Integer;
        Defauts : Integer;
    end record;

end cache_la;
