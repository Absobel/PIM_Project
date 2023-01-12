with Ada.Text_IO; Use Ada.Text_IO;
with exceptions; use exceptions;

package body cache_la is

    procedure Initialiser(Cache : in out T_Cache ; Taille_Max : in Integer ; Politique : in Unbounded_String) is
    begin
        Initialiser(Cache.Arbre);
        Cache.taille := 0;
        Cache.Taille_Max := Taille_Max;
        Cache.Politique := Politique;
        Cache.Consultation := 0;
        Cache.Defauts := 0;
    end Initialiser;

    procedure Statistiques(Cache : in T_Cache) is
        Taux_Defauts : Float;
    begin
        Put_Line("Taille du cache : " & Integer'Image(Cache.Taille));
        Put_Line("Nombre de demandes de routes : " & Integer'Image(Cache.Consultation));
        if Cache.Defauts = 0 then
            Taux_Defauts := 0.0;
        else
            Taux_Defauts := Float(Cache.Defauts) / Float(Cache.Consultation);
        end if;
        Put_Line("Taux de défauts de cache : " & Float'Image(Taux_Defauts));
    end Statistiques;

    procedure Lire(Cache : in out T_Cache ; Adresse : in T_AdresseIP ; Destination : out Unbounded_String ; A_Trouve : out Boolean) is
        NoeudLu : T_Noeud;
        NoeudAEnregistrer : T_Noeud;
    begin
        Lire(Adresse, NoeudLu, A_Trouve, Cache.Arbre);
        Destination := NoeudLu.Destination;
        Cache.Consultation := Cache.Consultation + 1;
        if not A_Trouve then
            Cache.Defauts := Cache.Defauts + 1;
        else
            if To_String(Cache.Politique) = "FIFO" then
                NoeudAEnregistrer := NoeudLu;
            else
                NoeudAEnregistrer := T_Noeud'(NoeudLu.Destination, Cache.Consultation, NoeudLu.NombreConsultation);
            end if;
            Enregistrer(Adresse, NoeudAEnregistrer, Cache.Arbre);
        end if;
    end Lire;

    procedure Enregistrer(Cache : in out T_Cache ; Adresse : in T_AdresseIP ; Masque : T_AdresseIP ; Destination : in Unbounded_String) is

        MinimumConsultation : Integer := Cache.Consultation;
        MinimumFrequence : Integer := Cache.Consultation;

        CleASupprimer : T_AdresseIP;
        NoeudAEnregistrer : T_Noeud;

        procedure TraiterMinimumConsultation(Cle : in T_AdresseIP ; Noeud : in T_Noeud) is
        begin
            if Noeud.DerniereConsultation < MinimumConsultation then
                MinimumConsultation := Noeud.DerniereConsultation;
                CleASupprimer := Cle;
            end if;
            end TraiterMinimumConsultation;

        procedure TraiterMinimumFrequence(Cle : in T_AdresseIP ; Noeud : in T_Noeud) is
        begin
            if Noeud.NombreConsultation < MinimumFrequence then
                MinimumFrequence := Noeud.NombreConsultation;
                CleASupprimer := Cle;
            end if;
        end TraiterMinimumFrequence;

        procedure LRU_FIFO is new PourChaque(Traiter => TraiterMinimumConsultation);

        procedure LFU is new PourChaque(Traiter => TraiterMinimumFrequence);

    begin
        if Cache.Taille = Cache.Taille_Max then
            if To_String(Cache.Politique) = "LRU" or to_String(Cache.Politique) = "FIFO" then
                LRU_FIFO(Cache.Arbre);
            elsif To_String(Cache.Politique) = "LFU" then
                LFU(Cache.Arbre);
            else
                raise PolitiqueInvalide;
            end if;
            Supprimer(CleASupprimer, Cache.Arbre);
        else
            Cache.Taille := Cache.Taille + 1;
        end if;
        NoeudAEnregistrer := T_Noeud'(Destination, Cache.consultation, 0);
        Enregistrer(Adresse and Masque, NoeudAEnregistrer, Cache.Arbre);
    end Enregistrer;

    procedure Afficher(Cache : in T_Cache ; Ligne : in Integer) is

        procedure AfficherDestination(Cle : in T_AdresseIP ; Noeud : in T_Noeud) is
        begin
            AfficherAdresseIP(Cle);
            Put(" ");
            Put(To_String(Noeud.Destination));
            New_Line;
        end AfficherDestination;

        procedure AfficherArbre is new arbre_cache.Afficher(AfficherNoeud => AfficherDestination);

    begin
        if Cache.Taille = 0 then
            Put_Line("Le cache est vide");
        else
            Put_Line("cache (ligne " & Integer'Image(Ligne) & ")");
            AfficherArbre(Cache.Arbre);
        end if;
    end Afficher;

    procedure Vider(Cache : in out T_Cache) is
    begin
        Vider(Cache.Arbre);
        Cache.taille := 0;
        Cache.Consultation := 0;
        Cache.Defauts := 0;
    end Vider;

end cache_la;
