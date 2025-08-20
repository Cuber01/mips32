library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           Control : in STD_LOGIC_VECTOR (2 downto 0);
           AluResult : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
begin
    process(SrcA, SrcB)
    variable result: STD_LOGIC_VECTOR (31 downto 0);
    begin
        case Control is
            when "010" => 
                AluResult <= std_logic_vector(signed(SrcA) + signed(SrcB));
            when "110" =>
                AluResult <= std_logic_vector(signed(SrcA) - signed(SrcB));
            when "000" => 
                AluResult <= SrcA and SrcB;
            when "001" => 
                AluResult <= SrcA or SrcB;
            when "111" => 
                if signed(SrcA) < signed(SrcB) then
                    AluResult <= x"ffff";
                else 
                    AluResult <= x"0000";
                end if;
            when others =>
                report "Unknown Alu Control";
        end case;
    end process;



end Behavioral;
