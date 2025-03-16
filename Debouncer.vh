library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is --Los 5 botone spasan por aqui y el out put de este modulo es el que s eles manda a los modulos que necesiten el boton
    Port (
        clk     : in STD_LOGIC;  -- Reloj de 100MHz
        btn_in  : in STD_LOGIC;  -- Entrada del botón con rebote
        btn_out : out STD_LOGIC  -- Salida del botón estable
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal shift_reg : STD_LOGIC_VECTOR(18 downto 0) := (others => '0'); -- 19 bits para 5ms
    signal btn_out_reg : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Desplazar valores en el registro
            shift_reg <= shift_reg(17 downto 0) & btn_in;

            -- Si todos los bits son 1s → Botón presionado
            if shift_reg = "1111111111111111111" then
                btn_out_reg <= '1';
            -- Si todos los bits son 0s → Botón liberado
            elsif shift_reg = "0000000000000000000" then
                btn_out_reg <= '0';
            end if;
        end if;
    end process;
    
    btn_out <= btn_out_reg; -- Salida estable
end Behavioral;
