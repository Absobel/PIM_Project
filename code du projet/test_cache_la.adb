with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with cache_la; use cache_la;
with adresseip; use adresseip;

procedure test_cache_la is

    CacheLRU : T_Cache;
    CacheLFU : T_Cache;
    cacheFIFO : T_Cache;
    Adresse : T_AdresseIP;
    Masque : T_AdresseIP;
    Destination : Unbounded_String;

begin

    -- Initialisation des caches

    Initialiser (CacheLRU, 5, To_Unbounded_String("LRU"));
    Initialiser (CacheLFU, 5, To_Unbounded_String("LFU"));
    Initialiser (CacheFIFO, 5, To_Unbounded_String("FIFO"));

    -- Ajout d'une adresse IP dans chaque cache

    Adresse := 74295;    -- 127.127.127.127
    Masque := 148920;    -- 255.255.255.0
    Destination := To_Unbounded_String("eth127");

    Enregistrer (CacheLRU, Adresse, Masque, Destination);
    Enregistrer (CacheLFU, Adresse, Masque, Destination);
    Enregistrer (CacheFIFO, Adresse, Masque, Destination);

    -- Affichage des caches

    Put_Line("Attendu : 127.127.127.0 eth127");
    Put_Line("Cache LRU :");
    Afficher (CacheLRU, 1);
    Put_Line("Cache LFU :");
    Afficher(CacheLFU, 2);
    Put_Line("Cache FIFO :");
    Afficher(CacheFIFO, 3);


end test_cache_la;
