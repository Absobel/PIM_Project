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

    procedure Traiter(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in out T_LA) is

        procedure Traiter_Recursif(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : out Unbounded_String ; A_Trouve : out Boolean ; Arbre : in T_LA) is
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
            else if Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
                Comparer_Donnees(Courant , Cle , Valeur , A_Trouve , Arbre);
            else
                Bit := Cle / 2**31;
                if Bit = 1 then
                    Traiter_Recursif(Courant , Cle * 2 , Valeur , A_Trouve , Arbre.All.Droite);
                else
                    Traiter_Recursif(Courant , Cle * 2 , Valeur , A_Trouve , Arbre.All.Gauche);
                end if;
                    Null;
                end if;
            end if;
        end Traiter_Recursif;

    begin
        if Arbre = Null then
            Valeur := To_Unbounded_String("Arbre vide");
            A_Trouve := False;
        else
            Traiter_Recursif(Courant , Cle , Valeur , A_Trouve , Arbre);
        end if;
    end Traiter;

    procedure Enregistrer(Courant : in Integer ; Cle : in T_AdresseIP ; Valeur : in Unbounded_String ; Arbre : in out T_LA) is
        Bit : T_AdresseIP;
        Copie : T_LA;
    begin
        if Arbre = Null then
            Arbre := new T_Noeud'(Cle, Valeur, Courant, null, null);
        else if Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
            Bit := Arbre.All.Cle / 2**31;
            Copie := Arbre;
            Arbre := new T_Noeud'(0, To_Unbounded_String("Invalide"), 0, null, null);
            if Bit = 1 then
                Arbre.All.Droite := Copie;
            else
                Arbre.All.Gauche := Copie;
            end if;
        else
            Bit := Cle / 2**31;
            if Bit = 1 then
                Enregistrer(Courant , Cle * 2 , Valeur , Arbre.All.Droite);
            else
                Enregistrer(Courant , Cle * 2 , Valeur , Arbre.All.Gauche);
            end if;
        end if;
        end if;
    end Enregistrer;

    procedure Afficher(arbre : in T_LA) is
        procedure Afficher_Recursif(Arbre : in T_LA; Chemin : in T_AdresseIP; Profondeur : in Integer) is
            Bit : T_AdresseIP;
        begin
            if Arbre = Null then
                Null;
            else if Arbre.All.Droite = Null and Arbre.All.Gauche = Null then
               AfficherAdresseIP(Chemin * 2**profondeur + Arbre.All.Cle / 2**profondeur);
               Put_Line(" " & To_String(Arbre.All.Valeur));
            else
                Bit := Arbre.All.Cle / 2**31;
                if Bit = 1 then
                    Afficher_Recursif(Arbre.All.Droite , Chemin + 2**(31-profondeur) , Profondeur + 1);
                else
                    Afficher_Recursif(Arbre.All.Gauche , Chemin , Profondeur + 1);
                end if;
            end if;
            end if;
        end Afficher_Recursif;
    begin
        Afficher_Recursif(Arbre , 0 , 0);
    end Afficher;

end arbre;
