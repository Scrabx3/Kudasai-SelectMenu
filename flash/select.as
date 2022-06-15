import com.greensock.*;
import com.greensock.easing.*;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import mx.utils.Delegate;
import skse;
import Mouse;

class select extends MovieClip
{	
	var option0: MovieClip;
	var option1: MovieClip;
	var option2: MovieClip;
	var option3: MovieClip;
	var option4: MovieClip;
	var option5: MovieClip;
	var option6: MovieClip;
	var option7: MovieClip;
	var option8: MovieClip;
	var option9: MovieClip;
	var option10: MovieClip;
	var option11: MovieClip;
	var option12: MovieClip;
	var option13: MovieClip;

	var options = new Array(14);

	var bg: MovieClip;

	var CurrentSelection: MovieClip;
	var CurrentSelectionIdx: Number;

	public function select() {
		super();
		FocusHandler.instance.setFocus(this,0);
		bg = _root.bg;
		options = [option0, option1, option2, option3, option4, option5, option6, option7, option8, option9, option10, option11, option12, option13];
	}

	public function onLoad() 
	{
		// Handle resizing the bg element for ultrawidescreen
		var stageObj = new Object();
		Stage.addListener(stageObj);
		stageObj.onResize = function()
		{
			_root.bg._width = Stage.width;
			_root.bg._height = Stage.height;
		};
		stageObj.onResize();
		Stage.addListener(stageObj);
		
		SetCurrentSelection(options[0]);
		TweenLite.from(_root, 0.6, {_alpha:0});

		// OpenMenu(["TEST 0","TEST 1","TEST 2","TEST 3","TEST 4","TEST 5","TEST 6","TEST 7","TEST 8","TEST 9", "TEST 10", "TEST 11", "TEST 12", ""]);
	}
	
	public function OpenMenu(): Void
	{
		for (var x = 0; x < arguments.length; x++){
			// options[x].name.text = "Testing..";
			if (arguments[x] == "")
				options[x].Disable();
			else
				options[x].name.text = arguments[x];
		}
	}

	public function SetCurrentSelection(next:MovieClip) {
		CurrentSelection.ClearHighlight();
		CurrentSelection = next;
		for (var x = 0; x < options.length; x++) {
			if (options[x] == CurrentSelection)
				CurrentSelectionIdx = x;
		}
		CurrentSelection.HandleHighlight();
	}

	public function DoAccept() {
		// Event sending the options name and id
		skse.SendModEvent("YKSelect_Accept", options[CurrentSelectionIdx].name, CurrentSelectionIdx);
		CurrentSelection.HandleSelection();
		trace(CurrentSelectionIdx);
		DoExit();
	}

	public function DoCancel() {
		skse.SendModEvent("YKSelect_Cancel");// Send ModEvent called "YamMenu_Cancel" to indicate the menu has been closed.
		DoExit();
	}

	private function DoExit() {
		TweenLite.to(this,0.4,{_alpha:0, onComplete:_root.main.DoClose});// When this tween completes, call DoClose();
		TweenLite.to(bg,0.4,{_alpha:0});
	}

	private function DoClose() {
		trace("exiting");
		skse.CloseMenu("CustomMenu");
	}

	public function handleInput(details:InputDetails, pathToFocus:Array):Void {
		//_root.test1.text = "value=" + details.value+ "navEquivalent=" + details.navEquivalent;
		if (GlobalFunc.IsKeyPressed(details)) {
			var last = options.length - 1;
			switch(details.navEquivalent) {
				case NavigationCode.TAB:
					DoCancel();
					break;
				case NavigationCode.ENTER:
					if (!CurrentSelection.IsDisabled())
						DoAccept();
					break;
				case NavigationCode.UP:
					while (true) {
						CurrentSelectionIdx--;
						if (CurrentSelectionIdx < 0) {
							CurrentSelectionIdx = last;
						}
						if (options[CurrentSelectionIdx].IsDisabled() == false) {
							if (options[CurrentSelectionIdx] != CurrentSelection)
								SetCurrentSelection(options[CurrentSelectionIdx]);
							break;
						}
					}
					break;
				case NavigationCode.DOWN:
					while (true) {
						CurrentSelectionIdx++;
						if (CurrentSelectionIdx == options.length) {
							CurrentSelectionIdx = 0;
						}
						if (options[CurrentSelectionIdx].IsDisabled() == false) {
							if (options[CurrentSelectionIdx] != CurrentSelection)
								SetCurrentSelection(options[CurrentSelectionIdx]);
							break;
						}
					}
					break;
				case NavigationCode.LEFT:
				case NavigationCode.RIGHT:
					{
						var newidx = CurrentSelectionIdx < 7 ? CurrentSelectionIdx + 7 : CurrentSelectionIdx - 7;
						if (!options[newidx].IsDisabled())
							SetCurrentSelection(options[newidx]);
					}
					break;
			}
		}
	}
}
