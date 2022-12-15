with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with exceptions; use exceptions;
with liste_chainee;
with Ada.Strings;               use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

-- Pour l'instant c'est un routeur simple jusqu'au 17 Décembre
procedure routeur_simple is

    Type T_Adresse_IP is mod 2**32;
    Type T_Ligne_table is record
      Adresse : T_Adresse_IP;
      Masque : T_Adresse_IP;
      Destination : Unbounded_String;
    end record;

    Package Liste_Table is new liste_chainee(T_Ligne_table);
    use Liste_Table;

    procedure Usage is
    begin
        Put_Line("Usage: ./routeur_simple <options>");
        Put_Line("Options:");
        Put_Line("  -c <taille> : Définir la taille du cache. La valeur 0 indique qu'il n y a pas de cache. La valeur par défaut est 10.");
        Put_Line("  -p FIFO|LRU|LFU : Définir la politique utilisée par le cache. La valeur par défaut est FIFO.");
        Put_Line("     <fichier> : Définir le nom du fichier contenant les paquets à router. Par défaut, on utilise le fichier paquets.txt.");
        Put_Line("  -s : Afficher les statistiques (nombre de défauts de cache, nombre de demandes de route, taux de défaut de cache). C'est l'option activée par défaut.");
        Put_Line("  -S : Ne pas afficher les statistiques.");
        Put_Line("  -t <fichier> : Définir le nom du fichier contenant les routes de la table de routage. Par défaut, on utilise le fichier table.txt.");
        Put_Line("  -r <fichier> : Définir le nom du fichier contenant les résultats (adresse IP destination du paquet et inter-face utilisée). Par défaut, on utilise le fichier resultats.txt.");
    end;

    --traiter les commandes du fichier de paquetage 
    procedure paquetage is
      Fichier_paquets: File_Type;
      Fichier_resultats:File_Type;
      Fichier_table: File_Type;
      Nom_Fichier_resultats: Unbounded_string;
      Nom_Fichier_paquets: Unbounded_string;
      Nom_Fichier_Table: Unbounded_string;
      commande: unbounded_String;
      Numero_Ligne: Integer;
      Table: T_Liste_chainee;
      adresse: T_Adresse_Ip;
      A_Fini: Boolean;
   begin
    create(Fichier_resultats,Out_File,To_string(Nom_ Fichier_resultats));
    Open(Fichier_paquets,In_File,To_string(Nom_ Fichier_paquets));
    Open(Fichier_resultats,Out_File,To_string(Nom_Fichier_resultats));
    Open(Fichier_Table,In_File,To_ String(Nom_Fichier_Table)
    initialiser(Table, Fichier_Table); 
    close(Fichier_Table);
    while not End_Of_File(Entree) and then A_Fini loop
         Numero_ligne:=Integer(Line(Fichier_paquets));
         Transform_Ip(Fichier_Table);
         exception
         when   ==> 
	     commande:=Get_line(Fichier_paquets);
	     trim(texte,both);
         if commande="table" then
            Afficher_Table(Table,Numero_ligne);
         else if commnade="fin"
           A_Fini:= true;   
         end if;
    end loop;    
   close(Fichier_resultats;)
   close(Fichier_paquets);
   end paquetage;     
		    	    






    procedure Argument_Parsing(
        Argument_Count : in Integer;
        Cache_Size :     out Integer;
        Policy :         out Unbounded_String;
        Stat :           out Boolean;
        Table_File :     out Unbounded_String;
        Packet_File :    out Unbounded_String;
        Result_File :    out Unbounded_String) is

        i : Integer := 1;
        Argument_i : Unbounded_String;
    begin
        -- On initialise les valeurs par défaut
        Cache_Size := 10;
        Policy := To_Unbounded_String("FIFO");
        Stat := True;
        Table_File := To_Unbounded_String("table.txt");
        Packet_File := To_Unbounded_String("paquets.txt");
        Result_File := To_Unbounded_String("resultats.txt");

        if Argument_Count = 0 then
            Usage;
            raise CommandeInvalide;    -- On quitte le programme
        end if;
        while i <= Argument_Count loop
            Argument_i := To_Unbounded_String(Argument(i));
            if Argument_i = "-c" then
                begin
                    Cache_Size := Integer'Value(Argument(i+1));
                exception
                    when others =>
                        Put_Line("-c est suivi d'un entier. Erreur à la position " & Integer'Image(i));
                        Usage;
                        raise CommandeInvalide;
                end;
                i := i + 1;
            elsif Argument_i = "-p" then                 -- l'option -p peut être à la fois pour la politique et à la fois pour le nom de fichier de paquets
                if i+1 > Argument_Count then
                    Put_Line("Il manque un argument à -p à la position " & Integer'Image(i));
                    Usage;
                    raise CommandeInvalide;
                end if;
                if Argument(i+1) = "FIFO" or Argument(i+1) = "LRU" or Argument(i+1) = "LFU" then
                    Policy := To_Unbounded_String(Argument(i+1));
                else
                    Packet_File := To_Unbounded_String(Argument(i+1));
                end if;
                i := i + 1;
            elsif Argument_i = "-s" then
                Stat := True;
            elsif Argument_i = "-S" then
                Stat := False;
            elsif Argument_i = "-t" or Argument_i = "-r" then
                if i+1 > Argument_Count then
                    Put_Line("Il manque un argument à " & Argument(i) & " à la position " & Integer'Image(i));
                    Usage;
                    raise CommandeInvalide;
                end if;
                Table_File := To_Unbounded_String(Argument(i+1));
                i := i + 1;
            else
                Put_Line("Argument inconnu : " & Argument(i));
                Usage;
                raise CommandeInvalide;
            end if;
            i := i + 1;
        end loop;
    end;


    function Comparer_table(Table : T_Liste_Chainee ; Adresse : T_Adresse_IP) return Unbounded_String is
      Adresse_Masquee : T_Adresse_IP;
      Masque_Max : T_Adresse_IP := 0;
      Interface_Sortie : Unbounded_String;

      procedure Comparer_Ligne(Ligne : T_Ligne_table) is
      begin
        Adresse_Masquee := Adresse and Ligne.Masque;
        if Adresse_Masquee = Ligne.Adresse and Ligne.Masque > Masque_Max then
          Masque_Max := Ligne.Masque;
          Interface_Sortie := Ligne.Destination;
        end if;
      end Comparer_Ligne;

      procedure Parcourir_Table is new Pour_Chaque(Traiter => Comparer_Ligne);

    begin
      Parcourir_Table(Table);
      return Interface_Sortie;
    end Comparer_table;

    procedure Afficher_IP (Adresse : T_Adresse_IP) is
    begin
      for i in 0..2 loop
        Put(Natural (Adresse/256**(3-i) mod 256));
        Put(".");
      end loop;
      put(Natural (Adresse mod 256));
      Put(" ");
    end Afficher_IP;


    procedure Afficher_Ligne (Ligne : T_Ligne_table) is
    begin
      Afficher_IP(Ligne.Adresse);
      Afficher_IP(Ligne.Masque);
      Put(To_String(Ligne.Destination));
      New_Line;
    end Affinitialiser(Table, Fichier_Table);icher_Ligne;

    procedure Afficher_Table (Table : T_Liste_Chainee ; Numero_Ligne : Integer) is
      procedure Afficher_Table_Ligne is new Pour_Chaque(Traiter => Afficher_Ligne);
    begin
      Put("table : (ligne ");
      put(Numero_Ligne);
      Put(")");
      New_Line;
      Afficher_Table_Ligne(Table);
    end Afficher_Table;

    function Transforme_Ip(Fichier_Table : in File_Type) return T_Adresse_IP is
      Octet : Integer;
      Separateur : Character;
      Adresse : T_Adresse_IP := 0;
    begin
      for i in 0..3 loop
        Get(Octet);
        Adresse :=  T_Adresse_IP(Octet) + Adresse*256;
        if i < 3 then
          Get(Fichier_Table, Separateur);
          if Separateur /= '.' then
            Put_Line("Erreur de syntaxe dans l'adresse IP");
            raise ErreurFormat;
          end if;
        end if;
      end loop;
      return Adresse;
    end Transforme_Ip;

    procedure Initialiser_Table(Table : in out T_Liste_Chainee ; Fichier_Table : in File_Type ) is
      Adresse : T_Adresse_IP;
      Masque : T_Adresse_IP;
      Destination : Unbounded_String;
      Ligne_Table : T_Ligne_table;
    begin
      Initialiser(Table);
      loop
        Adresse := Transforme_Ip(Fichier_Table);
        Masque := Transforme_Ip(Fichier_Table);
        Destination := Get_Line(Fichier_Table);
        Trim(Destination, Both);
        Ligne_Table := (Adresse, Masque, Destination);
        Ajouter(Table, Ligne_Table);
      exit when End_Of_File(Fichier_Table);
      end loop;
    end Initialiser_Table;


    Cache_Size : Integer := 0;
    Policy : Unbounded_String := To_Unbounded_String("");
    Stat : Boolean;
    Nom_Fichier_Table : Unbounded_String := To_Unbounded_String("");
    Nom_Fichier_Paquets : Unbounded_String := To_Unbounded_String("");
    Nom_Fichier_Resultats : Unbounded_String := To_Unbounded_String("");
    Table : T_Liste_Chainee;

begin
    Argument_Parsing(Argument_Count, Cache_Size, Policy, Stat, Nom_Fichier_Table, Nom_Fichier_Paquets, Nom_Fichier_Resultats);

    -- DEBUG
    Put_Line("Cache_Size : " & Integer'Image(Cache_Size));
    Put_Line("Policy : " & To_String(Policy));
    Put_Line("Stat : " & Boolean'Image(Stat));
<<<<<<< HEAD
    Put_Line("Table_File : " & To_String(Table_File));
    Put_Line("Packet_File : " & To_String(Packet_File));
    Put_Line("Result_File : " & To_String(Result_File));
=======
    Put_Line("Table_File : " & To_String(Nom_Fichier_Table));
    Put_Line("Packet_File : " & To_String(Nom_Fichier_Paquets));
    Put_Line("Result_File : " & To_String(Nom_Fichier_Resultats));
>>>>>>> f6787b772b4054e8e891e43b82ab17c76068eb51
end routeur_simple;
