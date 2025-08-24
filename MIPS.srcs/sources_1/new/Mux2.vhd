library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned;

entity Mux2 is
    generic (
        width : integer := 31
    );

    Port ( Choose : in STD_LOGIC;
           IfTrue : in STD_LOGIC_VECTOR (width-1 downto 0);
           IfFalse : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : out STD_LOGIC_VECTOR (width-1 downto 0));
end Mux2;

architecture Behavioral of Mux2 is
begin
y <= IfTrue when Choose='1' else IfFalse;
end Behavioral;
