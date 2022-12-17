with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with exceptions; use exceptions;
with Ada.Strings;               use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Exceptions;            use Ada.Exceptions;	-- pour Exception_Messagebounded_IO;
with adresseIP;                 use adresseIP;
with TableRoutage;              use TableRoutage;

-- Pour l'instant c'est un routeur simple jusqu'au 17 Décembre
procedure routeur_simple is

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
                if Argument_i = "-t" then
                  Table_File := To_Unbounded_String(Argument(i+1));
                else
                  Result_File := To_Unbounded_String(Argument(i+1));
                end if;
                i := i + 1;
            else
                Put_Line("Argument inconnu : " & Argument(i));
                Usage;
                raise CommandeInvalide;
            end if;
            i := i + 1;
        end loop;
    end;


    --traiter les commandes du fichier de paquetage

      Fichier_paquets: File_Type;
      Fichier_resultats:File_Type;
      Fichier_table: File_Type;
      Taille_cache : Integer;
      Afficher_Statistiques : Boolean;
      Politique : Unbounded_string;
      Nom_Fichier_resultats: Unbounded_string;
      Nom_Fichier_paquets: Unbounded_string;
      Nom_Fichier_Table: Unbounded_string;
      commande: unbounded_String;
      Numero_Ligne: Integer;
      Table: Liste_Table.T_LCA;
      adresse: T_AdresseIP;
      A_Fini: Boolean;


   begin

    Argument_Parsing(Argument_Count, Taille_Cache, Politique, Afficher_Statistiques, Nom_Fichier_Table, Nom_Fichier_paquets, Nom_Fichier_resultats);

    create(Fichier_resultats, Out_File, To_string(Nom_Fichier_resultats));
    Open(Fichier_paquets, In_File, To_string(Nom_Fichier_paquets));

    Open(Fichier_Table, In_File, To_String(Nom_Fichier_Table));
    Initialiser_Table(Table, Fichier_Table);
    close(Fichier_Table);

    A_Fini := False;

    while not End_Of_File(Fichier_paquets) and then not A_Fini loop

      begin
        Numero_ligne:=Integer(Line(Fichier_paquets));
        Adresse := Transforme_Ip(Fichier_paquets);
        Afficher_IP(Fichier_resultats, Adresse);
        Put(Fichier_resultats, Comparer_Table(Table, Adresse));
        New_Line(Fichier_resultats);
        Skip_Line(Fichier_paquets);

      exception
          when DATA_ERROR =>
	          commande:=Get_line(Fichier_paquets);
	          trim(commande,both);
            if commande="table" then
              Afficher_Table(Table,Numero_ligne);
            elsif commande="fin" then
              A_Fini:= true;
            else
              Put_Line("Commande inconnue à la ligne " & Integer'Image(Numero_ligne));
            end if;
        when E : others =>
          Put_Line("Erreur de syntaxe dans le fichier de paquets à la ligne" & Integer'Image(Numero_Ligne));
          Put_Line("Erreur : " & Exception_Message(E));
          raise ErreurFormat;

      end;
    end loop;
   close(Fichier_resultats);
   close(Fichier_paquets);
  put("Fin du programme");
end routeur_simple;
