import org.apache.log4j.BasicConfigurator;  
import org.apache.log4j.LogManager;  
import org.apache.log4j.Logger; 

public class DummyCart {
  int x = 5;
  int a=5;

  public static void main(String[] args) {
    DummyCart myObj1 = new DummyCart();  // Object 1
    DummyCart myObj2 = new DummyCart();  // Object 2

    System.out.println(myObj1.x);
    System.out.println(myObj2.x);
    System.out.println("Hello, is this a codesmell");
    System.out.println("Hello, is this another codesmell");
  }
}