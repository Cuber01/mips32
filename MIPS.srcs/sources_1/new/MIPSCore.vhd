library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPSCore is
  Port ( clk, reset : in STD_LOGIC);
end MIPSCore;

architecture Behavioral of MIPSCore is
component ControlUnit is
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
end component;

component Datapath is
    Port ( clk, reset : in STD_LOGIC;
           Op : out STD_LOGIC_VECTOR(31 downto 26);
           Funct: out STD_LOGIC_VECTOR(5 downto 0);
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
           MemtoReg : in STD_LOGIC);
end component;

signal Op: STD_LOGIC_VECTOR(31 downto 26) := (others => '0');
signal Funct: STD_LOGIC_VECTOR(31 downto 26) := (others => '0');

signal IorD, ShouldMemWrite, IRWrite, PCWrite, oBranch, PCSrc, SrcAChoose, RegWrite, RegDst, MemtoReg : STD_LOGIC := '0';
signal ALUControl : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal ALUOp, SrcBChoose : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

begin
    MIPSDatapath: Datapath port map(clk=>clk, reset=>reset, Op=>Op, Funct=>Funct, IorD=>IorD, ShouldMemWrite=>ShouldMemWrite,
                                    IRWrite=>IRWrite, PCWrite=>PCWrite, oBranch=>oBranch, PCSrc=>PCSrc, SrcAChoose=>SrcAChoose,
                                    RegWrite=>RegWrite, RegDst=>RegDst, MemtoReg=>MemtoReg, ALUControl=>ALUControl,
                                    ALUOp=>ALUOp, SrcBChoose=>SrcBChoose);
                                    
    MIPSControlUnit: ControlUnit port map(clk=>clk, reset=>reset, Op=>Op, Funct=>Funct, IorD=>IorD, ShouldMemWrite=>ShouldMemWrite,
                                         IRWrite=>IRWrite, PCWrite=>PCWrite, oBranch=>oBranch, PCSrc=>PCSrc, SrcAChoose=>SrcAChoose,
                                         RegWrite=>RegWrite, RegDst=>RegDst, MemtoReg=>MemtoReg, ALUControl=>ALUControl,
                                         ALUOp=>ALUOp, SrcBChoose=>SrcBChoose);

end Behavioral;
