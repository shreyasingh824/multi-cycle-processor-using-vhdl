

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity MERGED_MEMORY is
Port (     clock       : in std_logic;
           Address   : in std_logic_vector (31 downto 0);
           MemRead   : in std_logic;
           MemWrite  : in std_logic;
           WriteData : in std_logic_vector(31 downto 0);
           MemData   : out std_logic_vector (31 downto 0)






 );
end MERGED_MEMORY;

architecture Behavioral of MERGED_MEMORY is
 type RAM_128_x_8 is array(0 to 127) of std_logic_vector(7 downto 0);
 signal MEM : RAM_128_x_8 := (
  x"02", x"32", x"40", x"20",x"02", x"32", x"40", x"22",
  x"01", x"28", x"50", x"20",x"01", x"28", x"50", x"22",
  x"01", x"49", x"40", x"2a",x"12", x"11", x"ff", x"fb",
  x"01", x"28", x"50", x"24",x"01", x"8b", x"68", x"25",
  x"01", x"28", x"50", x"20",x"01", x"49", x"40", x"2a",
  x"08", x"10", x"00", x"00",x"01", x"28", x"50", x"22",
  x"8c", x"20", x"00", x"00",x"00", x"00", x"00", x"00",
  x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", 
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00"
                               
                                );  
begin
    
    process(Address, MemRead, MemWrite, WriteData, clock)
    begin
        if(rising_edge(clock)) then
            if MemWrite = '1' then
                MEM(TO_INTEGER(unsigned(Address)))     <= WriteData(7 downto 0);
                MEM(TO_INTEGER(unsigned(Address)) + 1) <= WriteData(15 downto 8);
                MEM(TO_INTEGER(unsigned(Address)) + 2) <= WriteData(23 downto 16);
                MEM(TO_INTEGER(unsigned(Address)) + 3) <= WriteData(31 downto 24);
            end if;
            
            if MemRead = '1' then
                MemData <=    MEM(TO_INTEGER(unsigned(Address))) 
                            & MEM((TO_INTEGER(unsigned(Address)) + 1)) 
                            & MEM((TO_INTEGER(unsigned(Address)) + 2)) 
                            & MEM((TO_INTEGER(unsigned(Address)) + 3));
            end if;
        end if;
    end process;

end Behavioral;
