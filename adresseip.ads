with Ada.Text_IO;      use Ada.Text_IO;

package adresseIP is

  Type T_AdresseIP is mod 2**32;

  procedure AfficherAdresseIP (adresse : in T_AdresseIP);

  procedure AfficherAdresseIP (Fichier : in out File_Type; adresse : in T_AdresseIP);

  function TransformerAdresseIP (Fichier : in out File_Type) return T_AdresseIP;

end adresseIP;
