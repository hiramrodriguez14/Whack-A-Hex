library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Score_Storage is
end tb_Score_Storage;

architecture testbench of tb_Score_Storage is
    signal clk         : STD_LOGIC := '0';
    signal reset       : STD_LOGIC := '0';
    signal game_over   : STD_LOGIC := '0';
    signal increment   : STD_LOGIC := '0';
    signal current_score : STD_LOGIC_VECTOR(13 downto 0);
    signal high_score : STD_LOGIC_VECTOR(13 downto 0);

    component Score_Storage
        Port (
            clk         : in STD_LOGIC;
            reset       : in STD_LOGIC;
            game_over   : in STD_LOGIC;
            increment   : in STD_LOGIC;
            current_score : out STD_LOGIC_VECTOR(13 downto 0);
            high_score : out STD_LOGIC_VECTOR(13 downto 0)
        );
    end component;
begin
    -- Instanciar Score Storage
    UUT: Score_Storage port map (
        clk => clk,
        reset => reset,
        game_over => game_over,
        increment => increment,
        current_score => current_score,
        high_score => high_score
    );

    -- Proceso de reloj (50 MHz → ciclo de 10ns)
    process
    begin
        while now < 500 ms loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Proceso de prueba
    process
    begin
        -- **1️⃣ Reset del puntaje**
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- **2️⃣ Aumentar puntaje hasta 10**
        for i in 1 to 10 loop
            increment <= '1';
            wait for 50 ns;
            increment <= '0';
            wait for 50 ns;
        end loop;

        -- **3️⃣ Finalizar juego y verificar High Score**
        game_over <= '1';
        wait for 50 ns;
        game_over <= '0';

        -- **4️⃣ Jugar otra partida con un puntaje mayor**
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        for i in 1 to 15 loop
            increment <= '1';
            wait for 50 ns;
            increment <= '0';
            wait for 50 ns;
        end loop;

        -- **5️⃣ Finalizar juego y verificar que el High Score se actualiza**
        game_over <= '1';
        wait for 50 ns;
        game_over <= '0';

        -- **6️⃣ Intentar sobrepasar 9999**
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        for i in 1 to 10000 loop  -- Intentamos ir más allá de 9999
            increment <= '1';
            wait for 50 ns;
            increment <= '0';
            wait for 50 ns;
        end loop;

        -- **7️⃣ Finalizar juego, pero el score no debe haber pasado de 9999**
        game_over <= '1';
        wait for 50 ns;
        game_over <= '0';

        wait;
    end process;
end testbench;
