library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SIGN_EXTENDER is
Port (
        signExtenIn:in std_logic_vector(15 downto 0) ;
        signOut: out std_logic_vector(31 downto 0)



);
end SIGN_EXTENDER;

architecture Behavioral of SIGN_EXTENDER is

begin
       signOut <= x"0000" & signExtenIn when signExtenIn(15) = '0' else
                x"FFFF" & signExtenIn;


end Behavioral;
