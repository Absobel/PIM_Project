with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

package body TableRoutage is

    procedure Afficher_IP (Adresse : T_AdresseIP) is
    begin
      for i in 0..2 loop
        Put(Natural (Adresse/256**(3-i) mod 256), 1);
        Put(".");
      end loop;
      put(Natural (Adresse mod 256), 1);
      Put(" ");
    end Afficher_IP;

    procedure Afficher_IP (Fichier : File_Type ; Adresse : T_AdresseIP) is
    begin
      for i in 0..2 loop
        Put(Fichier, Natural (Adresse/256**(3-i) mod 256), 1);
        Put(Fichier, ".");
      end loop;
      put(Fichier, Natural (Adresse mod 256), 1);
      Put(Fichier, " ");
    end Afficher_IP;


    procedure Afficher_Ligne (Cle : T_AdresseIP  ; Donnee : T_Donnee) is
    begin
      Afficher_IP(Cle);
      Afficher_IP(Donnee.Masque);
      Put(To_String(Donnee.Destination));
      New_Line;
    end Afficher_Ligne;

    procedure Afficher_Table (Table : T_LCA ; Numero_Ligne : Integer) is
      procedure Afficher_Table_Ligne is new Pour_Chaque(Traiter => Afficher_Ligne);
    begin
      Put("table : (ligne ");
      put(Numero_Ligne, 1);
      Put(")");
      New_Line;
      Afficher_Table_Ligne(Table);
    end Afficher_Table;

    function Transforme_Ip(Fichier_Table : in out File_Type) return T_AdresseIP is
      Octet : Integer;
      Separateur : Character;
      Adresse : T_AdresseIP := 0;
    begin
      for i in 0..3 loop
        Get(Fichier_Table, Octet);
        Adresse :=  T_AdresseIP(Octet) + Adresse*256;
        if i < 3 then
          Get(Fichier_Table, Separateur);
          if Separateur /= '.' then
            Put_Line("Erreur de syntaxe dans l'adresse IP");
          end if;
        end if;
      end loop;
      return Adresse;
    end Transforme_Ip;

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


    procedure Initialiser_Table(Table : in out T_LCA ; Fichier_Table : in out File_Type ) is
      Adresse : T_AdresseIP;
      Masque : T_AdresseIP;
      Destination : Unbounded_String;
      Ligne_Table : T_Donnee;
    begin
      Initialiser(Table);
      loop
        Adresse := Transforme_Ip(Fichier_Table);
        Masque := Transforme_Ip(Fichier_Table);
        Destination := To_Unbounded_String(Get_Line(Fichier_Table));
        Trim(Destination, Both);
        Ligne_Table := (Masque, Destination);
        Enregistrer(Table, Adresse, Ligne_Table);
      exit when End_Of_File(Fichier_Table);
      end loop;
    exception
      when End_Error =>
        Put ("Blancs en surplus à la fin du fichier.");
        null;
    end Initialiser_Table;

end TableRoutage;