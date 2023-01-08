with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;


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

    procedure Supprimer(Courant : in Integer ; Arbre : in out T_LA) is
    Minimum : integer := Courant;
    Cle : T_AdresseIP := 0;

        procedure Minimum_Recursion(Arbre : in T_LA ; Arg : in Integer ; Minimum : in out Integer ; Cle : out T_AdresseIP) is
        begin
            if Arbre = Null then
                Null;
            else
                if Arbre.All.Gauche = Null and Arbre.All.Droite = Null then
                    if Minimum > Arbre.All.Consultation then
                        Minimum := Arbre.All.Consultation;
                        Cle := Arbre.All.Cle;
                    else
                        Null;
                    end if;
                else
                    Minimum_Recursion(Arbre.All.Gauche , Arg , Minimum , Cle);
                    Minimum_Recursion(Arbre.All.Droite , Arg , Minimum , Cle);
                end if;
            end if;
        end Minimum_Recursion;

        procedure Supprimer_Par_Cle(Arbre : in out T_LA ; Cle : in T_AdresseIP) is
            Bit : T_AdresseIP;
            A_Detruire : T_LA;
        begin
            if Arbre.All.Gauche = Null and Arbre.All.Droite = Null then
                Free(Arbre);
            else
               Bit := Cle / 2**31;
               if Bit = 1 then
                    Supprimer_Par_Cle(Arbre.All.Droite , Cle * 2);
               else
                    Supprimer_Par_Cle(Arbre.All.Gauche , Cle * 2);
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
        end Supprimer_Par_Cle;

    begin
        Minimum_Recursion(Arbre , Courant , Minimum , Cle);
        Supprimer_Par_Cle(Arbre , Cle);
    end Supprimer;

    procedure Lire(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in out T_LA) is

        procedure Lire_Recursif(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in T_LA) is
            Bit : T_AdresseIP;

            procedure Comparer_Donnees(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in T_LA) is
            begin
                if Arbre.All.Cle = Cle then
                    Valeur := Arbre.All.Valeur;
                    A_Trouve := True;
                    Arbre.All.Consultation := Courant;
                else
                    Valeur := To_Unbounded_String("Introuvable");
                    A_Trouve := False;
                end if;
            end Comparer_Donnees;


        begin
            if Arbre = Null then
                Valeur := To_Unbounded_String("Introuvable");
                A_Trouve := False;
            elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
                Comparer_Donnees(Courant , Cle , Valeur , A_Trouve , Arbre);
            else
                Bit := Cle / 2**31;
                if Bit = 1 then
                    Lire_Recursif(Courant , Cle * 2 , Valeur , A_Trouve , Arbre.All.Droite);
                else
                    Lire_Recursif(Courant , Cle * 2 , Valeur , A_Trouve , Arbre.All.Gauche);
                end if;
            end if;
        end Lire_Recursif;

    begin
        if Arbre = Null then
            Valeur := To_Unbounded_String("Arbre vide");
            A_Trouve := False;
        else
            Lire_Recursif(Courant , Cle , Valeur , A_Trouve , Arbre);
        end if;
    end Lire;

    procedure Enregistrer(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : in Unbounded_String ; Arbre : in out T_LA) is
        Bit_Noeud : T_AdresseIP;
        Bit_Cle : T_AdresseIP;
        Copie : T_LA;
    begin
        if Arbre = Null then
            Arbre := new T_Noeud'(Cle, Valeur, Courant, null, null);
        elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
            Bit_Noeud := Arbre.All.Cle / 2**31;
            Bit_Cle := Cle / 2**31;
            if Bit_Noeud = Bit_Cle then
                Copie := Arbre;
                Arbre := new T_Noeud'(0, To_Unbounded_String("Invalide"), 0, null, null);
                if Bit_Noeud = 1 then
                    Arbre.All.Droite := New T_Noeud'(Copie.All.Cle*2, Copie.All.Valeur, Copie.All.Consultation, null, null);
                    Enregistrer(Courant , Cle*2 , Valeur , Arbre.All.Droite);
                else
                    Arbre.All.Gauche := New T_Noeud'(Copie.All.Cle*2, Copie.All.Valeur, Copie.All.Consultation, null, null);
                    Enregistrer(Courant , Cle*2 , Valeur , Arbre.All.Gauche);
                end if;
                Free(Copie);
            else
                if Bit_Cle = 1 then
                    Arbre.All.Droite := new T_Noeud'(Cle*2, Valeur, Courant, null, null);
                    Arbre.All.Gauche := new T_Noeud'(Arbre.All.Cle*2, Arbre.All.Valeur, Arbre.All.Consultation, null, null);
                else
                    Arbre.All.Gauche := new T_Noeud'(Cle*2, Valeur, Courant, null, null);
                    Arbre.All.Droite := new T_Noeud'(Arbre.All.Cle*2, Arbre.All.Valeur, Arbre.All.Consultation, null, null);
                end if;
            end if;
        else
            Bit_Cle := Cle / 2**31;
            Copie := Arbre;
            Arbre := new T_Noeud'(0, To_Unbounded_String("Invalide"), 0, null, null);
            if Bit_Cle = 1 then
                Enregistrer(Courant , Cle * 2 , Valeur , Arbre.All.Droite);
            else
                Enregistrer(Courant , Cle * 2 , Valeur , Arbre.All.Gauche);
            end if;
            Free(Copie);
        end if;
    end Enregistrer;

    procedure Afficher(arbre : in T_LA) is
        procedure Afficher_Recursif(Arbre : in T_LA; Chemin : in T_AdresseIP; Profondeur : in Integer) is
        begin
            if Arbre = Null then
                Null;
            elsif Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
               AfficherAdresseIP(Chemin + Arbre.All.Cle / 2**profondeur);
               Put_Line(" " & To_String(Arbre.All.Valeur));
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

end arbre;
