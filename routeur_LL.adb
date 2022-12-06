with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;

-- Pour l'instant c'est un routeur simple jusqu'au 17 Décembre
procedure Routeur_LL is

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
        Policy :         out String; 
        Stat :           out Boolean; 
        Table_File :     out String; 
        Packet_File :    out String; 
        Result_File :    out String) is

        -- On initialise les valeurs par défaut
        Cache_Size : Integer := 10;
        Policy : String := "FIFO";
        Stat : Boolean := True;
        Table_File : String := "table.txt";
        Packet_File : String := "paquets.txt";
        Result_File : String := "resultats.txt";

        i : Integer := 1;
    begin
        if Argument_Count = 0 then
            Usage;
            exit;
        end if;
        while i <= Argument_Count loop
            case Argument(i) is
                when "-c" =>
                    begin
                        Cache_Size := Integer'Valeue(Argument(i+1));
                    exception
                        when others =>
                            Put_Line("-c est suivi d'un entier. Erreur à la position " & Integer'Image(i));
                            Usage;
                            exit;
                    end;
                    i := i + 1;
                when "-p" =>                 -- l'option -p peut être à la fois pour la politique et à la fois pour le nom de fichier de paquets
                    if i+1 > Argument_Count then
                        Put_Line("Il manque un argument à -p à la position " & Integer'Image(i));
                        Usage;
                        exit;
                    end if;
                    if Argument(i+1) = "FIFO" or Argument(i+1) = "LRU" or Argument(i+1) = "LFU" then
                        Policy := Argument(i+1);
                        i := i + 1;
                    else
                        Packet_File := Argument(i+1);
                    end if;
                    i := i + 1;
                when "-s" =>
                    Stat := True;
                when "-S" =>
                    Stat := False;
                when "-t"|"-r" =>
                    if i+1 > Argument_Count then
                        Put_Line("Il manque un argument à " & Argument(i) & " à la position " & Integer'Image(i));
                        Usage;
                        exit;
                    end if;
                    Table_File := Argument(i+1);
                    i := i + 1;
                when others =>
                    Put_Line("Argument inconnu : " & Argument(i));
                    Usage;
                    exit;
            end case;
            i := i + 1;
        end loop;
    end;



    Cache_Size : Integer;
    Policy : String;
    Stat : Boolean;
    Table_File : String;
    Packet_File : String;
    Result_File : String;

begin
    Argument_Parsing(Argument_Count, Cache_Size, Policy, Stat, Table_File, Packet_File, Result_File);
end Routeur_LL;