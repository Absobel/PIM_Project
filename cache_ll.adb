with Ada.Text_IO;              use Ada.Text_IO;
with exceptions;               use exceptions;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

package body Cache_LL is

    procedure Initialiser (Cache : in out T_Cache; Taille_Max : Integer) is
    begin
        Initialiser(Cache.Liste);
        Cache.Taille_Max := Taille_Max;
        Cache.Nb_Appels := 0;
        Cache.Nb_Defauts := 0;
    end;

    procedure Afficher_Statistiques (Cache : in T_Cache) is
    begin
        Put_Line("Nombre d'appels : " & Integer'Image(Cache.Nb_Appels));
        Put_Line("Nombre de défauts : " & Integer'Image(Cache.Nb_Defauts));
        Put_Line("Taux de défauts : " & Float'Image(Float(Cache.Nb_Defauts) / Float(Cache.Nb_Appels)));
    end;


    procedure Afficher (Cache : in T_Cache) is

        procedure Afficher_Liste (Cle: T_AdresseIP; Donnee : T_Cellule) is
        begin
            AfficherAdresseIP(Cle);
            Put(" - ");
            Put(Donnee.DestInterface);
            New_Line;
        end Afficher_Liste;

        procedure Afficher_Cache_Liste is new Pour_Chaque(Traiter => Afficher_Liste);

    begin
        if Est_Vide(Cache.Liste) then
            Put_Line("Cache vide");
        else
            Put_Line("Destination - Interface");
            Afficher_Cache_Liste(Cache.Liste);
        end if;
    end;


    procedure Lire (Cache : in out T_Cache; Destination : in T_AdresseIP; Politique : Unbounded_String; DestInterface : out Unbounded_String; A_Trouve : out Boolean) is
        Donnee : T_Cellule;
    begin
        for i in 1..Taille(Cache.Liste) loop
            if Cle_Presente(Cache.Liste, Destination) then
                Donnee :=  La_Donnee(Cache.Liste, Destination);
                DestInterface := Donnee.DestInterface;
                A_Trouve := true;
                
                if Politique = To_Unbounded_String("LRU") then
                    Supprimer(Cache.Liste, Destination);
                    Ajouter_Fin(Cache.Liste, Destination, Donnee);
                elsif Politique = To_Unbounded_String("FIFO") then 
                    null;
                elsif Politique = To_Unbounded_String("LFU") then
                    Donnee.Nb_Appels_Adresse := Donnee.Nb_Appels_Adresse + 1;
                    Ajouter_Fin(Cache.Liste, Destination, Donnee);
                else
                    raise PolitiqueInvalide;
                end if;
            else
                A_Trouve := false;
            end if;
        end loop;
    end;


    procedure Ajouter (Cache : in out T_Cache; Destination : in T_AdresseIP; DestInterface : in Unbounded_String; Politique : in Unbounded_String) is
        Cellule : constant T_Cellule := T_Cellule'(DestInterface, 1);
        Min_Cellule : T_Cellule;
        Min : Integer;
        Dest : T_AdresseIP;
        Min_Dest : T_AdresseIP;
    begin
        Ajouter_Fin(Cache.Liste, Destination, Cellule);
        if Taille(Cache.Liste) > Cache.Taille_Max then
            if Politique = To_Unbounded_String("LRU") or Politique = To_Unbounded_String("FIFO") then
                Supprimer_Tete(Cache.Liste);
            elsif Politique = To_Unbounded_String("LFU") then
                Element_Index(Cache.Liste, 1, Min_Dest, Min_Cellule);
                Min := Min_Cellule.Nb_Appels_Adresse;
                for i in 2..Taille(Cache.Liste) loop
                    Element_Index(Cache.Liste, i, Dest, Min_Cellule);
                    if Min_Cellule.Nb_Appels_Adresse < Min then
                        Min := Min_Cellule.Nb_Appels_Adresse;
                        Min_Dest := Dest;
                    end if;
                end loop;
                Supprimer(Cache.Liste, Min_Dest);
            else
                raise PolitiqueInvalide;
            end if;
        else
            null;
        end if;
    end;

    
    -- Tests

    function Taille (Cache : in T_Cache) return Integer is
    begin
        return Taille(Cache.Liste);
    end;


    function Est_Vide (Cache : in T_Cache) return Boolean is
    begin
        return Est_Vide(Cache.Liste);
    end;

end Cache_LL;