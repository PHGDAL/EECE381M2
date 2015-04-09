library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servolinked is
    PORT(
		  clk			: IN STD_LOGIC;
		  pos			: IN STD_LOGIC_VECTOR(8 downto 0);
		  reset		: IN STD_LOGIC;
        servo		: OUT STD_LOGIC	  
    );
end servolinked;

architecture Behavioral of servolinked is
    COMPONENT servoclk
        PORT(
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            clk_out: out STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT servopwm
        PORT (
            clk   : IN  STD_LOGIC;
            reset : IN  STD_LOGIC;
            pos   : IN  STD_LOGIC_VECTOR(8 downto 0);
            servo : OUT STD_LOGIC
        );
    END COMPONENT;
    
    signal clk_out : STD_LOGIC := '0';
begin
    servoclk_map: servoclk PORT MAP(
        clk => clk,
		  reset => reset,
		  clk_out => clk_out
    );
    
    servopwm_map: servopwm PORT MAP(
        clk => clk_out,
		  reset => reset,
		  pos => pos,
		  servo => servo
    );
end Behavioral;