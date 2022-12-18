with adresseIP;              use adresseIP;
with LCA;
with Ada.Text_IO;            use Ada.Text_IO;

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

        procedure Afficher_Liste (Liste : in T_LCA) is
            Aux : T_LCA := Liste;
        begin
            if Est_Vide(Liste) then
                Put_Line("Cache vide");
            else
                Put_Line("Cache :");
                Put_Line("Destination - Interface");
                while not Est_Vide(Aux) loop
                    AfficherAdresseIP(Aux.All.Cle);
                    Put("- ");
                    Put_Line(Aux.All.Donnee.DestInterface);
                    Aux := Aux.Suivant;
                end loop;
            end if;
        end Afficher_Liste;

        procedure Afficher_Cache_Liste is new Pour_Chaque(Afficher_Liste);

    begin
        Afficher_Cache_Liste(Cache.Liste);
    end;
end Cache_LL;