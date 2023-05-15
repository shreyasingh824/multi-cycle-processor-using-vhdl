library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity MAIN_DATAPATH is
Port ( 
        clock         : in std_logic;
        reset       : in std_logic
);
end MAIN_DATAPATH;
architecture Behavioral of MAIN_DATAPATH is
     component FSM is
        Port  ( 
                clock       : in std_logic;
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
                IRWrite     : out std_logic);
    end component;
    
    component ALU is
          Port (
           a1 : in STD_LOGIC_VECTOR (31 downto 0);
           a2 : in STD_LOGIC_VECTOR (31 downto 0);
           aluControl : in STD_LOGIC_VECTOR (3 downto 0);  -- 6 operations
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
    end component;
    
    component ALU_CONTROL is
       port (

           funct : in STD_LOGIC_VECTOR (5 downto 0);
           AluOp : in STD_LOGIC_VECTOR(1 downto 0);
           Oprtn : out STD_LOGIC_VECTOR (3 downto 0)
 );
end component;
component ALU_OUT_REG is
 Port ( 
        clock : in std_logic;
        DataIn: in std_logic_vector(31 downto 0);
        DataOut : out std_logic_vector(31 downto 0)
 
        );
      
end component;
component INSTRUCTION_REG is
    Port ( clock : in STD_LOGIC;
           InstructionIn : in STD_LOGIC_VECTOR (31 downto 0);
           InstructionOut : out STD_LOGIC_VECTOR (31 downto 0);
           IRwrite : in STD_LOGIC);
end component;
component MUX2x1 is
        generic (
             N : integer :=32
             );
    Port ( input0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           input1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           Contro1 : in STD_LOGIC;
           MuxOut : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component MUX4x1 is
   generic (
             N : integer :=32
             );

    Port ( input0 : in STD_LOGIC_VECTOR ( N-1 downto 0);
           input1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           mux_control : in STD_LOGIC_VECTOR (1 downto 0);
           input2 : in STD_LOGIC_VECTOR (N-1 downto 0);
           input3 : in STD_LOGIC_VECTOR (N-1 downto 0);
         
           output : out STD_LOGIC_VECTOR (N-1 downto 0)
           );
end component;

component MERGED_MEMORY is
Port (     clock       : in std_logic;
           Address   : in std_logic_vector (31 downto 0);
           MemRead   : in std_logic;
           MemWrite  : in std_logic;
           WriteData : in std_logic_vector(31 downto 0);
           MemData   : out std_logic_vector (31 downto 0)

 );
end component;
component MEM_DATA_REG is
Port (
           clock     : in std_logic;
           DataIn  : in STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0));

end component;
component REG_FILE is
 generic (
        M : integer := 32;    -- 32 Bit Registers Size
        N : integer := 5      -- 5 Bits to Address these registers
    );

Port ( 
    ReadRegister1 : in std_logic_vector(N-1 downto 0);
    ReadRegister2 : in std_logic_vector(N-1 downto 0);
    WriteRegister : in std_logic_vector(N-1 downto 0);
    WriteData     : in std_logic_vector(M-1 downto 0);
    RegWrite      : in std_logic;
    ReadData1     : out std_logic_vector(M-1 downto 0);
    ReadData2     : out std_logic_vector(M-1 downto 0);
    clk           : in std_logic; -- Clock to update pc vaolue
    reset         : in std_logic;-- to reset pc value to o when reset is active
    Pc_in         : in std_logic_vector(M-1 downto 0);
    Pc_out        : out std_logic_vector(M-1 downto 0);
    Pc_write      : in std_logic

);
end component;
component SHIFT_LEFT_2 is
 generic(
        N: integer := 32
   );
Port (
    datain  : in std_logic_vector(N-1 downto 0);
    dataout : out std_logic_vector(N-1 downto 0)


 );
end component;
component SIGN_EXTENDER is
Port (
        signExtenIn:in std_logic_vector(15 downto 0) ;
        signOut: out std_logic_vector(31 downto 0)

);
end component;
component A is
Port (
           clock     : in std_logic;
           DataIn  : in STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0)

 );
end component;
component B is
Port (

           clock     : in std_logic;
           DataIn  : in STD_LOGIC_VECTOR (31 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0)
 );
end component;
  signal mux_1_out : std_logic_vector(31 downto 0);
    signal temp_b_out   : std_logic_vector(31 downto 0);
    signal mem_data     : std_logic_vector(31 downto 0);
    signal instruction  : std_logic_vector(31 downto 0);
    signal memory_data_register_out : std_logic_vector(31 downto 0);
    signal reg_dst      : std_logic;
    signal reg_write    : std_logic;
    signal alu_src_a    : std_logic;
    signal alu_src_b    : std_logic_vector(1 downto 0);
    signal alu_op       : std_logic_vector(1 downto 0);
    signal pc_source    : std_logic_vector(1 downto 0);
    signal pc_write_cond : std_logic;
    signal pc_write     : std_logic;
    signal i_or_d       : std_logic;
    signal mem_read     : std_logic;
    signal mem_write    : std_logic;
    signal mem_to_reg   : std_logic;
    signal ir_write     : std_logic;
    signal mux_2_out    : std_logic_vector(4 downto 0);
    signal mux_3_out    : std_logic_vector(31 downto 0);
    signal read_data1   : std_logic_vector(31 downto 0);
    signal read_data2   : std_logic_vector(31 downto 0);
    signal out_data_registerA   : std_logic_vector(31 downto 0);
    signal out_data_registerB   : std_logic_vector(31 downto 0);
    signal mux_4_out    : std_logic_vector(31 downto 0);
    signal mux_5_out    : std_logic_vector(31 downto 0);
    signal mux_6_out    : std_logic_vector(31 downto 0);
    signal alu_result      : std_logic_vector(31 downto 0);
    signal zero_out     : std_logic;
    signal sign_extend_ins  : std_logic_vector(31 downto 0);
    signal alu_register_out : std_logic_vector(31 downto 0);
    signal operation    : std_logic_vector(3 downto 0);
    signal shift_left1_out  : std_logic_vector(31 downto 0);
    signal shift_left2_out  : std_logic_vector(27 downto 0);
    signal shift_left2_in   : std_logic_vector(27 downto 0);
    signal jump_address     : std_logic_vector(31 downto 0);
    signal pc       : std_logic_vector(31 downto 0);
    signal pc_write_signal  :   std_logic := '1';
    
