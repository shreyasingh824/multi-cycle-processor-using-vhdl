library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INSTRUCTION_REG is
    Port ( clock : in STD_LOGIC;
           InstructionIn : in STD_LOGIC_VECTOR (31 downto 0);
           InstructionOut : out STD_LOGIC_VECTOR (31 downto 0);
           IRwrite : in STD_LOGIC);
end INSTRUCTION_REG;

architecture Behavioral of INSTRUCTION_REG is

begin

process(clock)
begin
     if(rising_edge(clock)) then
            if IRwrite ='1' then
                 InstructionOut <=InstructionIn;
            end if;
      end if;
end process;


end Behavioral;
