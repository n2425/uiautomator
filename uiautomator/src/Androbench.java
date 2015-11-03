import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

/*
public class Androbench extends UiAutomatorTestCase {

	public void testFirst() throws UiObjectNotFoundException {
		UiObject temp = new UiObject(new UiSelector().description("Apps"));
		
		temp.clickAndWaitForNewWindow();
	}

}
*/

public class Androbench extends UiAutomatorTestCase {
	

	public void testFirst() throws UiObjectNotFoundException {

		/* first cycle */
		UiObject Button1 = new UiObject(new UiSelector().className("android.widget.Button").index(0));
		
		Button1.clickAndWaitForNewWindow();
		
		UiObject Button2 = new UiObject(new UiSelector().className("android.widget.Button").index(0));
		
		Button2.clickAndWaitForNewWindow();
	
		UiObject Button3 = new UiObject(new UiSelector().text("Cancel"));
		
		if(Button3.waitForExists(360000)) {
			Button3.clickAndWaitForNewWindow();
		}
		
		UiObject Button4 = new UiObject(new UiSelector().className("android.widget.TextView").index(0));
		
		Button4.clickAndWaitForNewWindow();
		
		/* second cycle */
		
		Button1.clickAndWaitForNewWindow();
		Button2.clickAndWaitForNewWindow();
		if(Button3.waitForExists(360000)) {
			Button3.clickAndWaitForNewWindow();
		}
		
		Button4.clickAndWaitForNewWindow();
		
		/* third cycle */
		Button1.clickAndWaitForNewWindow();
		Button2.clickAndWaitForNewWindow();
		if(Button3.waitForExists(360000)) {
			Button3.clickAndWaitForNewWindow();
		}
		
		Button4.clickAndWaitForNewWindow();
		
	}

}