--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    15:59:36 04/02/10
-- Design Name:    
-- Module Name:    fix_original - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fix_original is

		port (clk: in std_logic;
				start: in std_logic;
				data_x : in std_logic_vector(9 downto 0);
				data_y : in std_logic_vector(9 downto 0);
				angle_index : out std_logic_vector(8 downto 0);
				original: out std_logic_vector(399 downto 0);
				finished: out std_logic
				);
				
end fix_original;

architecture Behavioral of fix_original is

signal start_l: std_logic:='0';
signal counter: std_logic_Vector(8 downto 0):="111111111";

begin

PROCESS (clk)
		
		BEGIN
		IF (clk'event and clk='1' )  THEN
			if (start='1') then
				counter <=counter+1;
				start_l<='1';
				
		   elsif (start='0')	then
				counter<="111111111";
				start_l<='0';
				
			end if;
		END IF;
END PROCESS;

PROCESS(clk,start)

											
			BEGIN
				
				IF (clk'event and clk='1' and start_l='1') THEN	  
			
						angle_index<=conv_std_logic_vector(conv_integer(counter)*9,9);

						if (conv_integer(counter)>2 and conv_integer(counter)<23) then
							original(conv_integer(counter-3)*20+19 downto conv_integer(counter-3)*20)<=data_y & data_x;
						end if;

						if (counter=22 ) then
							finished <= '1';
						else
							finished <='0';
						end if;
						
					
		
				END IF;
	
	

		END PROCESS;

end Behavioral;
