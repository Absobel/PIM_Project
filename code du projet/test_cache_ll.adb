with Cache_LL;                 use Cache_LL;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure test_Cache_LL is
    Cache : T_Cache;
    DestInterface : Unbounded_String;
    A_Trouve: Boolean;
begin
    Initialiser(Cache, 2);
    pragma assert (Taille(Cache) = 0);
    Put_Line("Attendu après initialisation :");
    Put_Line("Cache vide");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LRU")); New_Line;
    Put_Line("Initialisation : OK");
    
    New_Line;
    Put_Line("### Test LRU (taille max : 2) et fonctions de base ###"); New_Line;

    Ajouter(Cache, 0, To_Unbounded_String("eth0"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    Put_Line("Attendu après ajour de 0.0.0.0 :");
    Put_Line("0.0.0.0 - eth0");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LRU")); New_Line;

    Ajouter(Cache, 1, To_Unbounded_String("eth1"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    -- 0.0.0.1 : eth1
    Put_Line("Attendu après ajour de 0.0.0.1 :");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("0.0.0.1 : eth1");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LRU")); New_Line;
    Put_Line("Ajouter : OK"); New_Line;

    Lire(Cache, 0, To_Unbounded_String("LRU"), DestInterface, A_Trouve);
    -- 0.0.0.1 : eth1
    -- 0.0.0.0 : eth0
    pragma assert(A_Trouve);
    Put_Line("Attendu après lecture de 0.0.0.0 : eth0");
    Put("Obtenu : "); Put_Line(DestInterface); New_Line;

    Lire(Cache, 3, To_Unbounded_String("LRU"), DestInterface, A_Trouve);
    pragma assert(not A_Trouve);

    Put_Line("Attendu après lecture :");
    Put_Line("0.0.0.1 : eth1");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LRU")); New_Line;
    Put_Line("Lire : OK"); New_Line;

    Ajouter(Cache, 2, To_Unbounded_String("eth2"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    -- 0.0.0.2 : eth2
    Put_Line("Attendu après ajout de 0.0.0.2 alors que cache plein :");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("0.0.0.2 : eth2");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LRU")); New_Line;

    Incrementer_Defauts(Cache);
    Put_Line("Attendu affichange statistiques (après ajouts de defauts de cache artificiellement) :");
    Put_Line("Nombre d'appels : 2");
    Put_Line("Nombre de défauts de cache : 1");
    Put_Line("Taux de défauts de cache : 0.5");
    Put_Line("Obtenu :");
    Afficher_Statistiques(Cache); New_Line;
    Put_Line("Statistiques : OK"); New_Line;

    Put_Line("Comportement LRU : OK"); New_Line;

    Put_Line("### Test FIFO (taille max : 3) ###"); New_Line;

    Initialiser(Cache, 3);
    Ajouter(Cache, 0, To_Unbounded_String("eth0"), To_Unbounded_String("FIFO"));
    Ajouter(Cache, 1, To_Unbounded_String("eth1"), To_Unbounded_String("FIFO"));
    Ajouter(Cache, 2, To_Unbounded_String("eth2"), To_Unbounded_String("FIFO"));
    -- 0.0.0.0 : eth0
    -- 0.0.0.1 : eth1
    -- 0.0.0.2 : eth2
    Put_Line("Cache :");
    Afficher(Cache, To_Unbounded_String("FIFO")); New_Line;

    Lire(Cache, 0, To_Unbounded_String("FIFO"), DestInterface, A_Trouve);
    -- Aucun changement
    pragma assert(A_Trouve);
    Put_Line("Attendu après lecture : aucun changement");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("FIFO")); New_Line;

    Ajouter(Cache, 3, To_Unbounded_String("eth3"), To_Unbounded_String("FIFO"));
    -- 0.0.0.1 : eth1
    -- 0.0.0.2 : eth2
    -- 0.0.0.3 : eth3
    Put_Line("Attendu après ajout de 0.0.0.3 alors que cache plein :");
    Put_Line("0.0.0.1 : eth1");
    Put_Line("0.0.0.2 : eth2");
    Put_Line("0.0.0.3 : eth3");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("FIFO")); New_Line;

    Put_Line("Comportement FIFO : OK"); New_Line;

    Put_Line("### Test LFU (taille max : 3) ###"); New_Line;

    Initialiser(Cache, 3);
    Ajouter(Cache, 0, To_Unbounded_String("eth0"), To_Unbounded_String("LFU"));
    Ajouter(Cache, 1, To_Unbounded_String("eth1"), To_Unbounded_String("LFU"));
    Ajouter(Cache, 2, To_Unbounded_String("eth2"), To_Unbounded_String("LFU"));
    -- 0.0.0.0 : eth0 - 0
    -- 0.0.0.1 : eth1 - 0
    -- 0.0.0.2 : eth2 - 0
    Put_Line("Cache :");
    Afficher(Cache, To_Unbounded_String("LFU")); New_Line;

    Lire(Cache, 0, To_Unbounded_String("LFU"), DestInterface, A_Trouve);
    Lire(Cache, 0, To_Unbounded_String("LFU"), DestInterface, A_Trouve);
    Lire(Cache, 2, To_Unbounded_String("LFU"), DestInterface, A_Trouve);
    -- 0.0.0.0 : eth0 - 2
    -- 0.0.0.1 : eth1 - 0
    -- 0.0.0.2 : eth2 - 1
    Put_Line("Attendu après deux lecture de 0.0.0.0, une lecture de 0.0.0.2 :");
    Put_Line("0.0.0.0 : eth0 - 2");
    Put_Line("0.0.0.1 : eth1 - 0");
    Put_Line("0.0.0.2 : eth2 - 1");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LFU")); New_Line;

    Ajouter(Cache, 3, To_Unbounded_String("eth3"), To_Unbounded_String("LFU"));
    -- 0.0.0.0 : eth0 - 2
    -- 0.0.0.2 : eth2 - 0
    -- 0.0.0.3 : eth3 - 0

    Put_Line("Attendu après ajout de 0.0.0.3 alors que cache plein :");
    Put_Line("0.0.0.0 : eth0 - 2");
    Put_Line("0.0.0.2 : eth2 - 1");
    Put_Line("0.0.0.3 : eth3 - 0");
    Put_Line("Obtenu :");
    Afficher(Cache, To_Unbounded_String("LFU")); New_Line;

    Put_Line("Comportement LFU : OK"); New_Line;

    Put_Line("############# Fin des tests ! #############");
end test_Cache_LL;