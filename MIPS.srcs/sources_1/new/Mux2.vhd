

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux2 is
    Port ( Choose : in STD_LOGIC;
           IfTrue : in STD_LOGIC_VECTOR (31 downto 0);
           IfFalse : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end Mux2;

architecture Behavioral of Mux2 is
begin
y <= IfTrue when Choose='1' else IfFalse;
end Behavioral;
