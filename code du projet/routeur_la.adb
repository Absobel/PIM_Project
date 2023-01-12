with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings;               use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Exceptions;            use Ada.Exceptions;	-- pour Exception_Messagebounded_IO;
with adresseIP;                 use adresseIP;
with TableRoutage;              use TableRoutage;
with exceptions;               use exceptions;
with cache_la;                  use cache_la;
with ligne_de_commande;



procedure routeur_la is


    --traiter les commandes du fichier de paquetage

    package ligne_de_commande_P is new ligne_de_commande (Argument_Count);
    use ligne_de_commande_P;

    Tableau_Arguments : T_Tableau_Arguments;
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
    Masque : T_AdresseIP;
    A_Fini: Boolean;
    A_Trouve: Boolean;
    Destination : Unbounded_string;
    cache : T_Cache;


begin

    -- On initialise les différentes constantes, et on ouvre les fichiers de paquets, de résultats et de table de routage.

    for I in 1..Argument_Count loop
        Tableau_Arguments(I) := To_Unbounded_String(Argument(I));
    end loop;
    Argument_Parsing(Tableau_Arguments, Argument_Count, Taille_Cache, Politique, Afficher_Statistiques, Nom_Fichier_Table, Nom_Fichier_paquets, Nom_Fichier_resultats);

    create(Fichier_resultats, Out_File, To_string(Nom_Fichier_resultats));
    Open(Fichier_paquets, In_File, To_string(Nom_Fichier_paquets));

    Open(Fichier_Table, In_File, To_String(Nom_Fichier_Table));
    Initialiser_Table(Table, Fichier_Table);
    close(Fichier_Table);

    -- On initialise le cache

    Initialiser(Cache, Taille_Cache, Politique);


    A_Fini := False;

    while not End_Of_File(Fichier_paquets) and then not A_Fini loop

        begin

            -- On lit la ligne et on la traite comme une adresse IP (comparaison à la table, enregistrement dans le fichier résultats).


            Numero_ligne:=Integer(Line(Fichier_paquets));
            Adresse := TransformerAdresseIP(Fichier_paquets);
            EnregistrerAdresse(Fichier_resultats, Adresse);
            Lire(Cache, Adresse, Destination, A_Trouve);
            if not A_trouve then
                Comparer_Table(Table, Adresse, Destination, Masque);
                Enregistrer(Cache, Adresse, Masque, Destination);
            end if;
            Put(Fichier_resultats, Destination);
            New_Line(Fichier_resultats);
            Skip_Line(Fichier_paquets);

        exception
                -- Si on rencontre une erreur de type Data_error, c'est qu'il s'agit d'une commande.
            when DATA_ERROR =>
                commande:=Get_line(Fichier_paquets);
                trim(commande,both);

                if commande="table" then    -- la commande "table" permet d'afficher la table de routage.
                    Afficher_Table(Table,Numero_ligne);

                elsif commande="fin" then   -- la commande "fin" permet de terminer le programme.
                    A_Fini := True;

                elsif commande="cache" then -- la commande "cache" permet d'afficher le contenu du cache.
                    Afficher(Cache, Numero_Ligne);

                else    -- Si la commande n'est pas reconnue, on affiche un message et on continue.
                    Put_Line("Commande inconnue à la ligne " & Integer'Image(Numero_ligne));
                end if;

                -- Si l'errur est inconnue, on affiche le message d'erreur et on arrête le programme.
            when E : others =>
                Put_Line("Erreur de syntaxe dans le fichier de paquets à la ligne" & Integer'Image(Numero_Ligne));
                Put_Line("Erreur : " & Exception_Message(E));
                A_Fini := True;

        end;
    end loop;

    if Afficher_Statistiques then
        Statistiques(Cache);
    end if;

    Vider_Table(Table);
    Vider(Cache);
    close(Fichier_resultats);
    close(Fichier_paquets);
    put("Fin du programme");

exception

    when CommandeInvalide =>

        -- L'erreur a lieu avant d'initialiser quoi que ce soit (pas besoin de vider le cache ou la table).

        Put_Line("Erreur dans la ligne de commande.");
        Usage;
        raise;

    when E : others =>

        -- Si jamais ça plante, je ferme jamais les fichiers, sinon voici ce qui arrive :
        --
        -- Imaginons que "paquets.txt" n'existe pas. dans ce cas, si on fermais à la fin des exceptions,
        -- le programme plantera encore à la tentative de fermeture des paquets, car il l'a jamais ouvert
        -- (il n'existe pas). Dans ce cas, les variables ne sont JAMAIS détruites, et tu te tapes
        -- 7k bytes de memory leak. C'est pas beau (cette phrase a été rajouté par Copilot).
        --
        -- Si t'as une solution, ajoute la.

        Put_Line("Erreur (placeholder)");
        Put_Line("Erreur : " & Exception_Message(E));
        Vider_Table(Table);
        Vider(Cache);
        Put_Line("Fin du programme");

end routeur_la;
