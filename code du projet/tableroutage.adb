with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

package body TableRoutage is


    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer) is

        procedure Afficher_Ligne (Cle : T_AdresseIP  ; Donnee : T_Donnee) is
        begin
            AfficherAdresseIP(Cle);
            AfficherAdresseIP(Donnee.Masque);
            Put(To_String(Donnee.Destination));
            New_Line;
        end Afficher_Ligne;

        procedure Afficher_Table_Ligne is new Pour_Chaque(Traiter => Afficher_Ligne);

    begin
        Put("table : (ligne ");
        put(Numero_Ligne, 1);
        Put(")");
        New_Line;
        Afficher_Table_Ligne(Table);
    end Afficher_Table;


    procedure Comparer_table(Table : in T_LCA ; Adresse : in T_AdresseIP ; Destination : out Unbounded_String ; Masque : out T_AdresseIP) is
        Adresse_Masquee : T_AdresseIP;

        procedure Comparer_Ligne(Cle : T_AdresseIP ; Donnee : T_Donnee) is
        begin
            Adresse_Masquee := Adresse and Donnee.Masque;
            if Adresse_Masquee = Cle and Donnee.Masque >= Masque then
                Masque := Donnee.Masque;
                Destination := Donnee.Destination;
            end if;
        end Comparer_Ligne;

        procedure Parcourir_Table is new Pour_Chaque(Traiter => Comparer_Ligne);

    begin

        Masque := 0;
        Destination := To_Unbounded_String("Impossible de trouver dans la table");
        Parcourir_Table(Table);

    end Comparer_table;


    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in out File_Type ) is
        Adresse : T_AdresseIP;
        Masque : T_AdresseIP;
        Destination : Unbounded_String;
        Ligne_Table : T_Donnee;
    begin
        Initialiser(Table);
        loop
            Adresse := TransformerAdresseIP(Fichier_Table);
            Masque := TransformerAdresseIP(Fichier_Table);
            Destination := To_Unbounded_String(Get_Line(Fichier_Table));
            Trim(Destination, Both);
            Ligne_Table := (Masque, Destination);
            Ajouter_Fin(Table, Adresse, Ligne_Table);
            exit when End_Of_File(Fichier_Table);
        end loop;
    exception
        when End_Error =>
            Put ("Blancs en surplus à la fin du fichier.");
            null;
    end Initialiser_Table;

    procedure Vider_Table (Table : in out T_LCA) is
    begin
        Vider(Table);
    end Vider_Table;

end TableRoutage;
