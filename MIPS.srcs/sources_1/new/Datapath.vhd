library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Datapath is
    Port ( clk, reset : in STD_LOGIC;
           IorD : in STD_LOGIC;
           ShouldMemWrite : in STD_LOGIC;
           IRWrite : in STD_LOGIC;
           PCWrite : in STD_LOGIC;
           oBranch : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           ALUControl : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           SrcBChoose : in STD_LOGIC_VECTOR (1 downto 0);
           SrcAChoose : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           MemtoReg : in STD_LOGIC;
           Op : out STD_LOGIC_VECTOR(31 downto 26);
           Funct: out STD_LOGIC_VECTOR(5 downto 0));
end Datapath;

architecture Behavioral of Datapath is
    component ALU is
    Port ( SrcA, SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           Control : in STD_LOGIC_VECTOR (2 downto 0);
           AluResult : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
    end component;
    component Decoder4 is
    Port ( a, b, c, d : in STD_LOGIC_VECTOR (31 downto 0);
           Choose : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component  EnabledFlipFlop is
    Port ( clk : in STD_LOGIC;
           enabled : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component ShiftLeft2 is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component SignExtend is
    Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component MemoryDecoder is
    Port ( clk : in STD_LOGIC;
           Addr : in STD_LOGIC_VECTOR (31 downto 0);
           ShouldMemWrite : in STD_LOGIC;
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component Mux2 is
    Port ( Choose : in STD_LOGIC;
           IfTrue : in STD_LOGIC_VECTOR (31 downto 0);
           IfFalse : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component RegisterFile is
    Port ( clk : in STD_LOGIC;
           ReadAdr1, ReadAdr2, WriteAdr : in STD_LOGIC_VECTOR (4 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           RegWrite : in STD_LOGIC;
           ReadData1, ReadData2 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal PC: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal NextPC: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal EnablePC : STD_LOGIC := '0';
    
    -- Memory - Instrution and Data
    signal MemAddr: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal MemReadData: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    signal Instr: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    -- Register File
    signal RegReadData1: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal RegReadData2: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal RegWriteAdr: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal RegWriteData: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    signal SignImmediate: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    -- Shifting multipiles Immediate by 4 and as such transforms a jump value into the real amount of space between lines
    signal ImmediateShifted: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    -- ALU
    signal ALUOut: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal SrcA: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal SrcB: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALUZero: STD_LOGIC := '0';
    
begin
    EnablePC <= (oBranch and ALUZero) or PCWrite;
    Op <= Instr(31 downto 26);
    Funct <= Instr(5 downto 0);
    
    PcFlipFlop: EnabledFlipFlop port map(clk => clk, enabled => EnablePC, input => NextPC, output => PC);
    MemoryAdrMux: Mux2 port map(Choose => IorD, IfTrue => ALUOut, IfFalse => PC, y => MemAddr);
    InstructionAndDataMem: MemoryDecoder port map(clk => clk, Addr => MemAddr, ShouldMemWrite => ShouldMemWrite, 
                                                  WriteData => RegReadData2, ReadData => MemReadData);
    
    InstrFlipFlop: EnabledFlipFlop port map(clk => clk, enabled => IRWrite, input => MemReadData, output => Instr);
    WriteAdrMux: Mux2 port map(Choose => RegDst, IfTrue => Instr(15 downto 11), IfFalse => Instr(20 downto 16), y => RegWriteAdr);
    WriteDataMux: Mux2 port map(Choose => MemtoReg, IfTrue => MemReadData, IfFalse => ALUOut, y => RegWriteData);
    Registers: RegisterFile port map(clk => clk, ReadAdr1=>Instr(25 downto 21), ReadAdr2=>Instr(20 downto 16), WriteAdr => RegWriteAdr,
                                     RegWrite=>RegWrite, ReadData1=>RegReadData1, ReadData2=>RegReadData2, WriteData => RegWriteData);
    
    SignExtender: SignExtend port map(a => Instr(15 downto 0), y=> SignImmediate);
    Shifter: ShiftLeft2 port map (a => SignImmediate, y => ImmediateShifted);
    SrcBDecoder: Decoder4 port map(a => RegReadData2, b => "100", c => SignImmediate, d => ImmediateShifted,
                                      Choose => SrcBChoose, y => SrcB);
    SrcAMux: Mux2 port map(Choose => SrcAChoose, IfFalse => PC, IfTrue => RegReadData1, y => SrcA);
    MainALU: ALU port map(SrcA => SrcA, SrcB => SrcB, Control => ALUControl, Zero => ALUZero, ALUResult => ALUOut);
    
end Behavioral;
