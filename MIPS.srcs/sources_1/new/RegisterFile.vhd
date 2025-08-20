library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( clk : in STD_LOGIC;
           ReadAdr1, ReadAdr2, WriteAdr : in STD_LOGIC_VECTOR (4 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           RegWrite : in STD_LOGIC;
           ReadData1, ReadData2 : out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);

signal mem: ramtype;
begin
    process(clk) begin
        if rising_edge(clk) then
            if RegWrite='1' then
                mem(to_integer(signed(WriteAdr))) <= WriteData;
            end if;
        end if;
    end process;
    
    -- all
    process(clk, ReadAdr1, ReadAdr2, WriteAdr, WriteData, RegWrite) begin
        if(signed(ReadAdr1)=0) then
            ReadData1 <= x"00000000";
        else
            ReadData1 <= mem(to_integer(signed(ReadAdr1)));
        end if;
        
        if(signed(ReadAdr2)=0) then
            ReadData2 <= x"00000000";
        else
            ReadData2 <= mem(to_integer(signed(ReadAdr2)));
        end if;
    end process;

end Behavioral;
