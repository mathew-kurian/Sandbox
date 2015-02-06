class ShareWindowEvent
{
	//Type of the event
	public var type:String;

	//Recipient email
	public var email:String;
	
	private var addThisServiceCode:String;
	
	//Event types
	public static var CLOSED:String = "closed";
	public static var ADD_THIS:String = "addThis";
	
	public function ShareWindowEvent(type:String, email:String, addThisServiceCode:String) 
	{
		this.email = email;
		this.addThisServiceCode = addThisServiceCode;
	}
}