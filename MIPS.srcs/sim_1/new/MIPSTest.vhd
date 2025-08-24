library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end entity;

architecture test of testbench is
    component MIPSCore is
        Port ( clk, reset : in STD_LOGIC);
    end component;
    
    signal clk, reset : STD_LOGIC := '0';
    
begin
    mips: MIPSCore port map(clk => clk, reset => reset);
    
    clock_gen: process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;
    
end architecture;