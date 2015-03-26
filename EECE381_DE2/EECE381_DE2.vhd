library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EECE381_DE2 is
	port(
	-- Inputs
		CLOCK_50 : in 	std_logic;							-- 50MHz clock
		KEY		: in 	std_logic_vector(3 downto 0);	-- Push buttons (reset is used here)
		SW			: in	std_logic_vector(17 downto 0);-- Switches to set motor PWMs
		GPIO_1	: in	std_logic_vector(2 downto 0);	-- GPIO_1 control
		
	-- Outputs
		LEDG		: out std_logic_vector(7 downto 0);	-- Green LEDs: For visual aid
		LEDR		: out std_logic_vector(2 downto 0);	-- Red LEGs: For visual aid
		HEX0		: out std_logic_vector(6 downto 0);	-- Percentage indicator of Servo PWM
	   HEX1		: out std_logic_vector(6 downto 0);	-- Percentage indicator of Servo PWM
		HEX2		: out	std_logic_vector(6 downto 0);	-- Percentage indicator of Servo PWM2
		HEX3		: out	std_logic_vector(6 downto 0);	-- Percentage indicator of Servo PWM2
		HEX4		: out	std_logic_vector(6 downto 0); -- Just clearing the rest
		HEX5		: out	std_logic_vector(6 downto 0);
		HEX6		: out	std_logic_vector(6 downto 0);
		HEX7		: out	std_logic_vector(6 downto 0)

	);
end EECE381_DE2;

architecture BEHAVIOURAL of EECE381_DE2 is
	-- Components
	component EECE381_NUMERIC_HEX is
	port(
	   	NUM	: in  std_logic_vector(3 downto 0); -- Number to be displayed
	   	SEG7	: out std_logic_vector(6 downto 0)  -- Seven segment display to use
	);
	end component;
	
	-- Signals
	signal reset		:	std_logic;
	signal PWM			:	std_logic_vector(7 downto 0);
	signal PWM2			:	std_logic_vector(7 downto 0);
	signal TenDigit	:	std_logic_vector(3 downto 0);
	signal UniDigit	:	std_logic_vector(3 downto 0);
	signal TenDigit2	:	std_logic_vector(3 downto 0);
	signal UniDigit2	:	std_logic_vector(3 downto 0);
	
begin
	-- Components
	HexDisplay0 : EECE381_NUMERIC_HEX port map(	-- HEX display 0 (Unit digit)			-----|
	   	NUM => UniDigit(3 downto 0),																	--|
	   	SEG7 => HEX0																						--|
	);																												--|	LEDG(0) PWM
	HexDisplay1 : EECE381_NUMERIC_HEX port map(	-- HEX display 1 (Tens digit)				--|
	   	NUM => TenDigit(3 downto 0),																	--|
	   	SEG7 => HEX1																					-----|
	);
	
	HexDisplay2 : EECE381_NUMERIC_HEX port map(	-- HEX display 2 (Unit digit)			-----|
	   	NUM => UniDigit2(3 downto 0),																	--|
	   	SEG7 => HEX2																						--|
	);																												--|	LEDG(1) PWM2
	HexDisplay3 : EECE381_NUMERIC_HEX port map(	-- HEX display 3 (Tens digit)				--|
	   	NUM => TenDigit2(3 downto 0),																	--|
	   	SEG7 => HEX3																					-----|
	);
		
	-- Core Operations
	reset	<=	not KEY(0);					-- Set reset button
	-- PWM
	TenDigit <= SW(7 downto 4);		-- Set Tens switches
	UniDigit <= SW(3 downto 0);		-- Set Units switches
	PWM <= std_logic_vector((unsigned(TenDigit)*10) + unsigned(UniDigit));	-- Assign this value to PWM for functionality
	-- PWM2
	TenDigit2 <= SW(15 downto 12);		-- Set Tens switches
	UniDigit2 <= SW(11 downto 8);		-- Set Units switches
	PWM2 <= std_logic_vector((unsigned(TenDigit2)*10) + unsigned(UniDigit2));	-- Assign this value to PWM for functionality
	-- Communication
	LEDR(0) <= GPIO_1(0);
	LEDR(1) <= GPIO_1(1);
	LEDR(2) <= GPIO_1(2);
	-- Miscellaneous
	HEX4 <= "1111111"; -------| Clear unused HEX displays
	HEX5 <= "1111111"; 		--| So they dont all show as 8
	HEX6 <= "1111111"; 		--|
	HEX7 <= "1111111"; -------|
	
	-- Main Process A
	process(CLOCK_50, reset)
		-- Variables
		variable count : integer := 0;
		
	begin
		if(reset = '1') then
			-- Reset triggered
			count := 0;
		elsif(rising_edge(CLOCK_50)) then
			-- Increment PWM
			if(count < 100) then
				if(count < unsigned(PWM(6 downto 0))) then
					-- Send power signal
					LEDG(0) <= '1';
				else
					LEDG(0) <= '0';
				end if;
				count := count + 1; -- Increment count variable
			else
				count := 0;
			end if;
		end if;
	end process;
	
	-- Main Process B
	process(CLOCK_50, reset)
		-- Variables
		variable count : integer := 0;
		
	begin
		if(reset = '1') then
			-- Reset triggered
			count := 0;
		elsif(rising_edge(CLOCK_50)) then
			-- Increment PWM
			if(count < 100) then
				if(count < unsigned(PWM2(6 downto 0))) then
					-- Send power signal
					LEDG(1) <= '1';
				else
					LEDG(1) <= '0';
				end if;
				count := count + 1; -- Increment count variable
			else
				count := 0;
			end if;
		end if;
	end process;

end BEHAVIOURAL;