
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ClockCounter is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR(31 downto 0));
end ClockCounter;

architecture Behavioral of ClockCounter is
signal counter: unsigned(31 downto 0) := (others => '0');
begin
    process(clk) begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    count <= std_logic_vector(counter);
end Behavioral;


