library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
    Port ( a1 : in STD_LOGIC_VECTOR (31 downto 0);
           a2 : in STD_LOGIC_VECTOR (31 downto 0);
           aluControl : in STD_LOGIC_VECTOR (3 downto 0);  
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    
    signal resultx : std_logic_vector(31 downto 0);
    
    
begin

    process(a1, a2,aluControl)
    begin
        
        case aluControl is
        
            when "0000" => -- Bitwise And
                resultx <= a1 and a2;
                
            when "0001" => -- Bitwise OR
                 resultx <= a1 or a2;
                
            when "0010" => -- Addition
                 resultx <= std_logic_vector(unsigned(a1) +  unsigned(a2));
            
            when "0110" => -- Subtraction
                 resultx <= std_logic_vector(unsigned(a1) -  unsigned(a2));
            
            when "0111" => -- Set Less Than
                if ( a1 < a2 ) then
                   resultx <= x"00000001";
                else
                     resultx <= x"00000000";
                end if;
            
            when "1100" => -- Logical Nor
                resultx <= a1 nor a2;
                
            when others => null;  -- NO OPERATION
                resultx <= x"00000000";
                
        end case;
        
    end process;

    -- Concurrent Code
    ALUResult <=  resultx;
    Zero <= '1' when  resultx = x"00000000" else
            '0';

end Behavioral;
