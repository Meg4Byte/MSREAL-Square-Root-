library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sqrt_top_TB is
end sqrt_top_TB;

architecture Behavioral of sqrt_top_TB is
    -- Component declaration for the unit under test (UUT)
    component sqrt_top is
        Port (
            clk        : in STD_LOGIC;
            reset      : in STD_LOGIC;
            start      : in STD_LOGIC;
            x_in       : in std_logic_VECTOR(31 downto 0);
            y_out      : out std_logic_VECTOR(31 downto 0);
            ready      : out std_logic
        );
    end component;

    -- Signals for testbench stimulus and monitoring
    signal clk_tb : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal start_tb : STD_LOGIC := '0';
    signal x_in_tb : std_logic_VECTOR(31 downto 0) := (others => '0');
    signal ready_tb : std_logic;
    signal result_out_tb : std_logic_VECTOR(31 downto 0);

begin
    -- Instantiate the unit under test (UUT)
    UUT : sqrt_top
        port map (
            clk => clk_tb,
            reset => reset_tb,
            start => start_tb,
            x_in => x_in_tb,
            ready => ready_tb,
            y_out => result_out_tb
        );

    -- Clock process for generating clock signal
    clk_process : process
    begin
        clk_tb <= '0';
        wait for 5 ns;
        clk_tb <= '1';
        wait for 5 ns;
    end process clk_process;

    -- Stimulus process for applying inputs and observing outputs
    stimulus_process : process
    begin
        -- Apply reset and initial values
        reset_tb <= '1';
        start_tb <= '0';
        x_in_tb <= (others => '0');

        -- Wait for a few clock cycles
        wait for 10 ns;
        
        -- Release reset
        reset_tb <= '0';

        -- Apply inputs and observe outputs
        wait for 10 ns;
        start_tb <= '1';  -- Trigger state transition
        x_in_tb <= std_logic_vector(to_unsigned(16, 32));  -- Example input
        
        wait for 10 ns;
        start_tb <= '0';  -- Trigger state transition
        -- Wait for some time to observe outputs
        wait for 100 ns;
        start_tb <= '1';  -- Trigger state transition
        x_in_tb <= std_logic_vector(to_unsigned(15, 32));  -- Example input
        wait for 10 ns;
        start_tb <= '0';  -- Trigger state transition
        wait for 100 ns;
        start_tb <= '1';  -- Trigger state transition
        x_in_tb <= std_logic_vector(to_unsigned(0, 32));  -- Example input
        wait for 10 ns;
        start_tb <= '0';  -- Trigger state transition
        wait for 100 ns;
        

        wait;
    end process stimulus_process;

end Behavioral;
