package Classes {
	import flash.text.TextField;
	
	public class ChatBoxProcess extends TextField {
		public var realText;
		public var assignedSmileys:Array;
		
		public function ChatBoxProcess():void {
			this.condenseWhite = true;
			this.wordWrap = true;
			this.multiline = true;
			this.selectable = false;
			
			assignedSmileys = new Array();
		}
		
		public function addSmiley(index:uint):void {
			assignedSmileys.push(index);
		}
		
		public function getAssignedSmileys():Array {
			return assignedSmileys;
		}
	}
}