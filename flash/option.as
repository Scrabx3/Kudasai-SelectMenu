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

class option extends MovieClip
{
	var baseW: Number;
	var baseH: Number;
	
	var format :TextFormat;
	var name: TextField;
	
	// Note each frame of OptionMC has stop(); called on it via a frame action, which is not shown here.
	public function option() {
		super();
		this.format = this.name.getNewTextFormat();
		this.format.font = "$EverywhereFont";
		this.name.text = "Test";
		
		this._alpha = 50;
		this.onRollOver = function ()
		{
			_parent.SetCurrentSelection(this);
		};
		
		this.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity()._parent == this) {
				_root.main.DoAccept();
			}
		};
	}
	
	public function HandleHighlight(): Void
	{
		this._alpha = 90;

		this.format.font = "$EverywhereBoldFont";
		this.name.setTextFormat(format);
	}
	
	public function ClearHighlight(): Void
	{
		this._alpha = 50;
		this.format.font = "$EverywhereFont";
		this.name.setTextFormat(format);
	}

	public function Disable(): Void
	{
		delete this.onRollOver;
		delete this.onMouseDown;
		_visible = false;
	}

	public function IsDisabled(): Boolean
	{
		return !_visible;
	}
}
