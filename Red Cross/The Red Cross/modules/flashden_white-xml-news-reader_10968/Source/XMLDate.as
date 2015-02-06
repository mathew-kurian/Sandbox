class XMLDate extends MovieClip {
	
	private var workingSkin:MovieClip;
	private var inter1:Number=-1;
	private var currentDate:Boolean=false;
	
//	static var instance:XMLDate;
	
	function XMLDate() {
		//instance=this;
		trace("- XML powered date started.");
		init();
	}
	
	function init(){
		this.workingSkin=this["skin1"];
	}
	
	//this is the date from XML file
	function showDate(dateString:String){
		if (this.currentDate) {
			var my_date:Date = new Date();
			dateString=my_date.getDate()+"."+(my_date.getMonth()+1)+"."+my_date.getFullYear();
		}			
		// dd.mm.year
		var months:Array=new Array("JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER");
		var days:Array=new Array("th","st","nd","rd","th");
		var dateSplit:Array = dateString.split("."); //split the date array
		this.workingSkin.date_numeric.text=Number(dateSplit[0]); //set numeric date
		//set trailing date
		if (Number(dateSplit[0].charAt(dateSplit[0].length-1))<=4 && (Number(dateSplit[0])<4 || Number(dateSplit[0])>20)){
			this.workingSkin.date_trailing.text=days[Number(dateSplit[0].charAt(dateSplit[0].length-1))];
		} else {
			this.workingSkin.date_trailing.text="th";
		}
		this.workingSkin.date_month.text=months[Number(dateSplit[1])-1]; //set month
		//center the numeric date and the trailing
		this.workingSkin.date_numeric.autoSize=true; 
		this.workingSkin.date_numeric._x=(this.workingSkin._width-this.workingSkin.date_numeric._width)/2;
		this.workingSkin.date_trailing._x=this.workingSkin.date_numeric._width+this.workingSkin.date_numeric._x-1;
	}
	
	function showClock(visible:Boolean, time:String) {
		if (!visible) {
			clearInterval(inter1);
			this.workingSkin.time._visible=false;
		} else {
			this.workingSkin.time._visible=true;
			if (this.currentDate) {
				var timeFunc:Function = function(thisObj:Object){
					this=thisObj;
					var my_date:Date = new Date();
					var hourObj:Object = getHoursAmPm(my_date.getHours());
					my_date.getMinutes ()<10?this.workingSkin.time.txt.text=hourObj.hours+":0"+my_date.getMinutes ()+" "+hourObj.ampm:this.workingSkin.time.txt.text=hourObj.hours+":"+my_date.getMinutes ()+" "+hourObj.ampm;
					function getHoursAmPm(hour24:Number):Object {
	    				var returnObj:Object = new Object();
    					returnObj.ampm = (hour24<12) ? "AM" : "PM";
    					var hour12:Number = hour24%12;
    					if (hour12 == 0) {
    						hour12 = 12;
    					}
    					returnObj.hours = hour12;
    					return returnObj;
    				}
				}
				timeFunc(this);
				this.inter1=setInterval(timeFunc,60000,this);
			} else {
				this.workingSkin.time.txt.text=time;
			}
		}
	}
			
	
	function setWorkingSkin(flavour:Number) {
		if (flavour==1) {
			workingSkin=this["skin1"];
			this["skin2"]._visible=false;
			this["skin1"]._visible=true;
		} else {
			workingSkin=this["skin2"];
			this["skin2"]._visible=true;
			this["skin1"]._visible=false;
		}
	}
	
	function displayCurrentDate(yes:Boolean) {
		this.currentDate=yes;
		if (yes) showDate();
	}
			
	
}