class AddThisDestinations
{
	public static var destinations:Array = createDestinations();
	public static var destinationClass:Function = AddThisDestination;
	
	public function AddThisDestinations() 
	{
		//
	}
	
	private static function createDestinations():Array
	{
		var destinations:Array = [];
		
		var destination:AddThisDestination = new AddThisDestination();
		destination.serviceCode = "aim"
		destination.iconId = "aimIcon"
		destination.title = "AIM Share"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "bebo"
		destination.iconId = "beboIcon"
		destination.title = "Bebo"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "blogger"
		destination.iconId = "bloggerIcon"
		destination.title = "Blogger"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "delicious"
		destination.iconId = "deliciousIcon"
		destination.title = "Delicious"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "digg"
		destination.iconId = "diggIcon"
		destination.title = "Digg"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "facebook"
		destination.iconId = "facebookIcon"
		destination.title = "Facebook"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "linkedin"
		destination.iconId = "linkedinIcon"
		destination.title = "LinkedIn"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "myspace"
		destination.iconId = "myspaceIcon"
		destination.title = "MySpace"
		destinations.push(destination);
		
		destination = new AddThisDestination();
		destination.serviceCode = "twitter"
		destination.iconId = "twitterIcon"
		destination.title = "Twitter"
		destinations.push(destination);
		
		return destinations;
	}
}