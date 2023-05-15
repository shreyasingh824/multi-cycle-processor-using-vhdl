library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_CONTROL is
port (

           funct : in STD_LOGIC_VECTOR (5 downto 0);
           AluOp : in STD_LOGIC_VECTOR(1 downto 0);
           Oprtn : out STD_LOGIC_VECTOR (3 downto 0)


 );
end ALU_CONTROL;

architecture Behavioral of ALU_CONTROL is

begin
    process(funct, AluOp)
begin

    if AluOp = "00" then 
        Oprtn <= "0010";
    elsif AluOp = "01" then 
        Oprtn <= "0110";
    elsif AluOp = "10" then
        if funct = "100000" then 
            Oprtn <= "0010";
        elsif funct = "100010" then 
            Oprtn <= "0110";
        elsif funct = "100100" then 
            Oprtn <= "0000";
        elsif funct = "100101" then 
           Oprtn <= "0001";
        elsif funct = "101010" then 
            Oprtn <= "0111";
        end if;
    end if;
end process;

end Behavioral;
