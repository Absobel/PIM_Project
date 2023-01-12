with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Exceptions;            use Ada.Exceptions;	-- pour Exception_Messagebounded_IO;
with cache_la; use cache_la;
with adresseip; use adresseip;

procedure test_cache_la is

    CacheLRU : T_Cache;
    CacheLFU : T_Cache;
    cacheFIFO : T_Cache;
    FichierTest : File_Type;
    Adresse : T_AdresseIP;
    Masque : T_AdresseIP;
    Destination : Unbounded_String;
    DestinationLue : Unbounded_String;
    NbConsultations : Integer := 0;
    NbDefauts : Integer := 0;
    TauxDefauts : Float := 0.0;
    A_trouve : Boolean;
    Fini : Boolean;

begin

    -- Initialisation des caches et du fichier test

    Open(FichierTest, In_File, "test_cache_la_table.txt");

    Initialiser (CacheLRU, 5, To_Unbounded_String("LRU"));
    Initialiser (CacheLFU, 5, To_Unbounded_String("LFU"));
    Initialiser (CacheFIFO, 5, To_Unbounded_String("FIFO"));

    -- Ajout de 5 adresse IP dans chaque cache

    Put_Line(Get_Line(FichierTest));

    for I in 1..5 loop

        begin

        Adresse := TransformerAdresseIp(FichierTest);    -- 127.127.127.127
        Masque := TransformerAdresseIp(FichierTest);    -- 255.255.255.0
        Destination := To_Unbounded_String(Get_line(FichierTest));

        Enregistrer (CacheLRU, Adresse, Masque, Destination);
        Enregistrer (CacheLFU, Adresse, Masque, Destination);
        Enregistrer (CacheFIFO, Adresse, Masque, Destination);

        -- Affichage des caches

        Put("Attendu : ");
        AfficherAdresseIP(Adresse and Masque);
        Put(to_String(Destination));
        New_Line;
        New_Line;
        Put_Line("Cache LRU :");
        Afficher (CacheLRU, 1);
        Put_Line("Cache LFU :");
        Afficher(CacheLFU, 1);
        Put_Line("Cache FIFO :");
        Afficher(CacheFIFO, 1);

        -- Affichage des statistiques

        Put_Line("Statistiques :");
        Put_Line("Cache LRU :");
        Statistiques(CacheLRU);
        Put_Line("Cache LFU :");
        Statistiques(CacheLFU);
        Put_Line("Cache FIFO :");
        Statistiques(CacheFIFO);
        New_line;
        Put_Line("--------------------------------------------------");
        New_Line;

    exception
        when E : others =>
            PUT_Line(Exception_Message(E));

    end;
    end loop;

    -- Lecture dans le cachez

    Put_Line(Get_Line(FichierTest));
    Fini := False;
    while not Fini loop

        begin

            Adresse := TransformerAdresseIp(FichierTest);
            Destination := To_Unbounded_String(Get_line(FichierTest));
            Put_Line("Attendu : " & to_String(Destination));

            Lire(CacheLRU, Adresse, DestinationLue, A_trouve);
            Put("LRU : ");
            pragma assert(A_Trouve);
            Put_Line(to_String(DestinationLue));

            Lire(CacheLFU, Adresse, DestinationLue, A_trouve);
            Put("LFU : ");
            pragma assert(A_Trouve);
            Put_Line(to_String(DestinationLue));

            Lire(CacheFIFO, Adresse, DestinationLue, A_trouve);
            Put("FIFO : ");
            pragma assert(A_Trouve);
            Put_Line(to_String(DestinationLue));

            New_Line;
            NbConsultations := NbConsultations + 1;

        exception
            when DATA_ERROR =>
                Fini := True;

            when E : others =>
                Put_Line("Erreur : " & Exception_Message(E));
                Fini := True;
        end;
    end loop;

    -- Affichage des statistiques

    Put_Line("Statistiques :");
    Put_Line("Attendues :");
    TauxDefauts := Float(NbDefauts / NbConsultations);
    Put_Line("nb Consultations : " & Integer'Image(NbConsultations) & " et taux Defauts : " & Float'Image(tauxDefauts));
    Put_Line("Cache LRU :");
    Statistiques(CacheLRU);
    Put_Line("Cache LFU :");
    Statistiques(CacheLFU);
    Put_Line("Cache FIFO :");
    Statistiques(CacheFIFO);
    New_line;
    Put_Line("--------------------------------------------------");
    New_Line;




    Vider(CacheLRU);
    Vider(CacheLFU);
    Vider(CacheFIFO);

end test_cache_la;
