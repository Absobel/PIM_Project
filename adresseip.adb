with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with exceptions;           use exceptions;

package body adresseIP is

    -- But : Afficher une adresse IP dans le terminal sous le format XXX.XXX.XXX.XXX
    --
    -- Paramètres :
    -- adresse : adresse IP à afficher
    --
    -- Pre / Post : aucune.

    procedure AfficherAdresseIP (Adresse : in T_AdresseIP) is
    begin
        for i in 0..2 loop
            Put(Natural (Adresse/256**(3-i) mod 256), 1);
            Put(".");
        end loop;
        put(Natural (Adresse mod 256), 1);
        Put(" ");
    end AfficherAdresseIP;

    -- But : Enregistrer une adresse IP dans un fichier
    --
    -- Paramètres :
    -- adresse : adresse IP à enregistrer
    -- fichier : fichier dans lequel enregistrer l'adresse IP
    --
    -- Pre / Post : aucune.

    procedure EnregistrerAdresse (Fichier : in out File_Type ; Adresse : in T_AdresseIP) is
    begin
        for i in 0..2 loop
            Put(Fichier, Natural (Adresse/256**(3-i) mod 256), 1);
            Put(Fichier, ".");
        end loop;
        put(Fichier, Natural (Adresse mod 256), 1);
        Put(Fichier, " ");
    end EnregistrerAdresse;

    -- But : Transformer une adresse IP littérale (XXX.XXX.XXX.XXX) en T_AdresseIP (un entier modulo 2**32)
    --
    -- Paramètres :
    -- adresse : adresse IP littérale à transformer
    --
    -- Pre / Post : aucune.
    --
    -- Remarque : Si l'adresse IP littérale n'est pas valide, la fonction soulève une ErreurFormat.

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
                    raise ErreurFormat;
                end if;
            end if;
        end loop;
        return Adresse;
    end TransformerAdresseIp;

end adresseIP;
