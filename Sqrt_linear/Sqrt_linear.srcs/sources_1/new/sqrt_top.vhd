library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sqrt_top is
    Port (
        -- control
        clk        : in STD_LOGIC;               
        reset      : in STD_LOGIC;      
        start      : in STD_LOGIC;  
        ready      : out std_logic;
        
        -- main ports
        x_in       : in std_logic_VECTOR(31 downto 0);
        y_out      : out std_logic_VECTOR(31 downto 0) -- Output result (32 bits)
    );
end sqrt_top;

architecture Behavioral of sqrt_top is
    -- Component declarations
    component data_path is
        Port (
            clk   : in STD_LOGIC;               
            reset : in STD_LOGIC;      
            x_in : in std_logic_VECTOR     (31 downto 0);
            y_out : out STD_LOGIC_VECTOR(31 downto 0); 
            curr_state: in std_logic_vector(2 downto 0);
            x_incr    : in std_logic;
            x_eq_or_gt: out STD_LOGIC_VECTOR(1 downto 0);
            y_pass    : in STD_LOGIC  -- Output representing the current state
        );
    end component;

    component control_path is
        Port (
            clk : in STD_LOGIC;        -- Clock input
            start : in STD_LOGIC;    -- Input signal to trigger state transition
            reset : in STD_LOGIC;      -- Input signal to reset the state machine
            x_eq_or_gt: in STD_LOGIC_VECTOR(1 downto 0);
            ready : out std_logic;
            y_pass : out STD_LOGIC; -- Output representing the current state
            x_incr    : out std_logic;
            state_out : out STD_LOGIC_VECTOR(2 downto 0)  -- Output representing the current state
        );
    end component;

    -- Signals for connecting components
    signal x_eq_or_gt_internal : std_logic_VECTOR(1 downto 0);
    signal y_pass_internal : std_logic;
    signal state_out_internal : std_logic_VECTOR(2 downto 0);
    signal x_incr_internal : std_logic;

begin
    -- Instantiate data_path
    data_path_inst : data_path
        port map (
            clk => clk,
            reset => reset,
            x_in => x_in,
            curr_state => state_out_internal,
            x_incr => x_incr_internal,
            y_out => y_out,
            x_eq_or_gt => x_eq_or_gt_internal,
            y_pass => y_pass_internal
        );

    -- Instantiate control_path
    control_path_inst : control_path
        port map (
            clk => clk,
            start => start,  -- Assuming x_incr is used as start signal
            reset => reset,
            x_eq_or_gt => x_eq_or_gt_internal,
            y_pass => y_pass_internal,
            x_incr => x_incr_internal,
            ready => ready,
            state_out => state_out_internal
        );

end Behavioral;
