import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class Androbench extends UiAutomatorTestCase {
	
	public void testFirst() throws UiObjectNotFoundException {
	
		int loop = Integer.parseInt(getParams().getString("loop"));
		 
		System.out.printf("loop count: %d\n", loop);

		/* first cycle */
		
		System.out.printf("count 1\n");
		
		UiObject Button1 = new UiObject(new UiSelector().className("android.widget.Button").index(0));
		
		Button1.clickAndWaitForNewWindow();
		
		UiObject Button2 = new UiObject(new UiSelector().className("android.widget.Button").index(0));
		
		Button2.clickAndWaitForNewWindow();
	
		UiObject Button3 = new UiObject(new UiSelector().text("Cancel"));
		
		if(Button3.waitForExists(30000)) {
			Button3.clickAndWaitForNewWindow();
		}
		
		UiObject Button4 = new UiObject(new UiSelector().className("android.widget.TextView").index(0));
		
		if(Button4.waitForExists(30000)) {
			Button4.clickAndWaitForNewWindow();
		}
		
		for (int i = 1; i < loop; i++) {
			System.out.printf("count %d\n", i);
			
			try {
				Thread.sleep(7000);
			} catch (InterruptedException e) {}
			
			Button1.clickAndWaitForNewWindow();
			
			Button2.clickAndWaitForNewWindow();
			
			
			if(Button3.waitForExists(30000)) {
				Button3.clickAndWaitForNewWindow();
			}
			
			if(Button4.waitForExists(30000)) {
				Button4.clickAndWaitForNewWindow();
			}
			
		}
		
	}

}