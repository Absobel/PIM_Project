with adresseIP;                 use adresseIP;
with LCA;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Strings;               use Ada.Strings;

package TableRoutage is

    Type T_Donnee is record
        Masque : T_AdresseIP;
        Destination : Unbounded_String;
    end record;

    package Liste_Table is new LCA (T_AdresseIP, T_Donnee);
    use Liste_Table;

    -- But : Afficher la table de routage dans le terminal avec le numéro de la ligne d'appel de la commande
    --
    -- Paramètres :
    -- Table : Table de routage à afficher.
    -- Numero_Ligne : Numéro de la ligne d'appel de la commande dans le fichier de paquetage.
    --
    -- Pre / Post : Aucune.
    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer);

    -- Compare une adresse IP à la table et renvoie l'interface associée (masque le plus grand possible)
    --
    -- Paramètres :
    -- Table : Table de routage.
    -- Adresse : Adresse IP à comparer.
    --
    -- Pre / Post : Aucune.
    function Comparer_table(Table : T_LCA ; Adresse : T_AdresseIP) return Unbounded_String;

    -- Initialise la table de routage avec les valeur dans le fichier Fichier_Table.
    --
    -- Paramètres :
    -- Table : Table de routage à initialiser.
    -- Fichier_Table : Fichier contenant les valeurs à initialiser.
    --
    -- Pre / Post : Aucune.
    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in out File_Type);

end TableRoutage;
