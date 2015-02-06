/*
JukeBoxEvent.as
JukeBox

Created by Alexander Ruiz Ponce on 20/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{

    import flash.events.Event;
   
    public class JukeBoxEvent extends Event
    {
		public var params:Object;
		
		public static const CHANGE:String = "update";
		public static const ITEM_LIST_CLICKED:String = "itemListClicked";
		public static const JUKE_BOX_SHUFFLE:String = "jukeBoxShuffle";
		public static const JUKE_BOX_REPEAT:String = "jukeBoxRepeat";
		public static const PLAY_LIST_BUTTON_CLICKED:String = "playListButtonClicked";
		public static const PLAYER_BUTTON_CLICKED:String = "playerButtonClicked";
		public static const CD_BIN_CHANGE:String = "cdBinChange";
		public static const CD_BIN_CLICKED:String = "cdBinClicked";
		public static const JUKE_BOX_SOUND_COMPLETE:String = "jukeBoxSoundComplete";
		public static const JUKE_BOX_PLAY_LIST_CHANGED:String = "jukeBoxPlayListChange";
   
        public function JukeBoxEvent(_type:String, _params:Object = null, _bubbles:Boolean = false, _cancelable:Boolean = false)
        {
            super(_type, _bubbles, _cancelable);
            params = _params;
        }
		
        public override function clone():Event
        {
            return new JukeBoxEvent(type, params, bubbles, cancelable);
        }
       
        public override function toString():String
        {
            return formatToString("JukeBoxEvent", "params", "type", "bubbles", "cancelable");
        }
    }
}