/*
* A simple "Hello, World" example that demonstrates use of an
* application-modal dialog 
*/

package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import qnx.dialog.DialogButtonProperty;
	import qnx.dialog.PromptDialog;
	import qnx.display.IowWindow;
	import qnx.fuse.ui.buttons.LabelButton;
	import qnx.fuse.ui.text.Label;
	import com.miracledelivery.airhello.FlickrGettr;
	
	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#BBBBBB")]
	public class AIRHelloWorld extends Sprite
	{
		private var urlLabel:Label;
		private var helloButton:LabelButton;
		private var urlDialog:PromptDialog;
		
		public function AIRHelloWorld()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			/* A button to request an url */
			helloButton = new LabelButton();
			helloButton.label = "Push Me";
			
			/* A label in which to show the url typed */
			urlLabel = new Label();
			
			var format:TextFormat = new TextFormat();
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.color = 0x103f10;
			format.size = 24;
			urlLabel.format = format;
			addChild(urlLabel);
			
			/* Listen for a touch on the dialog. */
			helloButton.addEventListener(MouseEvent.CLICK, sayHello);
			addChild(helloButton);
		}
		
		private function onAdded(event:Event):void
		{
			trace("[Hello World]", "added to stage");
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			// configure the stage so that it does not scale to fit the orientation
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			layoutUI();
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientation);
		}
		
		private function onOrientation(event:Event):void
		{
			trace("[Hello World]", "orientation changed: ", stage.deviceOrientation);
			layoutUI();
		}
		
		private function layoutUI():void
		{
			// position the button
			helloButton.x = (stage.stageWidth - helloButton.width) / 2;
			helloButton.y = (stage.stageHeight - helloButton.height) / 2;
			
			// size and position the greeting label
			urlLabel.height = 30;
			switch (stage.deviceOrientation)
			{
				case StageOrientation.ROTATED_LEFT:
				case StageOrientation.ROTATED_RIGHT:
					// portrait
					urlLabel.width = 500;
					break;
				default:
					// landscape
					urlLabel.width = 800;
					break;
			}
			urlLabel.x = (stage.stageWidth - urlLabel.width) / 2;
			urlLabel.y = helloButton.y - 60;
		}
		
		private function sayHello(event:MouseEvent):void
		{
			if (urlDialog)
			{
				trace("[Hello World]", "dialog already showing");
			}
			else
			{
				/* Disable the button while the dialog is showing. */
				helloButton.enabled = false;
				
				trace("[Hello World]", "showing dialog");
				
				urlDialog = new PromptDialog();
				urlDialog.message = "Type an URL below";
				urlDialog.prompt = "http:\\www.example.com";
				
				// add buttons and associate semantic context tags to them
				urlDialog.addButton("OK");
				urlDialog.setButtonPropertyAt(DialogButtonProperty.CONTEXT, "typeUrl", 0);
				urlDialog.addButton("Later");
				urlDialog.setButtonPropertyAt(DialogButtonProperty.CONTEXT, "cancel", 1);
				
				/* Register a listener for the dialog buttons. */
				urlDialog.addEventListener(Event.SELECT, onDialogButton);
				
				/*
				* Assign my group ID to the dialog so that it is modal to my application
				* only, not system-wide.  This ensures that the user can switch to and
				* interact with other applications while the dialog is open.
				*/
				urlDialog.show(IowWindow.getAirWindow().group);
			}
		}
		
		private function onDialogButton(event:Event):void
		{
			if (urlDialog)
			{
				trace("[Hello World]", "dialog dismissed");
				
				/* Respond to the user's input. */
				if ("typeUrl" == urlDialog.getButtonPropertyAt(DialogButtonProperty.CONTEXT, urlDialog.selectedIndex))
				{
					urlLabel.text = "URL is " + urlDialog.text;
					var flickr:FlickrGettr = new FlickrGettr(urlDialog.text);
					flickr.parseUrl();
				}
				else
				{
					urlLabel.text = "Maybe later, then.";
				}
				
				/* Clean up the dialog and re-enable the button. */
				urlDialog.removeEventListener(Event.SELECT, onDialogButton);
				urlDialog = null;
				helloButton.enabled = true;
			}
		}
	}
}