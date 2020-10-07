import java.io.*;
import java.util.Vector;
import java.util.regex.*;

public class Lexer
{   
   public static class Location 
   {
      public final int line;
      public final int column;
      
      public Location(int line, int column)
      {
         this.line = line;
         this.column = column;
      }
      
      public String toString()
      {
         return line + ":" + column;
      }
   }

   public static class Token
   {
      public Token(String image, int id, Location begin, Location end)
      {
         this.id = id;
         this.image = image;
         this.begin = begin;
         this.end = end;
      }
      
      public final int id;
      public final String image;
      public final Location begin;
      public final Location end;
      
      public String toString()
      {
         return "['" + image + "' id=" + id + " " + begin + ".." + end + "]";
      }
   }
   
   private CharSequence input;
   private int where = 0;
   private final int[] lineStartOffsets;

   
   private Location locationOf(int offset)
   {
      for(int ln = 0; ln < lineStartOffsets.length; ++ln)
      {
         int curr = lineStartOffsets[ln];
         if(curr == offset)
            return new Location(ln, offset - curr);
         
         if(curr > offset)
         {
            int col0 = lineStartOffsets[ln-1];
            return new Location(ln-1, offset - col0);
         }
      }      
      
      assert false;
      return null;            
   }

   public Lexer(String s) 
   {
      input = s;
      
      Vector<Integer> ints = new Vector<Integer>();
      ints.add(0);
      
      CharSequence cs = input;
      for(int offset = 0; offset < cs.length(); ++offset)
      {
         char c = cs.charAt(offset);
         if(c != '\n')
            continue;
         
         ints.add(offset+1);
      }
      
      ints.add(cs.length());
      
      this.lineStartOffsets = new int[ints.size()];
      int ln = -1;
      for(int curr : ints)
      {
         ++ln;
         lineStartOffsets[ln] = curr;
      }
   }
   
   public Lexer(InputStream is) throws IOException
   {
      this(new InputStreamReader(is));
   }
   
   private static String makeStr(Reader r) throws IOException
   {
      StringBuilder sb = new StringBuilder();
      
      while(true)
      {
         int n = r.read();
         if(n < 0)
            break;
         
         char c = (char) n;
         sb.append(c);
      }
      
      return sb.toString();
   }
   
   public Lexer(Reader r) throws IOException 
   {
      this(makeStr(r));
   }
      
   public Token next(Pattern p)
   {
      Matcher m = p.matcher(input);
      boolean b = m.find();
      if(!b)
         return null;
      
      MatchResult mr = m.toMatchResult();
      if(m.start() != 0)
         return null;
      
      String s = input.subSequence(mr.start(), mr.end()).toString();      
      Token result = new Token(s, 0, locationOf(where + mr.start()), 
         locationOf(where + mr.end()));
      
      input = input.subSequence(mr.end(), input.length());
      where += mr.end();
      
      return result; 
   }
   
   public Token next(String regexp)
   {
      return next(Pattern.compile(regexp));
   }
}



/*//Valid Identifiers
$myvariable  //correct
_variable    //correct
variable     //correct
edu_identifier_name //correct
edu2019var   //correct

//Invalid Identifiers
edu variable    //error
Edu_identifier  //error
&variable       //error
23identifier    //error
switch          //error
var/edu 	    //error
edureka's       //error*/