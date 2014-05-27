library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cpu1 is
	port (
		clk : in std_logic;
		reset : in std_logic;
		instruction : in std_logic_vector(0 to 16);

		instruction_position : out std_logic_vector(0 to 7);

		regA_out : out std_logic_vector(0 to 7);
		regB_out : out std_logic_vector(0 to 7);
		regC_out : out std_logic_vector(0 to 7));
end cpu1;

architecture struct of cpu1 is
	signal first_input : std_logic_vector(0 to 7);
	signal second_input : std_logic_vector(0 to 7);

	signal write_output : std_logic_vector(0 to 7);


	signal next_instruction_position : std_logic_vector(0 to 7);


	signal command : std_logic_vector(0 to 2);
	signal first_input_sel : std_logic_vector(0 to 1);
	signal second_input_sel : std_logic_vector(0 to 1);
	signal write_sel : std_logic_vector(0 to 1);

	signal regA_data : std_logic_vector(0 to 7);
	signal regB_data : std_logic_vector(0 to 7);
	signal regC_data : std_logic_vector(0 to 7);
	signal encoded_data : std_logic_vector(0 to 7);

	signal jump_flag : std_logic;
	signal jump_sel : std_logic;
	signal jump_zero_flag : std_logic;
	signal jump_positive_flag : std_logic;

	signal zero_flag : std_logic;
	signal positive_flag : std_logic;
	
	signal next_zero_flag : std_logic;
	signal next_positive_flag : std_logic;
	

	signal regA_sel : std_logic;
	signal regB_sel : std_logic;
	signal regC_sel : std_logic;
begin
	regA_out <= regA_data;
	regB_out <= regB_data;
	regC_out <= regC_data;
	
	command <= instruction(0 to 2);
	first_input_sel <= instruction(3 to 4);
	second_input_sel <= instruction(5 to 6);
	write_sel <= instruction(7 to 8);
	encoded_data <= instruction(9 to 16);

	process(first_input_sel, regA_data, regB_data, encoded_data) begin
		if first_input_sel="00" then
			first_input <= regA_data;
		elsif first_input_sel="01" then
			first_input <= regB_data;
		elsif first_input_sel="10" then
			first_input <= regC_data;
		else
			first_input <= encoded_data;
		end if;
	end process;

	process(second_input_sel, regA_data, regB_data, encoded_data) begin
		if second_input_sel="00" then
			second_input <= regA_data;
		elsif second_input_sel="01" then
			second_input <= regB_data;
		elsif second_input_sel="10" then
			second_input <= regC_data;
		else
			second_input <= encoded_data;
		end if;
	end process;

	process(command, first_input, second_input) begin
		write_output <= first_input;
		case command is
			when "001" =>
				write_output <= std_logic_vector( signed(first_input) + signed(second_input) );
			when "010" =>
				write_output <= std_logic_vector(-signed(first_input));
			when others =>
		end case;
	end process;

	process(clk, reset)
	begin
		if reset='1' then
			regA_data <= (others => '0');
			regB_data <= (others => '0');
			regC_data <= (others => '0');
		elsif rising_edge(clk) then
			if write_sel="00" then
				regA_data <= write_output;
			end if;

			if write_sel="01" then
				regB_data <= write_output;
			end if;

			if write_sel="10" then
				regC_data <= write_output;
			end if;
		end if;
	end process;

	next_positive_flag <= not write_output(0);
	process(write_output) begin
		if write_output = "00000000" then
			next_zero_flag <= '1';
		else
			next_zero_flag <= '0';
		end if;
	end process;

	process(clk, reset)
	begin
		if reset='1' then
			zero_flag <= '0';
			positive_flag <= '0';
		elsif rising_edge(clk) then
			if jump_flag='0' then
				zero_flag <= next_zero_flag;
				positive_flag <= next_positive_flag;
			end if;
		end if;
	end process;

	process(command) begin
		jump_zero_flag <= '0';
		jump_positive_flag <= '0';
		if command = "011" then
			jump_zero_flag <= '1';
		end if;
		
		if command = "100" then
			jump_positive_flag <= '1';
		end if;
	end process;

	jump_flag <= jump_positive_flag or jump_zero_flag;
	jump_sel <= (jump_positive_flag and positive_flag) or (jump_zero_flag and zero_flag);

	process(jump_sel, write_output) begin
		if jump_sel = '1' then
			next_instruction_position <= write_output;
		else
			next_instruction_position <= std_logic_vector(unsigned(next_instruction_position) + 1);
		end if;
	end process;

	process(clk, reset)
	begin
		if reset='1' then
			instruction_position <= (others => '0');
		elsif rising_edge(clk) then
			instruction_position <= next_instruction_position;
		end if;
	end process;
end struct;