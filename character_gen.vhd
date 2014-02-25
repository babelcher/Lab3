----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:31 02/21/2014 
-- Design Name: 
-- Module Name:    character_gen - Behavioral 
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

entity character_gen is
    Port ( clk : in  STD_LOGIC;
           blank : in  STD_LOGIC;
           row : in  STD_LOGIC_VECTOR (10 downto 0);
           column : in  STD_LOGIC_VECTOR (10 downto 0);
           ascii_to_write : in  STD_LOGIC_VECTOR (7 downto 0);
           write_en : in  STD_LOGIC;
           r,g,b : out  STD_LOGIC_VECTOR (7 downto 0));
end character_gen;

architecture Behavioral of character_gen is


	signal row_reg, row_next, column_reg, column_next : STD_LOGIC_VECTOR(10 downto 0);
	signal address_sig : STD_LOGIC_VECTOR(10 downto 0);
	signal data_sig : STD_LOGIC_VECTOR(7 downto 0);
	signal small_col_first, small_col_second, small_col_reg: STD_LOGIC_VECTOR(2 downto 0);

begin

	Inst_char_screen_buffer: entity work.char_screen_buffer(Behavioral) PORT MAP(
			clk => clk,
			we => write_en,
			address_a => (others => '0'),
			address_b => (others => '0'),
			data_in => ascii_to_write,
			data_out_a => open,
			data_out_b => open
		);
	
	Inst_font_rom: entity work.font_rom(arch) PORT MAP(
			clk => clk,
			addr => address_sig,
			data => data_sig
		);
		
	--DFF to delay one clock cycle
	process(clk)
	begin
		if(rising_edge(clk)) then
			small_col_first <= column(2) & column(1) & column(0);
		end if;
	end process;
	
	--DFF to delay column another cycle
	process(clk)
	begin
		if(rising_edge(clk)) then
			small_col_second <= small_col_first;
		end if;
	end process;
	
	small_col_reg <= small_col_second;
	

end Behavioral;

