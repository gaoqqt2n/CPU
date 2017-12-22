library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity forwarder2_tb is  
end forwarder2_tb;  
 
architecture stimulus of forwarder2_tb is 
component forwarder2  
    port(
        clk, rst : in std_logic;
        ctrl : in std_logic_vector(4 downto 0);
        in1, in2, rtdata : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2, outdatamem : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;
signal ctrl : std_logic_vector(4 downto 0);
signal in1, in2, rtdata : std_logic_vector(31 downto 0);
signal exoutdata, maoutdata : std_logic_vector(31 downto 0);
signal out1, out2, outdatamem : std_logic_vector(31 downto 0);
 
begin  
    dut : forwarder2 port map(clk, rst, ctrl, in1, in2, rtdata, exoutdata, maoutdata, out1, out2, outdatamem); 
 
    process begin    
 
    clock : for I in 0 to 18 loop 
            CLK <= transport '0'; 
            wait for half_cycle; 
            CLK <= transport '1'; 
            wait for half_cycle; 
        end loop;  
        wait; 
    end process; 
 
     process begin  
        rst <= '0'; ctrl <= "00000"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; ctrl <= "00000"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "01000"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "10000"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "11000"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "00001"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "01001"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "10001"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "11001"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "00010"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "01010"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "10010"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "11010"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "00011"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "01011"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "10011"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "11011"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        rst <= '1'; ctrl <= "11111"; in1 <= x"00000001"; in2 <= x"00000002"; rtdata <= x"00000005"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_forwarder2_tb of forwarder2_tb is  
    for stimulus  
    end for; 
end cfg_forwarder2_tb; 
 
