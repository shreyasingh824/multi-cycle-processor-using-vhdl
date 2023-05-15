library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity REG_FILE is
 generic (
        M : integer := 32;    -- 32 Bit Registers Size
        N : integer := 5      -- 5 Bits to Address these registers
    );

Port ( 
   
    RegWrite      : in std_logic;
    ReadData1     : out std_logic_vector(M-1 downto 0);
    ReadData2     : out std_logic_vector(M-1 downto 0);
    ReadRegister1 : in std_logic_vector(N-1 downto 0);
    ReadRegister2 : in std_logic_vector(N-1 downto 0);
    WriteRegister : in std_logic_vector(N-1 downto 0);
    WriteData     : in std_logic_vector(M-1 downto 0);
    clk           : in std_logic; 
    reset         : in std_logic;
    Pc_in         : in std_logic_vector(M-1 downto 0);
    Pc_out        : out std_logic_vector(M-1 downto 0);
    Pc_write      : in std_logic




);
end REG_FILE;

architecture Behavioral of REG_FILE is
 type regfile is array(0 to 2**N-1) of std_logic_vector(M-1 downto 0);
 signal array_reg : regfile := (         x"00000000", -- $zero 
                                         x"00001000", -- $at
                                         x"00000000", -- $v0
                                         x"00000000", -- $v1
                                         x"00000000", -- $a0
                                         x"00000000", -- $a1
                                         x"00000000", -- $a2
                                         x"00000000", -- $a3
                                         x"00001011", -- $t0
                                         x"00000001", -- $t1
                                         x"00000001", -- $t2
                                         x"00001100", -- $t3 
                                         x"00000011", -- $t4
                                         x"00000231", -- $t5                                         
                                         x"00000000", -- $t6
                                         x"00000000", -- $t7
                                         x"00000101", -- $s0
                                         x"00000110", -- $s1
                                         x"00000000", -- $s2
                                         x"00000000", -- $s3
                                         x"00000000", -- $s4
                                         x"00000000", -- $s5
                                         x"00000000", -- $s6
                                         x"00000000", -- $s7
                                         x"00000000", -- $t8
                                         x"00000000", -- $t9
                                         x"00000000", -- $k0  
                                         x"00000000", -- $k1 
                                         x"00000000", -- $gp
                                                                -----pc (29)
                                          x"00000000", -- $sp                                         
                                         x"00000000", -- $fp
                                         x"00000000"); -- $ra
                              

begin

 process(clk, reset)    -- pulse on write
    begin
       
        if(reset = '1') then
            array_reg(28) <= x"00000000";
       
        elsif(rising_edge(clk)) then
            if(Pc_write = '1') then
                array_reg(28) <= Pc_in;
            end if;
            
            if(RegWrite = '1') then
                array_reg(TO_INTEGER(unsigned(WriteRegister))) <= WriteData;
            end if;
        end if;
    end process;
    
  
    
    ReadData1 <= array_reg(to_integer(unsigned(ReadRegister1)));
 
    ReadData2 <= array_reg(to_integer(unsigned(ReadRegister2)));
  
   
    Pc_out <= array_reg(28);
    



end Behavioral;
