library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_path is
    Port (
        -- control
        clk   : in STD_LOGIC;               
        reset : in STD_LOGIC;   
          
        -- main ports
        x_in : in std_logic_VECTOR     (31 downto 0);
        y_out : out STD_LOGIC_VECTOR(31 downto 0); 
        
        -- controlpath ports
        curr_state: in std_logic_vector(2 downto 0);
        x_incr    : in std_logic;
        x_eq_or_gt: out STD_LOGIC_VECTOR(1 downto 0);
        y_pass    : in STD_LOGIC 
    );
end data_path;

architecture Behavioral of data_path is
    signal reg_x, reg_y, next_x, next_y : STD_LOGIC_VECTOR(31 downto 0); -- Registers for inputs and result
    signal x_sq_s : STD_LOGIC_VECTOR(63 downto 0); -- Registers for inputs and result
    
begin

    y_out <= reg_x;
    
    process (clk, reset)
    begin
        if reset = '1' then
            reg_x <= (others => '0'); -- Reset register A
            reg_y <= (others => '0'); -- Reset register B
        elsif rising_edge(clk) then
            -- Update register values on clock edge
            reg_x <= next_x;
            reg_y <= next_y;
        end if;
    end process;
    
    -- multiply and compare
    process (reg_y, next_x, x_sq_s, reg_x)
    begin
        x_sq_s <= reg_x*reg_x;
   
        x_eq_or_gt <= "00"; -- default value
        if x_sq_s(31 downto 0) > reg_y then
            x_eq_or_gt <= "01";  -- A > B
        else 
            if (x_sq_s(31 downto 0) = reg_y) then
                x_eq_or_gt <= "10";  -- A <= B
            end if;
        end if;
    end process;
    
    -- muxes before the registers and the logic
    process (curr_state, y_pass, x_incr, x_in, reg_y, reg_x) 
    begin
        case curr_state is 
        when "000" =>
            if y_pass = '1' then
                next_y <= x_in;  -- take in the number to calcuate the sqrt
                next_x <= (others => '0'); -- reset the increment variable
            else
                next_y <= (others => '0');  -- reset the register 
                next_x <= reg_x;            -- hold the result 
            end if;
            
        when "001" =>
            next_y <= reg_y;
            if (x_incr = '1') then
                next_x <= reg_x + "00000000000000000000000000000001";
            else
                next_x <= reg_x;
            end if;
            
        when "010" =>
            next_y <= reg_y;
            next_x <= reg_x - "00000000000000000000000000000001";
            
        when others =>
            next_y <= reg_y;
            next_x <= reg_x;            
            
        end case;
    end process;
end Behavioral;
