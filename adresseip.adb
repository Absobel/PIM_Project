with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;

package body adresseIP is

    procedure AfficherAdresseIP (Adresse : in T_AdresseIP) is
    begin
      for i in 0..2 loop
        Put(Natural (Adresse/256**(3-i) mod 256), 1);
        Put(".");
      end loop;
      put(Natural (Adresse mod 256), 1);
      Put(" ");
    end AfficherAdresseIP;

    procedure AfficherAdresseIP (Fichier : in out File_Type ; Adresse : in T_AdresseIP) is
    begin
      for i in 0..2 loop
        Put(Fichier, Natural (Adresse/256**(3-i) mod 256), 1);
        Put(Fichier, ".");
      end loop;
      put(Fichier, Natural (Adresse mod 256), 1);
      Put(Fichier, " ");
    end AfficherAdresseIP;

    function TransformerAdresseIp(Fichier : in out File_Type) return T_AdresseIP is
      Octet : Integer;
      Separateur : Character;
      Adresse : T_AdresseIP := 0;
    begin
      for i in 0..3 loop
        Get(Fichier, Octet);
        Adresse :=  T_AdresseIP(Octet) + Adresse*256;
        if i < 3 then
          Get(Fichier, Separateur);
          if Separateur /= '.' then
            Put_Line("Erreur de syntaxe dans l'adresse IP");
          end if;
        end if;
      end loop;
      return Adresse;
    end TransformerAdresseIp;

end adresseIP;
