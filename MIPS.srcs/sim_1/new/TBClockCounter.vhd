library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockCounter_tb is
end ClockCounter_tb;

architecture Behavioral of ClockCounter_tb is

    component ClockCounter
        Port (
            clk : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: ClockCounter
        Port map (
            clk => clk,
            count => count
        );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
        wait for clk_period * 20;

        assert false report "End of simulation" severity failure;
    end process;

end Behavioral;