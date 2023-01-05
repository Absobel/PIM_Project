with Ada.Text_IO; Use Ada.Text_IO;

package body cache_la is

    procedure Initialiser(Cache : in out T_Cache ; Taille_Max : in Integer) is
    begin
        Initialiser(Cache.Arbre);
        Cache.taille := 0;
        Cache.Taille_Max := Taille_Max;
        Cache.Consultation := 0;
        Cache.Defauts := 0;
    end Initialiser;

    procedure Statistiques(Cache : in T_Cache) is
        Taux_Defauts : Float;
    begin
        Put_Line("Taille du cache : " & Integer'Image(Cache.Consultation));
        Put_Line("Nombre de demandes de routes : " & Integer'Image(Cache.Consultation));
        Taux_Defauts := Float(Cache.Defauts) / Float(Cache.Consultation);
        Put_Line("Taux de défauts de cache : " & Float'Image(Taux_Defauts));
    end Statistiques;

    procedure Lire(Cache : in out T_Cache ; Adresse : in T_AdresseIP ; Destination : out Unbounded_String ; A_Trouve : out Boolean) is
    begin
        Traiter(Cache.Consultation, Adresse, Destination, A_Trouve, Cache.Arbre);
        Cache.Consultation := Cache.Consultation + 1;
        if not A_Trouve then
            Cache.Defauts := Cache.Defauts + 1;
        else
            if Cache.Taille = Cache.Taille_Max then
                Supprimer(Cache.Consultation, Cache.Arbre);
            else
                Cache.Taille := Cache.Taille + 1;
            end if;
            Enregistrer(Cache.Consultation, Adresse, Destination, Cache.Arbre);
        end if;
    end Lire;

    procedure Afficher(Cache : in T_Cache) is
    begin
        Afficher(Cache.Arbre);
    end Afficher;

end cache_la;
