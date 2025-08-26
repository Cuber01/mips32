library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    Port ( clk, reset : in STD_LOGIC;
           Op : in STD_LOGIC_VECTOR (31 downto 26);
           Funct : in STD_LOGIC_VECTOR (5 downto 0);
           IorD : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           PCWrite : out STD_LOGIC;
           oBranch : out STD_LOGIC;
           PCSrc : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           SrcBChoose : out STD_LOGIC_VECTOR (1 downto 0);
           SrcAChoose : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           RegDst : out STD_LOGIC;
           MemtoReg : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
type T_STATE is
      (FETCH, DECODE, CHECK_OP, MEM_ADR, MEM_READ, MEM_WRITEBACK, MEM_WRITE, EXECUTE, ALU_WRITEBACK, BRANCH, ADDI_EXECUTE, ADDI_WRITEBACK);
signal state : T_STATE := FETCH; 
    
procedure report_state(newState : in T_STATE) is
begin
    report "Changed state from " & T_STATE'IMAGE(state) & " to " & T_STATE'IMAGE(newState);
end procedure report_state;

begin
    -- Remember to properly reset Enables! Currently they get partially reset in FETCH and then fully in DECODE.
    -- That is because as of now they only get asserted in FETCH and in states leading to FETCH, but if this changes, 
    -- there will be a need for more resets
    process(clk) begin
        if falling_edge(clk) then
            case state is
    
                when FETCH =>
                    -- Enables
                    MemWrite <= '0';
                    IRWrite <= '1';
                    PCWrite <= '1';
                    oBranch <= '0';
                    RegWrite <= '0';
                
                    IorD <= '0';
                    SrcAChoose <= '0';
                    SrcBChoose <= "01";
                    ALUOp <= "00";
                    PCSrc <= '0';
                   
                    
                    report_state(DECODE);
                    state <= DECODE;
    
                when DECODE =>
                    -- Enables
                    MemWrite <= '0';
                    IRWrite <= '0';
                    PCWrite <= '0';
                    oBranch <= '0';
                    RegWrite <= '0';
                    
                    report_state(CHECK_OP);
                    state <= CHECK_OP;
            
                when CHECK_OP =>
                    case Op is
                        when "000000" =>
                            report_state(EXECUTE);
                            state <= EXECUTE; -- Execute R instruction
                        when "100011" | "101011" =>
                            report_state(MEM_ADR);
                            state <= MEM_ADR; -- lw or sw
                        when "001000" =>
                            report_state(ADDI_EXECUTE);
                            state <= ADDI_EXECUTE;    
                        when others =>
                            report "DECODE failed to change state.";
                    end case;
    
                when MEM_ADR =>
                    SrcAChoose <= '1';
                    SrcBChoose <= "10";
                    ALUOp <= "00";
                    
                    if Op="100011" then
                        -- lw
                        report_state(MEM_READ);
                        state <= MEM_READ; 
                    else
                        -- sw
                        report_state(MEM_WRITE);
                        state <= MEM_WRITE;
                    end if;
    
                when MEM_READ =>
                    IorD <= '1';
                    
                    report_state(MEM_WRITEBACK);
                    state <= MEM_WRITEBACK;
    
                when MEM_WRITEBACK =>
                    RegDst <= '0';
                    MemtoReg <= '1';
                    RegWrite <= '1';
                    
                    report_state(FETCH);
                    state <= FETCH;
    
                when MEM_WRITE =>
                    IorD <= '1';
                    MemWrite <= '1';
                    
                    report_state(FETCH);
                    state <= FETCH;
    
                when EXECUTE =>
                    SrcAChoose <= '1';
                    SrcBChoose <= "00";
                    ALUOp <= "10";
                    
                    report_state(ALU_WRITEBACK);
                    state <= ALU_WRITEBACK;
    
                when ALU_WRITEBACK =>
                    RegDst <= '1';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    
                    report_state(FETCH);
                    state <= FETCH;
                    
                when ADDI_EXECUTE =>
                    SrcBChoose <= "10";
                    SrcAChoose <= '1';
                    ALUOp <= "00";
                    
                    report_state(ADDI_WRITEBACK);
                    state <= ADDI_WRITEBACK;
                    
                when ADDI_WRITEBACK =>
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    RegDst <= '0';
                    
                    report_state(FETCH);
                    state <= FETCH;
                
                when others =>
                    report "Unknown state";
            end case;
        end if;
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
        when "00" => -- lw/sw/addi
            report "ALUOp is add.";
            Control <= "010"; -- add
        when "01" => -- beq
            report "ALUOp is subtract.";
            Control <= "110"; -- subtract
        when others => -- R type
            report "ALUOp is R-type.";
            case Funct is
                when "100000" => 
                    report "Funct is add";
                    Control <= "010"; -- add
                when "100010" => 
                    report "Funct is subtract";
                    Control <= "110"; -- sub
                when "100100" => 
                    report "Funct is and";
                    Control <= "000"; -- and
                when "100101" => 
                    Control <= "001"; -- or
                    report "Funct is or";
                when "101010" => 
                    Control <= "111"; -- slt
                    report "Funct is shift left.";
                when others => 
                    report "Funct is unknown";
                    Control <= "---"; -- ???
            end case;
    end case;
    end process;

end Behavioral;