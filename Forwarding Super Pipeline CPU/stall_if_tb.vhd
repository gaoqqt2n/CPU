library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity stall_if_tb is  
end stall_if_tb;  
 
architecture stimulus of stall_if_tb is 
component stall_if  
    port(
        clk, rst : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        inhactrl : in std_logic_vector(1 downto 0) := "00"; --hold address control
        inflag : in std_logic_vector(2 downto 0) := "000"; 
        outflag : out std_logic_vector(2 downto 0); 
        outhactrl : out std_logic_vector(1 downto 0); --hold address control
        forwarding_ctrl : out std_logic_vector(4 downto 0);
        pout : out std_logic
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
 signal clk, rst : std_logic;
 signal inst : std_logic_vector(31 downto 0);
 signal inhactrl : std_logic_vector(1 downto 0) := "00"; --hold address control
 signal inflag : std_logic_vector(2 downto 0) := "000"; 
 signal outflag : std_logic_vector(2 downto 0); 
 signal outhactrl : std_logic_vector(1 downto 0); --hold address control
 signal forwarding_ctrl : std_logic_vector(4 downto 0);
 signal pout : std_logic;
 
begin  
    dut : stall_if port map(clk, rst, inst, inhactrl, inflag, outflag, outhactrl, forwarding_ctrl, pout); 

    process begin    
        clock : for I in 0 to 15 loop 
        CLK <= transport '0'; 
        wait for half_cycle;
        CLK <= transport '1'; 
            wait for half_cycle; 
            end loop;  
        wait; 
    end process; 
 
    process begin  
        rst <= '0'; inst <= x"04000000"; inhactrl <= "00"; inflag <= "000"; 
        wait for delay;
        wait for cycle; 
        rst <= '1'; inst <= x"00221820"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"00643020"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"8cc70001"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"00a74020"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"00681020"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"ac410004"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"8c270004"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"8ce80001"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"ad01000a"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"00221820"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"ac23000d"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"8c85000a"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;         
        rst <= '1'; inst <= x"acc5000a"; inhactrl <= "00"; inflag <= "000"; 
        wait for cycle;           

        wait; 
    end process;     
 
end stimulus; 
 
configuration cfg_stall_if_tb of stall_if_tb is  
    for stimulus  
    end for; 
end cfg_stall_if_tb; 
 
