library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Controller is
    Port (
        clk           : in STD_LOGIC;
        btn_up        : in STD_LOGIC;
        btn_down      : in STD_LOGIC;
        btn_left      : in STD_LOGIC;
        btn_right     : in STD_LOGIC;
        btn_center    : in STD_LOGIC;  
        timer_out     : in STD_LOGIC_VECTOR(4 downto 0);
        pos_out       : in STD_LOGIC_VECTOR(3 downto 0);
        random_hex    : in STD_LOGIC_VECTOR(3 downto 0);
        lives         : out STD_LOGIC_VECTOR(1 downto 0);
        increment     : out STD_LOGIC;
        state_out     : out STD_LOGIC_VECTOR(2 downto 0);
        reset_out     : out STD_LOGIC;  
        reset_dynamic : out STD_LOGIC  
    );
end FSM_Controller;

architecture Behavioral of FSM_Controller is
    signal state : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal lives_reg : STD_LOGIC_VECTOR(1 downto 0) := "11";
    signal reset_sig : STD_LOGIC := '0';
    signal increment_sig : STD_LOGIC := '0';
    signal reset_dynamic_sig : STD_LOGIC := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then
            increment_sig <= '0';
            reset_sig <= '0'; 
            reset_dynamic_sig <= '0'; 

            if state = "000" then
                lives_reg <= "11"; 
                reset_sig <= '1';
                state <= "001"; 
            end if;

            if btn_center = '1' and state = "001" then
                state <= "010";

            elsif btn_down = '1' and state = "001" then
                state <= "011";

            elsif btn_up = '1' and state = "010" then
                state <= "100";

            elsif btn_up = '1' and state = "100" then
                state <= "000";

            elsif (btn_left = '1' or btn_right = '1') and state = "100" then
                state <= "010";

            elsif state = "010" then
                if btn_center = '1' then
                    if pos_out = random_hex then
                        increment_sig <= '1';
                        reset_dynamic_sig <= '1';
                    else
                        if lives_reg > "00" then
                            lives_reg <= std_logic_vector(unsigned(lives_reg) - 1);
                        end if;
                        reset_dynamic_sig <= '1';
                    end if;
                end if;

                if timer_out = "00000" then
                    if lives_reg > "00" then
                        lives_reg <= std_logic_vector(unsigned(lives_reg) - 1);
                    end if;
                    reset_dynamic_sig <= '1';
                end if;

                if lives_reg = "00" then
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
    reset_out <= reset_sig;
    increment <= increment_sig;
    reset_dynamic <= reset_dynamic_sig;
    lives <= lives_reg;

end Behavioral;
