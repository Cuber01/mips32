library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUTest is
end entity;

architecture test of ALUTest is
    component ALU is
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           Control : in STD_LOGIC_VECTOR (2 downto 0);
           AluResult : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
    end component;
    
    signal SrcA : STD_LOGIC_VECTOR (31 downto 0);
    signal SrcB : STD_LOGIC_VECTOR (31 downto 0);
    signal Control : STD_LOGIC_VECTOR (2 downto 0);
    signal AluResult : STD_LOGIC_VECTOR (31 downto 0);
    
begin
    A: ALU port map(SrcA=>SrcA,SrcB=>SrcB,Control=>Control,AluResult=>AluResult);

    stimulus_process : process
    begin
        -- Addition
        SrcA <= x"12345678";
        SrcB <= x"07654321";
        Control <= "010";
        
        wait for 5 ns;
        
        assert AluResult = x"19999999" severity failure;
        
        report "Test finished successfully.";
        wait; 
    end process;
    
end architecture;