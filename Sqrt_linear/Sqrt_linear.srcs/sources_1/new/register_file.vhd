library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registers is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- interface to axi lite controller
           -- write ports
           data_axi_i   : in  STD_LOGIC_VECTOR(31 downto 0);
           x_wr_en      : in  STD_LOGIC;
           start_wr_en  : in  STD_LOGIC;
           --read ports
           start_axi_o  : out STD_LOGIC;
           x_axi_o      : out STD_LOGIC_VECTOR(31 downto 0);
           y_axi_o      : out STD_LOGIC_VECTOR(31 downto 0);
           ready_axi_o  : out STD_LOGIC;
           
           --interface to the IP
           x_IP_o       : out STD_LOGIC_VECTOR(31 downto 0);
           y_IP_i       : in  STD_LOGIC_VECTOR(31 downto 0);
           start_IP_o   : out STD_LOGIC;
           ready_IP_i   : in  STD_LOGIC
           );
end registers;

architecture Behavioral of registers is
    signal x, y: STD_LOGIC_VECTOR(31 downto 0);
    signal start, ready : STD_LOGIC;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            x <= (others => '0');
            y <= (others => '0');
            start <= (others => '0');
            ready <= (others => '0');
        elsif rising_edge(clk) then
        
            ready <= ready_IP_i;
            y     <= y_IP_i;
            
            if x_wr_en = '1' then
                x <= data_axi_i;
            end if;
            if start_wr_en = '1' then
                start <= data_axi_i(0);
            end if;
            
        end if;
    end process;

    start_axi_o <= start;
    x_axi_o     <= x;
    y_axi_o     <= y;
    ready_axi_o <= ready;
    
    x_IP_o      <= x;
    start_IP_o  <= y;    
    
end Behavioral;

