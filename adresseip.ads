with Ada.Text_IO;      use Ada.Text_IO;

package adresseIP is

  Type T_AdresseIP is mod 2**32;

  -- Affiche l'adresse IP dans le terminal
  procedure AfficherAdresseIP (adresse : in T_AdresseIP);

  -- Enregistre l'adresse IP dans un fichier
  procedure EnregistrerAdresse (Fichier : in out File_Type; adresse : in T_AdresseIP);

  -- Convertit une adresse IP dans le fichier en T_AdresseIP
  function TransformerAdresseIP (Fichier : in out File_Type) return T_AdresseIP;

end adresseIP;
