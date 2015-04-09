library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servopwm is
    PORT (
        clk   : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        pos   : IN  STD_LOGIC_VECTOR(8 downto 0);
        servo : OUT STD_LOGIC
    );
end servopwm;

architecture Behavioral of servopwm is
    -- Counter, from 0 to 2000.
    signal cnt : unsigned(11 downto 0);
    -- Temporal signal used to generate the PWM pulse.
    signal pwmi: unsigned(9 downto 0);
begin
    -- Minimum value should be 0.6ms.
    pwmi <= unsigned('0' & pos) + 39;
    -- Counter process, from 0 to 2000.
    counter: process (reset, clk) begin
        if (reset = '1') then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if (cnt = 2000) then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    -- Output signal for the servomotor.
    servo <= '1' when (cnt < pwmi) else '0';
end Behavioral;