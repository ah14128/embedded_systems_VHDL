
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;

entity data_swapper is
	port(
		clkm			: in std_logic;
		HRDATA			: out std_logic_vector(31 downto 0);
		dmao			: in std_logic_vector(31 downto 0)
	);
end;

architecture data_swapper_arch of data_swapper is
	
begin
	
	HRDATA(	7 downto 0 ) 	<= dmao(31 downto 24);
	HRDATA(15 downto 8 ) 	<= dmao(23 downto 16);
	HRDATA(23 downto 16) 	<= dmao(15 downto 8);
	HRDATA(31 downto 24) 	<= dmao(7 downto 0);


end data_swapper_arch;
	
	
	
	
	