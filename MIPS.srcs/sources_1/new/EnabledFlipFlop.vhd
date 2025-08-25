library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EnabledFlipFlop is
    Port ( clk, reset : in STD_LOGIC;
           enabled : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end EnabledFlipFlop;

architecture Behavioral of EnabledFlipFlop is
signal value: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process(clk, reset) begin
        if reset='1' then
            value <= (others => '0');
        end if;
        
        if rising_edge(clk) then
            if enabled='1' then
                value <= input;
            end if;
            
            output <= value;
        end if;
        
    end process;

end Behavioral;
