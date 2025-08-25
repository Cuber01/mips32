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
    process(Control,SrcA,SrcB)
    begin
        case Control is
            when "010" => 
                report "ADD " & integer'image(to_integer(unsigned(SrcA))) & " + " & integer'image(to_integer(unsigned(SrcB)));
                report "RESULT " & integer'image(to_integer(unsigned(SrcA) + unsigned(SrcB)));
                AluResult <= std_logic_vector(unsigned(SrcA) + unsigned(SrcB));
            when "110" =>
                report "SUBTRACT " & integer'image(to_integer(unsigned(SrcA))) & " - " & integer'image(to_integer(unsigned(SrcB)));
                report "RESULT " & integer'image(to_integer(unsigned(SrcA) - unsigned(SrcB)));
                AluResult <= std_logic_vector(unsigned(SrcA) - unsigned(SrcB));
            when "000" => 
                report "AND " &  integer'image(to_integer(unsigned(SrcA))) & " and " & integer'image(to_integer(unsigned(SrcB)));
                report "RESULT " & integer'image(to_integer(unsigned(SrcA) and unsigned(SrcB)));
                AluResult <= SrcA and SrcB;
            when "001" => 
                report "OR " &  integer'image(to_integer(unsigned(SrcA))) & " or " & integer'image(to_integer(unsigned(SrcB)));
                report "RESULT " & integer'image(to_integer(unsigned(SrcA) or unsigned(SrcB)));
                AluResult <= SrcA or SrcB;
            when "111" => 
                report "COMPARE " &  integer'image(to_integer(unsigned(SrcA))) & " < " & integer'image(to_integer(unsigned(SrcB)));
                if signed(SrcA) < signed(SrcB) then
                    AluResult <= x"ffffffff";
                    report "RESULT TRUE";
                else 
                    AluResult <= x"00000000";
                    report "RESULT FALSE";
                end if;
            when others =>
                report "Alu Control ignored";
        end case;
    end process;



end Behavioral;
