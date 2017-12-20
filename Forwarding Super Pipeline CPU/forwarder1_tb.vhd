library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity forwarder1_tb is  
end forwarder1_tb;  
 
architecture stimulus of forwarder1_tb is 
component forwarder1  
    port(
        ctrl : in std_logic_vector(3 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal ctrl : std_logic_vector(3 downto 0);
signal in1, in2 : std_logic_vector(31 downto 0);
signal exoutdata, maoutdata : std_logic_vector(31 downto 0);
signal out1, out2 : std_logic_vector(31 downto 0);
 
begin  
    dut : forwarder1 port map(ctrl, in1, in2, exoutdata, maoutdata, out1, out2); 
 
     process begin  
        ctrl <= "0001"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for delay; 
        wait for cycle; 
        ctrl <= "0001"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0010"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0011"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0100"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0101"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0110"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "0111"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "1000"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "1001"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        ctrl <= "1010"; in1 <= x"00000001"; in2 <= x"00000002"; exoutdata <= x"00000003"; maoutdata <= x"00000004";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_forwarder1_tb of forwarder1_tb is  
    for stimulus  
    end for; 
end cfg_forwarder1_tb; 
 
