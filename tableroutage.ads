with adresseIP;                 use adresseIP;
with LCA;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;


package TableRoutage is

    Type T_Donnee is record
      Masque : T_AdresseIP;
      Destination : Unbounded_String;
    end record;

    package Liste_Table is new LCA (T_AdresseIP, T_Donnee);
    use Liste_Table;
    
    procedure Afficher_IP (Adresse : T_AdresseIP);
    procedure Afficher_Ligne (Cle : T_AdresseIP  ; Donnee : T_Donnee);
    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer);
    function Transforme_Ip(Fichier_Table : in out File_Type) return T_AdresseIP;
    function Comparer_table(Table : T_LCA ; Adresse : T_AdresseIP) return Unbounded_String;
    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in File_Type);

end TableRoutage;