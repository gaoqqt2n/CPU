library IEEE;
use IEEE.std_logic_1164.all;

entity pc_tb is 
end pc_tb;

architecture stimulus of pc_tb is
component pc 
    port(
        clk, rst : in std_logic;
        next_address : in std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)
    );
end component;

constant cycle  : time := 400 ns;
constant half_cycle  :  time := 200 ns;
constant delay  : time := 10 ns;

signal clk, rst : std_logic; 
signal next_address, address : std_logic_vector(31 downto 0); 

begin 
    dut : pc port map(
        clk => clk,
        rst => rst,
        next_address => next_address,
        address => address);

    process begin   

    clock : for I in 0 to 9 loop
            CLK <= transport '0';
            WAIT FOR half_cycle;
            CLK <= transport '1';
            WAIT FOR half_cycle;
        end loop; 
        wait;
    end process;

     process begin 
        next_address <= x"00000004"; rst <= '0';
        wait for delay;
        wait for 50 ns;    
        wait for 50 ns;    next_address <= x"00000008"; rst <= '1';
        wait for 100 ns;   next_address <= x"0000000c"; 
        wait for 100 ns;   next_address <= x"00000010";
        wait for 100 ns;   next_address <= x"00000018"; 
        wait for 100 ns;   next_address <= x"00000004"; 
        wait for 100 ns;   next_address <= x"00000008"; 
        wait for 100 ns;   next_address <= x"0000000c"; 
        wait for 100 ns;
        wait;
     end process;    
    
end stimulus;

configuration cfg_pc_tb of pc_tb is 
    for stimulus 
    end for;
end cfg_pc_tb;
