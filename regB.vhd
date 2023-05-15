library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity B is
Port (
           clock     : in std_logic;
           DataIn  : in STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0)


 );
end B;

architecture Behavioral of B is

begin
    process(DataIn, clock)
    begin
        if(rising_edge(clock)) then
             DataOut <= DataIn;
             
        end if;
    end process;


end Behavioral;
