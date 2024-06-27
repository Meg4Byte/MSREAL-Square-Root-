library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_path is
    Port (
        -- control 
        clk   : in STD_LOGIC;       -- Clock input
        start : in STD_LOGIC;       -- Input signal to trigger state transition
        reset : in STD_LOGIC;       -- Input signal to reset the state machine
        ready : out std_logic;      -- Output signal to init system (ready signal)
        
        -- data_path signals
        x_eq_or_gt : in STD_LOGIC_VECTOR(1 downto 0);   -- Input comparison result
        y_pass     : out STD_LOGIC;                     -- Output signal to pass the state
        state_out  : out STD_LOGIC_VECTOR(2 downto 0);  -- Output representing the current state
        x_incr     : out std_logic                      -- Output to increment x
    );

end control_path;

architecture Behavioral of control_path is

    -- Here we define state types , in the final version 4 states are used (It is possible to make 3 states also)
    -- We also define signals for current and next state

    type StateType is (idle, n_check, lower, final);
    signal current_state, next_state : StateType;

begin
    -- State register and next state logic

    process (clk, reset)
    begin

        -- Reset to initial state (idle state)

        if reset = '1' then
            current_state <= idle;

        -- Update state on the rising clock edge

        elsif rising_edge(clk) then
            current_state <= next_state;

        end if;

    end process;

    -- State transition logic

    process (current_state, start, x_eq_or_gt)
    begin   

        --Define initial (default ) output values

       x_incr <= '0
       y_pass <= '0';
       ready  <= '0';

       -- This part models FSM logic and transitions
    case current_state is
            when idle =>
                if start = '1' then
                    next_state <= n_check; 
                    y_pass <= '1';

                else
                    next_state <= idle;  
                    ready  <= '1';

                end if;

            when n_check =>
                if x_eq_or_gt = "10" then
                    next_state <= final;  

                else if x_eq_or_gt = "01" then
                    next_state <= lower;  

                else 
                   next_state <= n_check;
                   x_incr <= '1';

                end if;
                end if;
            when lower =>
                next_state <= final;            -- move to final

            when final =>                       -- move to idle (end of calculations)
                next_state <= idle;

            when others =>                      -- case for undef state , just remain in idle
                next_state <= idle;

        end case;
    end process;

        -- Output the current state as a 3-bit vector
    process (current_state)
    begin
        case current_state is
            when idle =>    
                state_out <= "000";         -- idle = 0

            when n_check =>
                state_out <= "001";         -- n_check = 1

            when lower =>
                state_out <= "010";         -- state_out = 2

            when final =>
                state_out <= "011";         -- final = 3

            when others =>
                state_out <= "111";         -- handle undefined states (7)

        end case;
    end process;

end Behavioral;
