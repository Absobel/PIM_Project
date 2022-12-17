with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

package body TableRoutage is
    -- But : Afficher la table de routage dans le tarminal avec le numéro de la ligne d'appel de la commande
    --
    -- Paramètres :
    -- Table : Table de routage à afficher.
    -- Numero_Ligne : Numéro de la ligne d'appel de la commande dans le fichier de paquetage.
    --
    -- Pre / Post : Aucune.

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


    -- Compare une adresse IP à la table et renvoie l'interface associée (masque le plus grand possible)
    --
    -- Paramètres :
    -- Table : Table de routage.
    -- Adresse : Adresse IP à comparer.
    --
    -- Pre / Post : Aucune.

    function Comparer_table(Table : T_LCA ; Adresse : T_AdresseIP) return Unbounded_String is
        Adresse_Masquee : T_AdresseIP;
        Masque_Max : T_AdresseIP := 0;
        Interface_Sortie : Unbounded_String := To_Unbounded_String("Erreur routage");

        procedure Comparer_Ligne(Cle : T_AdresseIP ; Donnee : T_Donnee) is
        begin
            Adresse_Masquee := Adresse and Donnee.Masque;
            if Adresse_Masquee = Cle and Donnee.Masque >= Masque_Max then
                Masque_Max := Donnee.Masque;
                Interface_Sortie := Donnee.Destination;
            end if;
        end Comparer_Ligne;

        procedure Parcourir_Table is new Pour_Chaque(Traiter => Comparer_Ligne);

    begin

        Parcourir_Table(Table);
        return Interface_Sortie;

    end Comparer_table;


    -- Initialise la table de routage avec les valeur dans le fichier Fichier_Table.
    --
    -- Paramètres :
    -- Table : Table de routage à initialiser.
    -- Fichier_Table : Fichier contenant les valeurs à initialiser.
    --
    -- Pre / Post : Aucune.

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

end TableRoutage;
