----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:24 02/19/2014 
-- Design Name: 
-- Module Name:    input_to_pulse - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity input_to_pulse is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           pulse : out  STD_LOGIC);
end input_to_pulse;

architecture Behavioral of input_to_pulse is

	type input_state is
		(idle, input_pushed, input_held);
	signal input_reg, input_next : input_state;
	signal count : unsigned(10 downto 0);
	signal pulse_reg, pulse_next, input_old, input_new, input_debounced: STD_LOGIC;

begin

	--shift register
	process(clk, reset, input)
	begin
		if(reset='1') then
			input_old <= '0';
		elsif(rising_edge(clk)) then
			input_old <= input;
		end if;
	end process;
	
	process(clk, reset, input_old)
	begin
		if(reset='1') then
			count <= (others => '0');
			input_new <= '0';
		elsif(rising_edge(clk)) then
			input_debounced <= '0';
			if(input_new = input_old) then
				count <= count + 1;
			else
				input_new <= input_old;
				count <= (others =>'0');
			end if;
			if(count >= 1000) then
				input_debounced <= '1';
				count <= (others => '0');
			end if;
		end if;
	end process;
	
	--input state register
	process(clk, reset)
	begin
		if(reset='1') then
			input_reg <= idle;
		elsif(rising_edge(clk)) then
			input_reg <= input_next;
		end if;
	end process;
	
	--next state logic
	process(input_reg, input, input_debounced)
	begin
		input_next <= input_reg;
		case input_reg is
			when idle =>
				if(input = '1') then
					input_next <= input_pushed;
				end if;
			when input_pushed =>
				input_next <= input_held;
			when input_held =>
				if(input = '0' and input_debounced = '1') then
					input_next <= idle;
				end if;
		end case;
	end process;
	
	--pulse state register
	process(clk, reset)
	begin
		if(reset='1') then
			pulse_reg <= '0';
		elsif(rising_edge(clk)) then
			pulse_reg <= pulse_next;
		end if;
	end process;
	
	pulse_next <= '1' when input_next = input_pushed else
					  '0';
					
	pulse <= pulse_reg;

end Behavioral;

