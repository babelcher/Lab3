----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:52:41 02/25/2014 
-- Design Name: 
-- Module Name:    eight_to_one_mux - Behavioral 
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

entity eight_to_one_mux is
    Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           column : in  STD_LOGIC_VECTOR (2 downto 0);
           output : out  STD_LOGIC);
end eight_to_one_mux;

architecture Behavioral of eight_to_one_mux is

begin

process(data, column)
begin	
	if(column = "000") then
		output <= data(7);
	elsif(column = "001") then
		output <= data(6);
	elsif(column = "010") then
		output <= data(5);
	elsif(column = "011") then
		output <= data(4);
	elsif(column = "100") then
		output <= data(3);
	elsif(column = "101") then
		output <= data(2);
	elsif(column = "110") then
		output <= data(1);
	else
		output <= data(0);
	end if;
end process;


end Behavioral;

