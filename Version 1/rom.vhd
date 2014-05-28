LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY rom IS
	PORT (instruction_position  : IN  STD_LOGIC_VECTOR(0 to 7) ;
	      instruction : OUT STD_LOGIC_VECTOR(0 TO 16)) ;
END rom ;

ARCHITECTURE struct OF rom IS
BEGIN

	PROCESS ( instruction_position )
	BEGIN
		CASE instruction_position IS
			when "00000000" => instruction <= "00011110000010100";
			when "00000001" => instruction <= "00011110100000010";
			when "00000010" => instruction <= "01001110100000000";
			when "00000011" => instruction <= "00100010000000000";
			when "00000100" => instruction <= "10011111100000011";
			when others =>     instruction <= "10011111100000000";
		END CASE ;
	END PROCESS ;
END struct ;

