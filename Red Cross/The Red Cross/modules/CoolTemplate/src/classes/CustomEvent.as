/*
CustomEvent.as
CoolTemplate

Created by Alexander Ruiz Ponce on 3/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes {

    import flash.events.Event;
   
    public class CustomEvent extends Event
    {
		public var params:Object;
		
		public static const CLICKED:String = "clicked";
		public static const ITEM_MENU_CLICKED:String = "itemMenuClicked";
		public static const CIRCULAR_GALLERY_ITEM_CLICKED:String = "circularGalleryItemClicked";
		public static const CIRCULAR_GALLERY_SUB_ITEM_CLICKED:String = "circularGallerySubItemClicked";
		public static const CIRCULAR_GALLERY_ITEM_CLOSED:String = "circularGalleryItemClosed";
		public static const CIRCULAR_GALLERY_ITEM_OFF:String = "circularGalleryItemOff";
		public static const CIRCULAR_GALLERY_MOVE_COMPLETE:String = "circularGalleryMoveComplete";
		public static const CIRCULAR_GALLERY_OPEN_START:String = "circularGalleryOpenStart";
		public static const CIRCULAR_GALLERY_OPEN_COMPLETE:String = "circularGalleryOpenComplete";
		public static const CIRCULAR_GALLERY_SLIDE_START:String = "circularGallerySlideStart";
		public static const CIRCULAR_GALLERY_OPEN_CONTENT_START:String = "circularGalleryOpenContentStart";
		public static const CIRCULAR_GALLERY_CLOSE_START:String = "circularGalleryCloseStart";
		public static const CIRCULAR_GALLERY_SUB_ITEM_MOVE_COMPLETE:String = "circularGallerySubItemMoveComplete";
		public static const CIRCULAR_GALLERY_ITEM_LOAD_COMPLETE:String = "circularGalleryLoadComplete";
		public static const CIRCULAR_GALLERY_ITEM_BIG_SOURCE_LOAD_COMPLETE:String = "circularGalleryItemBigSurceLoadComplete";
		public static const CIRCULAR_GALLERY_EXPANDER_CLICKED:String = "circularGalleryExpanderClicked";
		public static const EXPANDER_CLICKED:String = "ExpanderClicked";
		public static const FULL_VIEW_CLOSE:String = "fullViewClose";
		public static const FULL_VIEW_SHOW_VIDEO:String = "fullViewShowVideo";
		public static const FULL_VIEW_HIDE_VIDEO:String = "fullViewHideVideo";
		public static const GLOBAL_RENDER:String = "globalRender";
		public static const DRAG_DISC:String = "dragDisc";
		public static const DROP_DISC:String = "dropDisc";
		public static const CHANGE_PLAY_LIST:String = "changePlayList";
		public static const TEMPLATE_ON:String = "templateOn";
		public static const TEMPLATE_OFF:String = "templateOff";
		public static const VIEW_MORE:String = "viewMore";
		public static const ARROW_CLICKED:String = "arrowClicked";
		public static const BACK_BUTTON_CLICKED:String = "backButtonClicked";
		
   
        public function CustomEvent(_type:String, _params:Object = null, _bubbles:Boolean = false, _cancelable:Boolean = false)
        {
            super(_type, _bubbles, _cancelable);
            params = _params;
        }
		
        public override function clone():Event
        {
            return new CustomEvent(type, params, bubbles, cancelable);
        }
       
        public override function toString():String
        {
            return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
        }
    }
}