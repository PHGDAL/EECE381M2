library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity de2servo is
    PORT(
		  CLOCK_50	: IN STD_LOGIC;
		  SW			: IN STD_LOGIC_VECTOR(7 downto 0);
		  KEY			: IN STD_LOGIC_VECTOR(3 downto 0);
        GPIO_1		: OUT STD_LOGIC_VECTOR(2 downto 0);
		  LEDG		: OUT STD_LOGIC_VECTOR(7 downto 0);
		  LEDR		: OUT STD_LOGIC_VECTOR(7 downto 0)		  
    );
end de2servo;

architecture Behavioral of de2servo is
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
            pos   : IN  STD_LOGIC_VECTOR(7 downto 0);
            servo : OUT STD_LOGIC
        );
    END COMPONENT;
    
    signal clk_out : STD_LOGIC := '0';
	 signal pos		 : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
begin
    servoclk_map: servoclk PORT MAP(
        clk => CLOCK_50,
		  reset => not KEY(3),
		  clk_out => clk_out
    );
    
    servopwm_map: servopwm PORT MAP(
        clk => clk_out,
		  reset => not KEY(3),
		  pos => pos,
		  servo => GPIO_1(0)
    );
	 
	 process(CLOCK_50)
	 begin
		if(rising_edge(CLOCK_50)) then
			if(unsigned(SW(7 downto 0)) < 80) then
				pos <= SW(7 downto 0);
				LEDR <= SW;
			end if;
		end if;
	 end process;
end Behavioral;