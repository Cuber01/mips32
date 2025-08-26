library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity Memory is
    Port ( clk, reset : in STD_LOGIC;
           Addr : in STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : in STD_LOGIC;
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end Memory;

architecture Behavioral of Memory is
signal init: STD_LOGIC := '0';

type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
signal mem: ramtype;  

begin
    process (clk) is 
    
    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable i, index, result: integer;
    
    begin
        if rising_edge(clk) then
            if MemWrite='1' then
                report "MEMORY WRITE " & integer'image(to_integer(unsigned(WriteData))) & " at " & integer'image(to_integer(signed(Addr)));
                mem(to_integer(signed(Addr))) <= WriteData;
            end if;
        end if;
        
        ReadData <= mem(to_integer(unsigned(Addr)));
    
        -- load file
        if init='0' then
            for i in 63 downto 0 loop
                mem(i) <= (others => '0');
            end loop;
            index := 0;
            FILE_OPEN(mem_file, "/home/cubeq/Projects/FPGA/MIPS/machine_code.txt", READ_MODE);
            while not endfile(mem_file) loop
                readline(mem_file, L);
                result := 0;
                for i in 1 to 8 loop
                    read(L, ch);
                    if '0' <= ch and ch <= '9' then
                        result := character'pos(ch) - character'pos('0');
                    elsif 'a' <= ch and ch <= 'f' then
                        result := character'pos(ch) - character'pos('a')+10;
                    else 
                        report "Format error on line" & integer'image(index) severity error;
                    end if;
                    mem(index)(35-i*4 downto 32-i*4) <= STD_LOGIC_VECTOR(to_unsigned(result,4));
                end loop;
                index := index+1;
            end loop;
                
                init <= '1';
        end if;
     end process;
    
end Behavioral;
