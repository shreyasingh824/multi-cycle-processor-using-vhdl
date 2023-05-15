


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity SHIFT_LEFT_2 is
 generic(
        N: integer := 32
   );
Port (
    datain  : in std_logic_vector(N-1 downto 0);
    dataout : out std_logic_vector(N-1 downto 0)


 );
end SHIFT_LEFT_2;

architecture Behavioral of SHIFT_LEFT_2 is

begin
      dataout <= std_logic_vector(shift_left(unsigned(datain), 2));

end Behavioral;
