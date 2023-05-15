library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_OUT_REG is
 Port ( 
        clock : in std_logic;
        DataIn: in std_logic_vector(31 downto 0);
        DataOut : out std_logic_vector(31 downto 0)
        
        );
        
end ALU_OUT_REG;

architecture Behavioral of ALU_OUT_REG is

begin

      process(clock)
      begin
           if(rising_edge(clock)) then
                DataOut <= DataIn;
                
           end if;
      end process;


end Behavioral;
