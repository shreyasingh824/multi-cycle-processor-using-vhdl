library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity FSM is
 Port (     clock         : in std_logic;
            reset       : in std_logic;
            Op          : in std_logic_vector(5 downto 0);
            RegDst      : out std_logic;
            RegWrite    : out std_logic;
            ALUSrcA     : out std_logic;
            ALUSrcB     : out std_logic_vector(1 downto 0);
            ALUOp       : out std_logic_vector(1 downto 0);
            PCSource    : out std_logic_vector(1 downto 0);
            PCWriteCond : out std_logic;
            PCWrite     : out std_logic;
            IorD        : out std_logic;
            MemRead     : out std_logic;
            MemWrite    : out std_logic;
            MemtoReg    : out std_logic;
            IRWrite     : out std_logic
 
  );
end FSM;

architecture Behavioral of FSM is
--current state contains 4 bits to identify the state
signal currentState : std_logic_vector(3 downto 0) := "0000";
begin
  process(Op,currentState, clock)
    begin
        if rising_edge(clock) then
            if currentState = "0000" then
                currentState <= "0001";
                
            elsif currentState = "0001" then
               
                if Op = "100011" or Op = "101011" then
                    currentState <= "0010";
                    
                -- if R-Type
                elsif Op = "000000" then
                    currentState <= "0110";
                    
                -- if BEQ
                elsif Op = "000100" then
                    currentState <= "1000";
                    
                elsif Op = "000010" then
                    currentState <= "1001";

                   
                end if;
                
            elsif currentState = "0010" then
                -- if Op = "lw"
                if Op = "100011" then
                    currentState <= "0011";
                    
                elsif Op = "101011" then
                    currentState <= "0101";
                    
                end if;
                
            elsif currentState = "0011" then
                currentState <= "0100";
                
            elsif currentState = "0110" then
                currentState <= "0111";
                
            elsif currentState = "0100" then
                currentState <= "0000";
                
            elsif currentState = "0101" then
                currentState <= "0000";
                
            elsif currentState = "0111" then
                currentState <= "0000";
                
            elsif currentState = "1000" then
                currentState <= "0000";
                
            elsif currentState = "0101" then
                currentState <= "0000";
            end if;
        end if;
        if currentState = "0000" then
            PCWrite <= '1';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '1';
            MemWrite <= '0';
            IRWrite <= '1';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "01";
            ALUSrcA <= '0';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "0001" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            --IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "11";
            ALUSrcA <= '0';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "0010" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "10";
            ALUSrcA <= '1';
            RegWrite <= '0';
            RegDst <= '0'; 
        
        elsif currentState = "0011" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '1';
            MemRead <= '1';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "00";
            ALUSrcA <= '0';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "0100" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '1';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "00";
            ALUSrcA <= '0';
            RegWrite <= '1';
            RegDst <= '0';
        
        elsif currentState = "0101" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '1';
            MemRead <= '0';
            MemWrite <= '1';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "00";
            ALUSrcA <= '0';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "0110" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "10";
            ALUSrcB <= "00";
            ALUSrcA <= '1';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "0111" then
            PCWrite <= '0';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "00";
            ALUOp <= "00";
            ALUSrcB <= "00";
            ALUSrcA <= '0';
            RegWrite <= '1';
            RegDst <= '1';
        
        elsif currentState = "1000" then
            PCWrite <= '0';
            PCWriteCond <= '1';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "01";
            ALUOp <= "01";
            ALUSrcB <= "00";
            ALUSrcA <= '1';
            RegWrite <= '0';
            RegDst <= '0';
        
        elsif currentState = "1001" then
            PCWrite <= '1';
            PCWriteCond <= '0';
            IorD <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            IRWrite <= '0';
            MemtoReg <= '0';
            PCSource <= "10";
            ALUOp <= "00";
            ALUSrcB <= "00";
            ALUSrcA <= '0';
            RegWrite <= '0';
            RegDst <= '0';
        
        end if;
    end process;
    
    

end Behavioral;