begin
memory : MERGED_MEMORY port map (  
           clock =>clock,
           Address  => mux_1_out,
           MemRead  =>mem_read,
           MemWrite => mem_write,
           WriteData=> temp_b_out,
            MemData  => mem_data

 );
 
 instr_reg : INSTRUCTION_REG  Port map (
           clock  => clock  ,
           InstructionIn => mem_data,
           InstructionOut => instruction,
           IRwrite => ir_write );

memory_data_reg :MEM_DATA_REG port map(
           clock  => clock,   
           DataIn =>mem_data,
           DataOut =>memory_data_register_out);
controller_unit  : FSM port map(
           clock          => clock,
           reset        => reset,
           Op           => instruction(31 downto 26),
           RegDst       => reg_dst,
           RegWrite     => reg_write,
           ALUSrcA      => alu_src_a,
           ALUSrcB      => alu_src_b,
           ALUOp        => alu_op,
           PCSource     => pc_source,
           PCWriteCond  => pc_write_cond,
           PCWrite      => pc_write,
           IorD         => i_or_d,
           MemRead      => mem_read,
           MemWrite     => mem_write,
           MemtoReg     => mem_to_reg,
           IRWrite      => ir_write
    );
     pc_write_signal <= ( zero_out and pc_write_cond ) or pc_write;
     
   register_file : REG_FILE port map(
    ReadRegister1 =>instruction(25 downto 21),
    ReadRegister2 =>instruction(20 downto 16),
    WriteRegister =>mux_2_out,
    WriteData  =>   mux_3_out,
    RegWrite    => reg_write,
    ReadData1  =>read_data1,
    ReadData2    =>read_data2,
    clk         =>clock,
    reset        =>reset,
    Pc_in       =>mux_6_out,
    Pc_out      =>pc,
    Pc_write     =>pc_write_signal
    );
alumapping : ALU port map(
           a1=>mux_4_out,
           a2=>mux_5_out,
           aluControl=>operation,
           ALUResult=>alu_result,
           Zero => zero_out



);
aluControl : ALU_CONTROL port map(
           funct => instruction(5 downto 0),
           AluOp =>alu_op,
           Oprtn => operation
           );

regA : A port map(
           clock=>clock,    
           DataIn => read_data1,
           DataOut =>out_data_registerA


);     
regB : B port map(
           clock=>clock,    
           DataIn => read_data2,
           DataOut =>out_data_registerB


);  
sign_ext : SIGN_EXTENDER port map(
               signExtenIn => instruction(15 downto 0),
                signOut  => sign_extend_ins
                );
                
aluOUTREG :ALU_OUT_REG port map(
        clock =>clock,
        DataIn =>alu_result,
        DataOut =>alu_register_out
        
        );
        
   Ist_shift_left_2 : SHIFT_LEFT_2 generic map ( N => 32 ) port map(
        datain => sign_extend_ins,
    dataout  => shift_left1_out
    );
      shift_left2_in <= std_logic_vector(unsigned("00" & instruction(25 downto 0)));
    
     IInd_shift_left_2 : SHIFT_LEFT_2   generic map ( N => 28 ) port map(
        datain => shift_left2_in,
    dataout  =>  shift_left2_out
    );
    mux1  : MUX2x1 generic map ( N => 32 ) port map(
           input0=>pc,
           input1=>alu_register_out,
           Contro1 => i_or_d,
           MuxOut=>mux_1_out
           );
           
    mux2   : MUX2x1 generic map ( N => 5 ) port map(
           input0=>instruction(20 downto 16),
           input1=>instruction(15 downto 11),
           Contro1 =>reg_dst,
           MuxOut=> mux_2_out
           );
     mux3   : MUX2x1 generic map ( N => 32 ) port map(
           input0=>alu_register_out,
           input1=>memory_data_register_out,
           Contro1 =>mem_to_reg,
           MuxOut=> mux_3_out
           );
     mux4   :  MUX2x1 generic map ( N => 32 ) port map(
           input0=>pc,
           input1=>out_data_registerA,
           Contro1 => alu_src_a,
           MuxOut=> mux_4_out
           );
           
     mux5   :  MUX4x1  generic map ( N => 32 ) port map(
            input0=>out_data_registerB,
           input1 => x"00000004",
           input2 =>sign_extend_ins,
           input3=>shift_left1_out,
           mux_control=> alu_src_b,
           output =>mux_5_out
           );
           
    jump_address <=  shift_left2_out & pc(31 downto 28);
    mux6    :   MUX4x1  generic map ( N => 32 ) port map(    
           
          input0=>alu_result,
          input1 =>alu_register_out,
           input2 =>jump_address,
       input3 =>x"00000000",
       mux_control  =>pc_source,
       output =>mux_6_out
     
     
     
    );
     
end Behavioral;
