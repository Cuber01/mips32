library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder4 is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : in STD_LOGIC_VECTOR (31 downto 0);
           d : in STD_LOGIC_VECTOR (31 downto 0);
           Choose : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end Decoder4;

architecture Behavioral of Decoder4 is

begin
    y <= a when Choose="00"
    else b when Choose="01"
    else c when Choose="10"
    else d;
end Behavioral;
