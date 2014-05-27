public class BCD {
	public static void main(String[] args) {
		for (int i = -128; i <= 127; i++) {
			//System.out.println(i);
			System.out.println("when \""
					+ paddedBinary(i, 8)
					+ "\" => leds_tmp <= \""
					+ seg_7(i)
					+ "\";");
		}
	}
	public static String paddedBinary(int number, int digits) {
		String binaryNumber = Integer.toBinaryString(number);
		
		int count = digits - 1 - binaryNumber.length();
		
		for(int i=0; i<count; i++) {
			binaryNumber = "0" + binaryNumber;
		}
		
		binaryNumber = binaryNumber.substring(binaryNumber.length() - digits + 1);
		
		if(number < 0) {
			binaryNumber = "1" + binaryNumber;
		} else {
			binaryNumber = "0" + binaryNumber;
		}
		
		return binaryNumber;
	}
	
	public static String decoder(int digit) {
		
		switch (digit) {
			case 0:
				return "1111110";
			case 1:
				return "0110000";
			case 2:
				return "1101101";
			case 3: 
				return "1111001";
			case 4: 
				return "0110011";
			case 5: 
				return "1011011";
			case 6: 
				return "1011111";
			case 7: 
				return "1110000";
			case 8: 
				return "1111111";
			case 9: 
				return "1111011";
			default:
				return "0000000";
		}
	}
	
	public static String minusDecoder(boolean positive) {
		if(positive) {
			return "0000000";
		}
		
		return "0000001";
	}
	
	public static String seg_7(int number) {
		boolean positive = number >= 0;
		number = Math.abs(number);
		int tens;
		int ones;
		int hund;
		if(number<10) {
			ones = number;
			tens = -1;
			hund = -1;
		} else if (number<100) {
			ones = number%10;
			tens = number/10;
			hund = -1;
		} else {
			ones = number % 10;
			tens = (number % 100) / 10;
			hund = number / 100;
		}
		return minusDecoder(positive) + decoder(hund) + decoder(tens) + decoder(ones);
	}
}
