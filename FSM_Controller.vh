library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Controller is
    Port (
        clk           : in STD_LOGIC;
        reset         : in STD_LOGIC;
        btn_up        : in STD_LOGIC;
        btn_down      : in STD_LOGIC;
        btn_left      : in STD_LOGIC;
        btn_right     : in STD_LOGIC;
        btn_center    : in STD_LOGIC; -- ✅ Para seleccionar HEX
        timer_out     : in STD_LOGIC_VECTOR(4 downto 0); -- ✅ Timer de 30s
        pos_out       : in STD_LOGIC_VECTOR(3 downto 0); -- ✅ Posición del jugador
        random_hex    : in STD_LOGIC_VECTOR(3 downto 0); -- ✅ Número HEX
        lives         : inout STD_LOGIC_VECTOR(1 downto 0); -- ✅ Cantidad de vidas
        score         : inout STD_LOGIC_VECTOR(13 downto 0); -- ✅ Score actual
        state_out     : out STD_LOGIC_VECTOR(2 downto 0); -- ✅ Estado actual
        reset_dynamic : out STD_LOGIC -- ✅ Señal para resetear `clk_dynamic`
    );
end FSM_Controller;

architecture Behavioral of FSM_Controller is
    signal state : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- ✅ Estado inicial (INIT)
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- ✅ RESET MANUAL
            if reset = '1' then
                state <= "000"; 
                lives <= "11"; -- 🔄 Reinicia vidas a 3
                score <= "00000000000000"; -- 🔄 Reinicia score a 0

            -- ✅ INIT (000) -> IDLE (001)
            elsif state = "000" then
                state <= "001"; 

            -- ✅ IDLE (001) -> PLAY (010)
            elsif btn_center = '1' and state = "001" then
                state <= "010"; -- 🔥 INICIA EL TIMER Y SE GENERA UN HEX RANDOM

            -- ✅ IDLE (001) -> HIGH_SCORE (011)
            elsif btn_up = '1' and state = "001" then
                state <= "011"; 

            -- ✅ PLAY (010) -> PAUSE (100)
            elsif btn_down = '1' and state = "010" then
                state <= "100"; 

            -- ✅ PAUSE (100) -> RESET si presiona btn_up
            elsif btn_up = '1' and state = "100" then
                state <= "000"; 

            -- ✅ PAUSE (100) -> PLAY si presiona btn_left o btn_right
            elsif (btn_left = '1' or btn_right = '1') and state = "100" then
                state <= "010"; -- 🔥 REANUDA EL JUEGO

            -- ✅ Lógica Clave en `PLAY (010)`
            elsif state = "010" then
                -- 🔥 Si el jugador presiona `btn_center`
                if btn_center = '1' then
                    if pos_out = random_hex then
                        -- ✅ Acierta: Incrementa `score` y reinicia `clk_dynamic`
                        score <= std_logic_vector(unsigned(score) + 1);
                        reset_dynamic <= '1'; -- 🔄 Reiniciar `clk_dynamic`
                    else
                        -- ❌ Falla: Resta 1 vida y reinicia `clk_dynamic`
                        if lives > "00" then
                            lives <= std_logic_vector(unsigned(lives) - 1);
                        end if;
                        reset_dynamic <= '1';
                    end if;
                end if;

                -- 🔥 Si `timer_out` llega a `00000`, pierde una vida y reinicia `clk_dynamic`
                if timer_out = "00000" then
                    if lives > "00" then
                        lives <= std_logic_vector(unsigned(lives) - 1);
                    end if;
                    reset_dynamic <= '1';
                end if;

                -- 🔥 Si las vidas llegan a `0`, pasar a `CURRENT_SCORE (101)`
                if lives = "00" then
                    state <= "101"; 
                end if;

            -- ✅ CURRENT_SCORE (101) muestra por 30s, luego va a RESET
            elsif state = "101" then
                if timer_out = "00000" then -- ✅ 30s han pasado
                    state <= "000"; -- 🔥 REGRESA A RESET
                end if;
            
            -- ✅ HIGH_SCORE (011) muestra por 30s, luego va a IDLE
            elsif state = "011" then
                if timer_out = "00000" then -- ✅ 30s han pasado
                    state <= "001"; -- 🔥 REGRESA A IDLE
                end if;
            end if;
        end if;
    end process;

    -- ✅ Salida del estado actual
    state_out <= state;
end Behavioral;
