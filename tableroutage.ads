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

    -- Affiche la table de routage dans le terminal ainsi que le numéro de la ligne où la command est donnée.
    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer);

    -- Compare l'adresse IP aux données dans la table de routage (prend le masque le plus grand).
    function Comparer_table(Table : T_LCA ; Adresse : T_AdresseIP) return Unbounded_String;

    -- Initialise la table de routage grâce au fichier Fichier_Table.
    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in out File_Type);

end TableRoutage;
