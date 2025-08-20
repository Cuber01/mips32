library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    Port ( clk, reset : in STD_LOGIC;
           Op : in STD_LOGIC_VECTOR (31 downto 26);
           Funct : in STD_LOGIC_VECTOR (5 downto 0);
           IorD : out STD_LOGIC;
           ShouldMemWrite : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           PCWrite : out STD_LOGIC;
           oBranch : out STD_LOGIC;
           PCSrc : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           SrcBChoose : out STD_LOGIC_VECTOR (1 downto 0);
           SrcAChoose : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           RegDst : out STD_LOGIC;
           MemtoReg : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
type T_STATE is
      (FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WRITEBACK, MEM_WRITE, EXECUTE, ALU_WRITEBACK, BRANCH);
signal state : T_STATE := FETCH; 
-- Reset state?
begin
    process(clk) begin
        case state is

            when FETCH =>
                IorD <= '0';
                SrcAChoose <= '0';
                SrcBChoose <= "01";
                ALUOp <= "00";
                PCSrc <= '0';
                IRWrite <= '1';
                PCWrite <= '1';
                
                state <= DECODE;

            when DECODE =>
                case Op is
                    when "000000" =>
                        state <= EXECUTE; -- Execute R instruction
                    when "100011" | "101011" =>
                        state <= MEM_ADR; -- lw or sw
                    when others =>
                        report "Unknown OP";
                end case;

            when MEM_ADR =>
                SrcAChoose <= '1';
                SrcBChoose <= "10";
                ALUOp <= "00";
                
                if Op="100011" then
                    -- lw
                    state <= MEM_READ; -- Mem Read
                else
                    -- sw
                    state <= MEM_WRITE;
                end if;
            -- Mem Read
            when MEM_READ =>
                IorD <= '1';
                
                state <= MEM_WRITEBACK;
            -- Mem Writeback
            when MEM_WRITEBACK =>
                RegDst <= '0';
                MemtoReg <= '1';
                RegWrite <= '1';
                
                state <= FETCH;
            -- Mem Write
            when MEM_WRITE =>
                IorD <= '1';
                ShouldMemWrite <= '1';
                
                state <= FETCH;
            -- Execute
            when EXECUTE =>
                SrcAChoose <= '1';
                SrcBChoose <= "00";
                ALUOp <= "10";
                
                state <= ALU_WRITEBACK;
            -- ALU Writeback
            when ALU_WRITEBACK =>
                RegDst <= '1';
                MemtoReg <= '0';
                RegWrite <= '1';
                
                state <= FETCH;
            when others =>
                report "Unknown state";
        end case;
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUDecoder is
    Port ( ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           Funct : in STD_LOGIC_VECTOR (5 downto 0);
           Control : out STD_LOGIC_VECTOR (2 downto 0));
end ALUDecoder;

architecture Behavioral of ALUDecoder is
begin
    process(ALUOp, Funct)
    begin
    case ALUOp is
        when "00" => 
            Control <= "010"; -- add
        when "01" =>
            Control <= "110"; -- subtract
            case Funct is
                when "100000" => Control <= "010"; -- add
                when "100010" => Control <= "110"; -- sub
                when "100100" => Control <= "000"; -- and
                when "100101" => Control <= "001"; -- or
                when "101010" => Control <= "111"; -- slt
                when others => Control <= "---"; -- ???
            end case;
    end case;
    end process;

end Behavioral;