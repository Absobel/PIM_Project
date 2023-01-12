with Ada.Unchecked_Deallocation;
with Ada.Text_IO; use Ada.Text_IO;


package body arbre is

    procedure Free is
        new Ada.Unchecked_Deallocation(Object => T_Noeud, Name => T_LA);

    procedure Initialiser(Arbre : in out T_LA) is
    begin
        arbre := null;
    end Initialiser;

    function Taille(Arbre : in T_LA) return Integer is
    begin
        if Arbre = null then
            return 0;
        else
            return 1 + Taille(Arbre.All.Gauche) + Taille(Arbre.All.Droite);
        end if;
    end Taille;

    procedure Supprimer(Cle : in T_AdresseIP ; Arbre : in out T_LA) is
        Bit : T_AdresseIP;
        A_Detruire : T_LA;
    begin
        if Arbre.All.Gauche = Null and Arbre.All.Droite = Null then
            Free(Arbre);
        else
           Bit := Cle / 2**31;
           if Bit = 1 then
                Supprimer(Cle*2, Arbre.All.Droite);
           else
                Supprimer(Cle*2, Arbre.All.Gauche);
           end if;
           if Arbre.All.Gauche = Null and Arbre.All.Droite = Null then
                Free(Arbre);
           else if Arbre.All.Gauche /= Null and Arbre.All.Droite = Null then
                A_Detruire := Arbre;
                Arbre := Arbre.All.Gauche;
                Arbre.All.Cle := Arbre.All.Cle / 2;
                Free(A_Detruire);
            else if Arbre.All.Gauche = Null and Arbre.All.Droite /= Null then
                A_Detruire := Arbre;
                Arbre := Arbre.All.Droite;
                Arbre.All.Cle := Arbre.All.Cle / 2;
                Free(A_Detruire);
            else
               Null;
            end if;
            end if;
           end if;
        end if;
    end Supprimer;

    procedure Lire(Cle : in T_AdresseIP ; Valeur : out T_Valeur ; A_Trouve : out Boolean ; Arbre : in out T_LA) is

        procedure Lire_Recursif(Cle : in T_AdresseIP ; Valeur : out T_Valeur ; A_Trouve : out Boolean ; Arbre : in T_LA) is
            Bit : T_AdresseIP;

        begin
            if Arbre = Null then
                Valeur := ValeurParDefaut;
                A_Trouve := False;
            elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
                Valeur := Arbre.All.Valeur;
                A_Trouve := True;
            else
                Bit := Cle / 2**31;
                if Bit = 1 then
                    Lire_Recursif(Cle * 2 , Valeur , A_Trouve , Arbre.All.Droite);
                else
                    Lire_Recursif(Cle * 2 , Valeur , A_Trouve , Arbre.All.Gauche);
                end if;
            end if;
        end Lire_Recursif;

    begin
        if Arbre = Null then
            Valeur := ValeurParDefaut;
            A_Trouve := False;
        else
            Lire_Recursif(Cle , Valeur , A_Trouve , Arbre);
        end if;
    end Lire;

    procedure Enregistrer(Cle : in T_AdresseIP ; Valeur : in T_Valeur ; Arbre : in out T_LA) is
        Bit_Noeud : T_AdresseIP;
        BiT_AdresseIP : T_AdresseIP;
        CopieCle : T_AdresseIP;
        CopieValeur : T_Valeur;
    begin
        if Arbre = Null then
            Arbre := new T_Noeud'(Cle, Valeur, null, null);

        elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then

            if Cle = Arbre.All.Cle Then
                Arbre.All.Valeur := Valeur;

            else

                Bit_Noeud := Arbre.All.Cle / 2**31;
                BiT_AdresseIP := Cle / 2**31;

                CopieCle := Arbre.All.Cle;
                CopieValeur := Arbre.All.Valeur;
                Arbre := new T_Noeud'(0, ValeurParDefaut, null, null);

                if Bit_Noeud = 1 then
                    Arbre.All.Droite := New T_Noeud'(CopieCle*2, CopieValeur, null, null);
                    Enregistrer(Cle , Valeur , Arbre);

                else
                    Arbre.All.Gauche := New T_Noeud'(CopieCle*2, CopieValeur, null, null);
                    Enregistrer(Cle , Valeur , Arbre);
                end if;

            end if;
        else
            BiT_AdresseIP := Cle / 2**31;
            if BiT_AdresseIP = 1 then
                Enregistrer(Cle * 2 , Valeur , Arbre.All.Droite);
            else
                Enregistrer(Cle * 2 , Valeur , Arbre.All.Gauche);
            end if;
        end if;
    end Enregistrer;

    procedure Afficher(arbre : in T_LA) is
        procedure Afficher_Recursif(Arbre : in T_LA; Chemin : in T_AdresseIP; Profondeur : in Integer) is
        begin
            if Arbre = Null then
                Null;
            elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
                AfficherNoeud(Chemin + Arbre.All.Cle/2**Profondeur, Arbre.All.Valeur);
            else
                Afficher_Recursif(Arbre.All.Droite , Chemin + 2**(31-profondeur) , Profondeur + 1);
                Afficher_Recursif(Arbre.All.Gauche , Chemin , Profondeur + 1);
            end if;
        end Afficher_Recursif;
    begin
        Afficher_Recursif(Arbre , 0 , 0);
    end Afficher;

    procedure Vider(Arbre : in out T_LA) is
    begin
        if Arbre = Null then
            Null;
        else
            Vider(Arbre.All.Gauche);
            Vider(Arbre.All.Droite);
            Free(Arbre);
        end if;
    end Vider;

    procedure PourChaque(Arbre : in T_LA) is
    begin
        if Arbre = Null Then
            Null;
        else
            Traiter(Arbre.All.Cle, Arbre.All.Valeur);
            PourChaque(Arbre.All.Gauche);
            PourChaque(Arbre.All.Droite);
        end if;

    exception
        when others =>
            PourChaque(Arbre.All.Droite);
            PourChaque(Arbre.All.Gauche);
    end PourChaque;


end arbre;
