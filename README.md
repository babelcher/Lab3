Lab3
====

## ECE 383 Font Controller

### Introduction

The purpose of Lab 3 was to build a font controller to display ASCII characters on the screen. Required functionality was to display 2400 characters on the screen that all fit. It did not have to be any character in particular. B Functionality allowed the user to select which character to display via the switches on the FPGA board. A Functionality allows the user to interface with an NES controller to select each character.

### Implementation

The following constructs were used to create the font controller.

D Flip Flop in order to delay signals so that everything occurs at the same time.
```VHDL
    process(pixel_clk)
    begin
		if(rising_edge(pixel_clk)) then
			blank1 <= blank;
			h_sync1 <= h_sync;
			v_sync1 <= v_sync;
		end if;
	end process;
```

An 8-1 MUX was used in the character_gen module to determine which pixels to light up in each row of the space.

The input_to_pulse module was used to account for bouncing when pressing a button.

In order to figure out where to write the ascii character, the function below had to be created. This was the most difficult part of the entire lab.
```VHDL
address_b_sig <= STD_LOGIC_VECTOR(unsigned(row(10 downto 4)) * 80 + unsigned(column(10 downto 3)));
```

### Test/Debug

* This lab was more straightforward than previous ones since it was rather apparent that I needed to start with the character_gen module. After creating all the constructs in the diagram from the lab handout I moved on to the top level module.
* The most difficult part was coming up with the correct function to display the characters. After several attempts, I referenced C2C Mossing's code in order to find my errors with the function.
* I was able to get the screen to display 2400 characters in my room but when I tried it in the lab it was off by a few pixels on the left and right sides of the screen. This led me to believe that it was due to errors with my delays. I began changing my delays one at a time in the top level module and was able to narrow down what did and did not work fairly quickly.
* Arriving at B functionality was rather simple since the lab was setup to take the input from a button. I remembered from Lab 2 that I needed to map the switches and button on the board and the tip on the lab handout made that a straight forward process. When I tested B functionality it worked on the first try.

### Conclusion

This lab was an introduction for dealing with things in memory and how to handle them. It should be a good stepping stone for future labs that deal with ROM on the atlys board. It also illustrated how being off by one clock cycle can ruin the entire display on the screen.

### Documentation

I referenced C2C Jason Mossing's code for the function in the character_gen module as stated above.
