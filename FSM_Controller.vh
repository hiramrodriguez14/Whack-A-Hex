library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Controller is
    Port (
        clk        : in STD_LOGIC;
        btn_up     : in STD_LOGIC;
        btn_down   : in STD_LOGIC;
        btn_left   : in STD_LOGIC;
        btn_right  : in STD_LOGIC;
        btn_center : in STD_LOGIC;
        timer_out  : in STD_LOGIC_VECTOR(4 downto 0);
        pos_out    : in STD_LOGIC_VECTOR(3 downto 0);
        random_hex : in STD_LOGIC_VECTOR(3 downto 0);
        lives      : inout STD_LOGIC_VECTOR(1 downto 0);
        score      : inout STD_LOGIC_VECTOR(13 downto 0);
        state_out  : out STD_LOGIC_VECTOR(2 downto 0);
        reset_dynamic : out STD_LOGIC -- ✅ Reset for Dynamic Clock
    );
end FSM_Controller;

architecture Behavioral of FSM_Controller is
    signal state : STD_LOGIC_VECTOR(2 downto 0) := "000"; 
    signal reset : STD_LOGIC := '0';  -- ✅ Internal reset signal

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- ✅ Generate `reset` when entering state "000"
            if state = "000" then  
                reset <= '1';  
            else  
                reset <= '0';  
            end if;

            -- ✅ FSM State Transitions
            if state = "000" then  
                state <= "001"; 
            elsif btn_center = '1' and state = "001" then  
                state <= "010";  
            elsif btn_up = '1' and state = "001" then  
                state <= "011";  
            elsif btn_down = '1' and state = "010" then  
                state <= "100";  
            elsif btn_up = '1' and state = "100" then  
                state <= "000";  
            elsif (btn_left = '1' or btn_right = '1') and state = "100" then  
                state <= "010";  
            elsif state = "010" then  
                if btn_center = '1' then
                    if pos_out = random_hex then
                        score <= std_logic_vector(unsigned(score) + 1);
                        reset_dynamic <= '1';  
                    else
                        if lives > "00" then
                            lives <= std_logic_vector(unsigned(lives) - 1);
                        end if;
                        reset_dynamic <= '1';
                    end if;
                end if;
                if timer_out = "00000" then
                    if lives > "00" then
                        lives <= std_logic_vector(unsigned(lives) - 1);
                    end if;
                    reset_dynamic <= '1';
                end if;
                if lives = "00" then
                    state <= "101"; 
                end if;
            elsif state = "101" then  
                if timer_out = "00000" then  
                    state <= "000";  
                end if;
            elsif state = "011" then  
                if timer_out = "00000" then  
                    state <= "001";  
                end if;
            end if;
        end if;
    end process;

    state_out <= state;

end Behavioral;
