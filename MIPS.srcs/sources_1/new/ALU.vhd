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
    variable result : STD_LOGIC_VECTOR (31 downto 0);
    begin
        case Control is
            when "010" => 
                report "ADD " & integer'image(to_integer(unsigned(SrcA))) & " + " & integer'image(to_integer(unsigned(SrcB)));
                result := std_logic_vector(unsigned(SrcA) + unsigned(SrcB));
                report "RESULT " & integer'image(to_integer(unsigned(result)));
            when "110" =>
                report "SUBTRACT " & integer'image(to_integer(unsigned(SrcA))) & " - " & integer'image(to_integer(unsigned(SrcB)));
                result := std_logic_vector(unsigned(SrcA) - unsigned(SrcB));
               report "RESULT " & integer'image(to_integer(unsigned(result)));
            when "000" => 
                report "AND " &  integer'image(to_integer(unsigned(SrcA))) & " and " & integer'image(to_integer(unsigned(SrcB)));
                result := SrcA and SrcB;
                report "RESULT " & integer'image(to_integer(unsigned(result)));
            when "001" => 
                report "OR " &  integer'image(to_integer(unsigned(SrcA))) & " or " & integer'image(to_integer(unsigned(SrcB)));
                result := SrcA or SrcB;
                report "RESULT " & integer'image(to_integer(unsigned(result)));
            when "111" => 
                report "COMPARE " &  integer'image(to_integer(unsigned(SrcA))) & " < " & integer'image(to_integer(unsigned(SrcB)));
                if signed(SrcA) < signed(SrcB) then
                    result := x"ffffffff";
                    report "RESULT TRUE";
                else 
                    result := x"00000000";
                    report "RESULT FALSE";
                end if;
            when others =>
                report "Alu Control ignored";
        end case;
        
        if result=x"00000000" then
            Zero <= '1';
        else 
            Zero <= '0';
        end if;
        
        AluResult <= result;
    end process;



end Behavioral;
