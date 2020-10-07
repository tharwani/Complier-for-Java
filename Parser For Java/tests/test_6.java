import java.io.*; 
import java.util.*; 
  
public class GFG { 
  
    // Function to check if a string is palindrome or not 
    static boolean isPalindrome(String s) 
    { 
        // String that stores characters 
        // of s in reverse order 
        String s1 = ""; 
  
        // Length of the string s 
        int N = s.length(); 
  
        for (int i = N - 1; i >= 0; i--) 
            s1 += s.charAt(i); 
  
        if (s.equals(s1)) 
            return true; 
        return false; 
    } 
  
    static boolean createString(int N) 
    { 
        String str = ""; 
        String s = "" + N; 
  
        // String used to form substring using N 
        String letters = "abcdefghij"; 
        // Variable to store sum of digits of N 
        int sum = 0; 
        String substr = ""; 
  
        // Forming the substring by traversing N 
        for (int i = 0; i < s.length(); i++) { 
            int digit = s.charAt(i) - '0'; 
            substr += letters.charAt(digit); 
            sum += digit; 
        } 
  
        // Appending the substr to str  
        // till it's length becomes equal to sum 
        while (str.length() <= sum) { 
            str += substr; 
        } 
  
        // Trimming the string str so that  
        // it's length becomes equal to sum 
        str = str.substring(0, sum); 
  
        return isPalindrome(str); 
    } 
  
    // Driver code 
    public static void main(String args[]) 
    { 
        int N = 61; 
  
        // Calling function isPalindrome to  
        // check if str is Palindrome or not 
        boolean flag = createString(N); 
        if (flag) 
            System.out.println("YES"); 
        else
            System.out.println("NO"); 
    } 
} 