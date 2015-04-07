library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity de2servo is
    PORT(
		  CLOCK_50	: IN STD_LOGIC;
		  SW			: IN STD_LOGIC_VECTOR(15 downto 0);
		  KEY			: IN STD_LOGIC_VECTOR(3 downto 0);
        GPIO_1		: INOUT STD_LOGIC_VECTOR(4 downto 0);
		  LEDG		: OUT STD_LOGIC_VECTOR(2 downto 0)
    );
end de2servo;

architecture Behavioral of de2servo is
    COMPONENT servolinked
        PORT(
            clk    : in STD_LOGIC;
            reset  : in STD_LOGIC;
            pos	 : in STD_LOGIC_VECTOR(7 downto 0);
				servo	 : out STD_LOGIC
        );
    END COMPONENT;
    
    signal SW1	: STD_LOGIC_VECTOR(7 downto 0);
	 signal SW2 : STD_LOGIC_VECTOR(7 downto 0);
	 signal coordx : STD_LOGIC_VECTOR(7 downto 0);
	 signal coordy : STD_LOGIC_VECTOR(7 downto 0);
begin
    servoVertical: servolinked PORT MAP(
        clk => CLOCK_50,
		  reset => not KEY(3),
		  pos => SW1,
		  servo => GPIO_1(0)
    );
	 
    servoHorizontal: servolinked PORT MAP(
        clk => CLOCK_50,
		  reset => not KEY(3),
		  pos => SW2,
		  servo => GPIO_1(1)
    );
	 
	 process(CLOCK_50)
	 begin
		if(rising_edge(CLOCK_50)) then
		--	 if(unsigned(SW(7 downto 0)) < 80) then
		--		SW1 <= SW(7 downto 0);
		--	 end if;
			 
		--	 if(unsigned(SW(15 downto 8)) < 80) then
		--		SW2 <= SW(15 downto 8);
		--	 end if;		
		end if;
	 end process;
	 
	 process(GPIO_1(2))
	 begin
		if(rising_edge(GPIO_1(2))) then
		-- Update X coordinate
			coordx(0) <= GPIO_1(3);
			coordx(1) <= coordx(0);
			coordx(2) <= coordx(1);
			coordx(3) <= coordx(2);
			coordx(4) <= coordx(3);
			coordx(5) <= coordx(4);
			coordx(6) <= coordx(5);
			coordx(7) <= coordx(6);
		-- Update Y coordinate
			coordy(0) <= GPIO_1(4);
			coordy(1) <= coordy(0);
			coordy(2) <= coordy(1);
			coordy(3) <= coordy(2);
			coordy(4) <= coordy(3);
			coordy(5) <= coordy(4);
			coordy(6) <= coordy(5);
			coordy(7) <= coordy(6);
		end if;
	 end process;
	 
	 
end Behavioral;