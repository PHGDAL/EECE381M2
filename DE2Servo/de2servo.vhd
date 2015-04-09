library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity de2servo is
    PORT(
		  CLOCK_50	: IN STD_LOGIC;
		  SW			: IN STD_LOGIC_VECTOR(15 downto 0);
		  KEY			: IN STD_LOGIC_VECTOR(3 downto 0);
        GPIO_1		: INOUT STD_LOGIC_VECTOR(5 downto 0);
		  LEDG		: OUT STD_LOGIC_VECTOR(8 downto 0);
		  LEDR		: OUT STD_LOGIC_VECTOR(8 downto 0)
    );
end de2servo;

architecture Behavioral of de2servo is
    COMPONENT servolinked
        PORT(
            clk    : in STD_LOGIC;
            reset  : in STD_LOGIC;
            pos	 : in STD_LOGIC_VECTOR(8 downto 0);
				servo	 : out STD_LOGIC
        );
    END COMPONENT;
	 
    signal Vpos	: STD_LOGIC_VECTOR(8 downto 0);
	 signal Hpos	: STD_LOGIC_VECTOR(8 downto 0);
	 signal coordx : STD_LOGIC_VECTOR(8 downto 0);
	 signal coordy : STD_LOGIC_VECTOR(8 downto 0);
	 signal Abbey	: STD_LOGIC;
	
	 type t_state is (idle, ready);
begin
    servoVertical: servolinked PORT MAP(
        clk => CLOCK_50,
		  reset => not KEY(3),
		  pos => Vpos,
		  servo => GPIO_1(0)
    );
	 
    servoHorizontal: servolinked PORT MAP(
        clk => CLOCK_50,
		  reset => not KEY(3),
		  pos => Hpos,
		  servo => GPIO_1(1)
    );
	 
	 
	 process(CLOCK_50)
	 variable current_state :	t_state	:= idle;
	 variable next_state		:	t_state	:= idle;
	 variable varX				:	unsigned(8 downto 0);
	 variable varY				:	unsigned(8 downto 0);
	 variable pvarX				:	unsigned(8 downto 0);
	 variable pvarY				:	unsigned(8 downto 0);
	 begin
		if(rising_edge(CLOCK_50)) then		
			case current_state is
			
			when idle =>
				if(GPIO_1(2) = '1') then
					Abbey <= '1';
				end if;
			
				if(GPIO_1(5) = '1' and Abbey = '1') then
					next_state := ready;
				else
					next_state := idle;
				end if;			
				
			when ready =>
				--pvarX := varX;
				--pvarY := varY;
				varX := unsigned(coordx);
				varY := unsigned(coordy);
				if(varX = 0 and varY = 0) then
				-- Idle
				else
					if(varX > 240) then
					-- Move Right
						if(unsigned(Hpos) < 75) then
							Hpos <= std_logic_vector(unsigned(Hpos) + 1);
						end if;
					end if;
					if(varX < 150) then
					-- Move Left
						if(unsigned(Hpos) > 5) then
							Hpos <= std_logic_vector(unsigned(Hpos) - 1);
						end if;
					end if;
					
					if(varY < 100) then
					-- Move Up
						if(unsigned(Vpos) < 54) then
							--Vpos <= std_logic_vector(unsigned(Vpos) + 5);
						end if;
					end if;
					if(varY > 140) then
					-- Move Down
						if(unsigned(Vpos) > 25) then
							--Vpos <= std_logic_vector(unsigned(Vpos) - 5);
						end if;
					end if;
				end if;
				Abbey <= '0';
				next_state := idle;
			end case;
			current_state := next_state;
			
		end if;
	 end process;
 
	 
	 
	 
	 process(GPIO_1(2))
	 begin
		if(rising_edge(GPIO_1(2))) then
		-- Update X coordinate
			coordx(8) <= GPIO_1(3);
			coordx(7) <= coordx(8);
			coordx(6) <= coordx(7);
			coordx(5) <= coordx(6);
			coordx(4) <= coordx(5);
			coordx(3) <= coordx(4);
			coordx(2) <= coordx(3);
			coordx(1) <= coordx(2);
			coordx(0) <= coordx(1);
		-- Update Y coordinate
			coordy(8) <= GPIO_1(4);
			coordy(7) <= coordy(8);
			coordy(6) <= coordy(7);
			coordy(5) <= coordy(6);
			coordy(4) <= coordy(5);
			coordy(3) <= coordy(4);
			coordy(2) <= coordy(3);
			coordy(1) <= coordy(2);
			coordy(0) <= coordy(1);
		end if;
	 end process;
	 
	 
end Behavioral;