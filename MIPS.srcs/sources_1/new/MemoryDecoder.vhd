library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity MemoryDecoder is
    Port ( clk : in STD_LOGIC;
           Addr : in STD_LOGIC_VECTOR (31 downto 0);
           ShouldMemWrite : in STD_LOGIC;
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end MemoryDecoder;

architecture Behavioral of MemoryDecoder is
signal init: STD_LOGIC := '0';
begin
    process (clk) is 
    
    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable i, index, result: integer;
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;  
      
    begin
        -- load file
        if init='0' then
            for i in 0 to 63 loop
                mem(i) := (others => '0');
            end loop;
            index := 0;
            FILE_OPEN(mem_file, "path", READ_MODE);
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
                    mem(index)(35-i*4 downto 32-i*4) := STD_LOGIC_VECTOR(to_unsigned(result,4));
                    end loop;
                    index := index+1;
                end loop;
                
                init <= '1';
        end if;
          
        -- Read/Write
        if rising_edge(clk) then
          if ShouldMemWrite='1' then
              mem(to_integer(signed(Addr))) := WriteData;
          else
              ReadData <= mem(to_integer(signed(Addr)));
          end if;
        end if;
     end process;
    
end Behavioral;
