library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_path is
    Port (
        -- control 
        clk : in STD_LOGIC;        -- Clock input
        start : in STD_LOGIC;    -- Input signal to trigger state transition
        reset : in STD_LOGIC;      -- Input signal to reset the state machine
        ready : out std_logic;
        
        -- data_path signals
        x_eq_or_gt: in STD_LOGIC_VECTOR(1 downto 0);
        y_pass    : out STD_LOGIC; -- Output representing the current state
        state_out : out STD_LOGIC_VECTOR(2 downto 0);  -- Output representing the current state
        x_incr    : out std_logic
    );
end control_path;

architecture Behavioral of control_path is
    type StateType is (idle, n_check, lower, final);
    signal current_state, next_state : StateType;
begin
    -- State register and next state logic
    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= idle;  -- Reset to initial state
        elsif rising_edge(clk) then
            current_state <= next_state;  -- Update state on clock edge
        end if;
    end process;

    -- State transition logic
    process (current_state, start, x_eq_or_gt)
    begin   
       x_incr <= '0';-- default values
       y_pass <= '0';
       ready  <= '0';
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
                next_state <= final; 
            when final =>
                next_state <= idle;    
            when others =>
                next_state <= idle;       
        end case;
    end process;

    -- Output the current state
    process (current_state)
    begin
        case current_state is
            when idle =>    
                state_out <= "000";
            when n_check =>
                state_out <= "001";
            when lower =>
                state_out <= "010";
            when final =>
                state_out <= "011";
            when others =>
                state_out <= "111";  -- Handle undefined states
        end case;
    end process;

end Behavioral;
