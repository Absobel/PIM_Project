with Cache_LL;                 use Cache_LL;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with adresseIP;                use adresseIP;

procedure test_Cache_LL is
    Cache : T_Cache;
    DestInterface : Unbounded_String;
    A_Trouve: Boolean;
begin
    Initialiser(Cache, 2);
    pragma assert (Taille(Cache) = 0);
    Put_Line("Attendu :");
    Put_Line("Cache vide");
    Put_Line("Obtenu :");
    Afficher(Cache); New_Line;
    Put_Line("Initialisation : OK");
    
    New_Line;
    Put_Line("Test LRU : "); New_Line;

    Ajouter(Cache, 0, To_Unbounded_String("eth0"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    Put_Line("Attendu :");
    Put_Line("0.0.0.0 - eth0");
    Put_Line("Obtenu :");
    Afficher(Cache); New_Line;

    Ajouter(Cache, 1, To_Unbounded_String("eth1"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    -- 0.0.0.1 : eth1
    Put_Line("Attendu :");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("0.0.0.1 : eth1");
    Put_Line("Obtenu :");
    Afficher(Cache); New_Line;
    Put_Line("Ajouter : OK"); New_Line;

    Lire(Cache, 0, To_Unbounded_String("LRU"), DestInterface, A_Trouve);
    -- 0.0.0.1 : eth1
    -- 0.0.0.0 : eth0
    pragma assert(A_Trouve);
    Put_Line("Attendu : eth0");
    Put("Obtenu : "); Put_Line(DestInterface);
    New_Line;
    Put_Line("Attendu après lecture :");
    Put_Line("0.0.0.1 : eth1");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("Obtenu :");
    Afficher(Cache); New_Line;
    Put_Line("Lire : OK"); New_Line;

    Ajouter(Cache, 2, To_Unbounded_String("eth2"), To_Unbounded_String("LRU"));
    -- 0.0.0.0 : eth0
    -- 0.0.0.2 : eth2
    Put_Line("Attendu :");
    Put_Line("0.0.0.0 : eth0");
    Put_Line("0.0.0.2 : eth2");
    Put_Line("Obtenu :");
    Afficher(Cache); New_Line;

    Put_Line("LRU : OK"); New_Line;

    Put_Line("Test FIFO : "); New_Line;

    Put_Line("Fin des tests !");
end test_Cache_LL;