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

    -- Initialise la table de routage avec les valeur dans le fichier Fichier_Table.
    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in out File_Type);

    -- Afficher la table de routage dans le terminal avec le numéro de la ligne d'appel de la commande.
    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer);

    -- Compare une adresse IP à la table et renvoie l'interface associée (masque le plus grand possible)
    procedure Comparer_table(Table : in T_LCA ; Adresse : in T_AdresseIP ; Destination : out Unbounded_String ; Masque : out T_AdresseIP);

    -- Vide la table de routage et la détruit.
    procedure Vider_table(Table : in out T_LCA);

end TableRoutage;
