----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:53:00 11/26/2009 
-- Design Name: 
-- Module Name:    t_memory_dual - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use std.textio.all;

entity t_memory_dual is
	port (clk : in std_logic;
			we : in std_logic;
			a : in std_logic_vector(8 downto 0);
			dpra : in std_logic_vector(8 downto 0);
			di : in std_logic_vector(23 downto 0);
			spo : out std_logic_vector(23 downto 0);
			dpo : out std_logic_vector(23 downto 0)
			);
end t_memory_dual;

architecture Behavioral of t_memory_dual is
	
	
	type RomType is array (0 to 511) of std_logic_vector(23 downto 0);

	--impure function InitRomFromFile (RomFileName : in string) return RomType is                                                   
   --	FILE RomFile         : text is in RomFileName;                       
   --	variable RomFileLine : line;                                 
    --	variable ROM         : RomType;
		                                      
	--	begin                                                        
   --		for I in RomType'range loop                                  
      --		readline (RomFile, RomFileLine);                             
      --		read (RomFileLine, ROM(I));                                  
   	--	end loop;
			                                                    
    	--	return ROM;
			                                                  
   -- end function;                                                

    signal ROM : RomType; --:= InitRomFromFile("c:\rom3.data");
	
	
	
	signal read_a : std_logic_vector(8 downto 0);
	signal read_dpra : std_logic_vector(8 downto 0);
	
	begin
	
	process (clk)
	begin
		if (clk'event and clk = '1') then
			if (we = '1') then
				ROM(conv_integer(a)) <= di;
			end if;
			read_a <= a;
			read_dpra <= dpra;
		end if;
	end process;
	
	spo <= ROM(conv_integer(read_a));
	dpo <= ROM(conv_integer(read_dpra));
end Behavioral;