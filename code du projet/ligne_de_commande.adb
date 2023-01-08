with Ada.Text_IO;               use Ada.Text_IO;
with exceptions;                use exceptions;

package body ligne_de_commande is


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



    -- Assigne chaque variable à un valeur selon la ligne de commande et les différentes valeurs par défaut.

    procedure Argument_Parsing(
        Argument : T_Tableau_Arguments;
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

        while i <= Argument_Count loop
            Argument_i := Argument(i);

            if Argument_i = "-c" then                   -- l'option -c permet de donner la taille maximale du cache.
                begin
                    Cache_Size := Integer'Value(To_String(Argument(i+1)));
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
                    Policy := Argument(i+1);
                else
                    Packet_File := Argument(i+1);
                end if;
                i := i + 1;

            elsif Argument_i = "-s" then                -- l'option -s permet d'afficher les statistiques du cache.
                Stat := True;

            elsif Argument_i = "-S" then                -- l'option -S permet de ne pas afficher les statistiques du cache.
                Stat := False;

            elsif Argument_i = "-t" or Argument_i = "-r" then   -- l'option -t donne le chemin vers le ficher de la table de routage
                -- l'option -r donne le chemin vers le fichier de résultats
                if i+1 > Argument_Count then
                    Put_Line("Il manque un argument à " & To_String(Argument(i)) & " à la position " & Integer'Image(i));
                    Usage;
                    raise CommandeInvalide;
                end if;
                if Argument_i = "-t" then
                    Table_File := Argument(i+1);
                else
                    Result_File := Argument(i+1);
                end if;
                i := i + 1;

            else                      -- Si l'argument n'est pas reconnu, on affiche l'usage et on soulève l'erreur CommandeInvalide.
                Put_Line("Argument inconnu : " & To_String(Argument(i)));
                Usage;
                raise CommandeInvalide;
            end if;

            i := i + 1;
        end loop;
    end;




end ligne_de_commande;
