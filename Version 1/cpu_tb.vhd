library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_display is
end tb_display;
architecture spec of tb_display is
    component cpu1 is
        port(
            clk        : in std_logic;
            reset      : in std_logic;
            instruction: in std_logic_vector(0 to 16);

            instruction_position : out std_logic_vector(0 to 7);
            regA_out : out std_logic_vector(0 to 7);
            regB_out : out std_logic_vector(0 to 7);
            regC_out : out std_logic_vector(0 to 7));
    end component;

    signal command : std_logic_vector(0 to 2) := "000";
    signal first_input_sel : std_logic_vector(0 to 1) := "11";
    signal second_input_sel : std_logic_vector(0 to 1) := "11";
    signal write_sel : std_logic_vector(0 to 1) := "00";
    signal encoded_data : std_logic_vector(0 to 7) := "01111111";

    signal instruction: std_logic_vector(0 to 16);
    signal instruction_position : std_logic_vector(0 to 7);
    signal clk        : std_logic := '1';
    signal regA : std_logic_vector(0 to 7);
    signal regB : std_logic_vector(0 to 7);
    signal regC : std_logic_vector(0 to 7);
    signal reset : std_logic := '1';
begin

    instruction <= command & first_input_sel & second_input_sel & write_sel & encoded_data;

    dut: cpu1 port map(clk, reset, instruction, instruction_position, regA, regB, regC);

    -- Clock signal
    process
    begin
        wait for 5 ns; clk <= not clk;
    end process;

    process begin
        wait for 15 ns;
        reset <= '0';
        wait;
    end process;

end spec;
