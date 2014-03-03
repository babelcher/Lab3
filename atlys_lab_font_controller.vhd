----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:14:53 02/21/2014 
-- Design Name: 
-- Module Name:    atlys_lab_font_controller - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_lab_font_controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           switch : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end atlys_lab_font_controller;

architecture Behavioral of atlys_lab_font_controller is

    -- TODO: Signals, as needed

	signal row_sig, column_sig: unsigned(10 downto 0);
	signal red, green, blue: STD_LOGIC_VECTOR(7 downto 0);
	signal pixel_clk, serialize_clk, serialize_clk_n, blank, h_sync, v_sync, blank1, blank2, blank_delayed, h_sync1, h_sync2, v_sync1, v_sync2, clock_s, red_s, green_s, blue_s, v_completed_sig, button: STD_LOGIC;
begin

	-- Clock divider - creates pixel clock from 100MHz clock
	inst_DCM_pixel: DCM
	generic map(
					 CLKFX_MULTIPLY => 2,
					 CLKFX_DIVIDE => 8,
					 CLK_FEEDBACK => "1X"
				)
	port map(
				 clkin => clk,
				 rst => reset,
				 clkfx => pixel_clk
			);

	-- Clock divider - creates HDMI serial output clock
	inst_DCM_serialize: DCM
	generic map(
					 CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
					 CLKFX_DIVIDE => 8,
					 CLK_FEEDBACK => "1X"
				)
	port map(
				 clkin => clk,
				 rst => reset,
				 clkfx => serialize_clk,
				 clkfx180 => serialize_clk_n
			);

	 -- TODO: VGA component instantiation
	Inst_vga_sync: entity work.vga_sync(Behavioral) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		h_sync => h_sync,
		v_sync => v_sync,
		v_completed => v_completed_sig,
		blank => blank,
		row => row_sig,
		column => column_sig
	);
		 -- TODO: character generator component instantiation
	Inst_character_gen: entity work.character_gen(Behavioral) PORT MAP(
		clk => pixel_clk,
		blank => blank_delayed,
		row => STD_LOGIC_VECTOR(row_sig),
		column => STD_LOGIC_VECTOR(column_sig),
		ascii_to_write => "00000011",
		write_en => button,
		r => red,
		g => green,
		b => blue
	);
	
	Inst_input_to_pulse: entity work.input_to_pulse(Behavioral) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		input => start,
		pulse => button
		);
		
	--pipeline to account for 4 clock signal delays
	--first delay
	process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			blank1 <= blank;
			h_sync1 <= h_sync;
			v_sync1 <= v_sync;
		end if;
	end process;
	
	--second delay
	process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			blank2 <= blank1;
			h_sync2 <= h_sync1;
			v_sync2 <= v_sync1;
		end if;
	end process;
	
	--third delay
	process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			blank_delayed <= blank2;
		end if;
	end process;
	

	

    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk => serialize_clk,
                clk_n => serialize_clk_n,
                clk_pixel => pixel_clk,
                red_p => red,
                green_p => green,
                blue_p => blue,
                blank => blank2,
                hsync => h_sync2,
                vsync => v_sync2,
                -- outputs to TMDS drivers
                red_s => red_s,
                green_s => green_s,
                blue_s => blue_s,
                clock_s => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue : OBUFDS port map
        ( O => TMDS(0), OB => TMDSB(0), I => blue_s );
    OBUFDS_red : OBUFDS port map
        ( O => TMDS(1), OB => TMDSB(1), I => green_s );
    OBUFDS_green : OBUFDS port map
        ( O => TMDS(2), OB => TMDSB(2), I => red_s );
    OBUFDS_clock : OBUFDS port map
        ( O => TMDS(3), OB => TMDSB(3), I => clock_s );


end Behavioral;

