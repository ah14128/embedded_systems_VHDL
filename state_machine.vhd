
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

entity state_machine is
	port(
		clkm    		: in std_logic;
		rstn     		: in std_logic;
		HADDR    		: in std_logic_vector(31 downto 0);
		HSIZE			: in std_logic_vector(2 downto 0);
		HTRANS   		: in std_logic_vector(1 downto 0);
		HWDATA   		: in std_logic_vector(31 downto 0);
		HWRITE  		: in std_logic;
		HREADY   		: out std_logic;
		dmai			: out ahb_dma_in_type;
		dmao			: in ahb_dma_out_type
    );
end;

architecture state_machine_arch of state_machine is
	
	type state_type is (idle ,instr_fetch, htrans_high, dmao_high);
	signal curState, nextState: state_type;
begin
	
	--mapping the dmai signals to the state machine inputs
	dmai.address <= HADDR;
	dmai.size <= HSIZE;
	dmai.wdata <= HWDATA;
	dmai.write <= HWRITE;
	--dmai signals not in use
	dmai.busy <= '0';
	dmai.irq <= '0';
	dmai.burst <= '0';
	
	state_reg: process(clkm, rstn)
	begin
		if rstn = '0' then
			curState <= idle;
		elsif rising_edge(clkm) then
			curState <= nextState;
		else
			curState <= curState;
		end if;
	end process;
	
	state_order: process(htrans, dmao.ready)
	begin	
		case curState is
		when idle =>
			if htrans = "10" then
				nextState <= htrans_high;
			else
				nextState <=  idle;
			end if;
		when htrans_high =>
			nextState <= instr_fetch;
		when instr_fetch =>
			if dmao.ready = '1' then
				nextState <= dmao_high;
			else
				nextState <= instr_fetch;
			end if;
		when dmao_high =>
			nextState <= idle;
		when others =>
			nextState <= idle;
		end case;
	end process;

	combinational_output: process(curState)
	begin
		hready <= '0';
		dmai.start <= '0';
		if curState = idle then
			hready <= '1';
		elsif curState = htrans_high then
			hready <= '1';
			dmai.start <= '1';
		elsif curState = instr_fetch then
		elsif curState = dmao_high then
			hready <=  '1';
		end if;
	end process;

end state_machine_arch;
	
	
	
	
	

