with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings;               use Ada.Strings;

generic

     Taille : Integer;

package ligne_de_commande is

    type T_Tableau_Arguments is array (1 .. Taille) of Unbounded_String;

    procedure Usage;


    procedure Argument_Parsing(
        Argument : T_Tableau_Arguments;
        Argument_Count : in Integer;
        Cache_Size :     out Integer;
        Policy :         out Unbounded_String;
        Stat :           out Boolean;
        Table_File :     out Unbounded_String;
        Packet_File :    out Unbounded_String;
        Result_File :    out Unbounded_String);


end ligne_de_commande;
