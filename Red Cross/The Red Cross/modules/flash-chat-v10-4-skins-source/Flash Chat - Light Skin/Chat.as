package 
{
import fl.events.*;
import flash.media.SoundTransform;
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.utils.*;
import flash.text.*;
import flash.external.ExternalInterface;


	public class Chat extends MovieClip 
	{
		private var messageArray:Array = new Array();
		private var adminCode:String;
		private var adminCodeBox:adminCode_mc = new adminCode_mc();
		private var initialServerDate:Number = 1;
		private var firstServerTime:String;
		private var currentDate:Date = new Date();
		private var maximumMessages:Number = 4;
		
		private var privateMessageBox:privateMessage_mc = new privateMessage_mc();
		private var privateMessageSender:String;
		
		private var chatTextColor:String = "#FFFFFF";
		private var chatLinkColor:String = "#FF8500";
		
		private var chatXML:XML;
		private var userXML:XML;
		private var archiveXmlLoader:URLLoader = new URLLoader();
		private var chatXmlLoader:URLLoader = new URLLoader();
		private var userXmlLoader:URLLoader = new URLLoader();
		private var updateTimerChat:Timer = new Timer(2000);
		private var updateTimerUserlist:Timer = new Timer(2000);
		
		private var vars:URLVariables;
		private var phpRequest:URLRequest;
		private var phpLoader:URLLoader;
		private var phpResultVars:URLVariables;
		private var chatProcessUrl:String = "xml_chatprocess.php"; 
		private var userProcessUrl:String = "xml_userprocess.php";
		private var chatFunctionsUrl:String = "chat_functions.php" + "?nocache=" + new Date().getTime();

		private var timeoutArray:Array = new Array();
		private var timeoutCheck:String;
		private var userEnter:String;
		private var currentUser:String = new String();
		private var currentMessages:Number;
		private var lastMessageTime:Number;
		private var previousTimeStamp:String;
		private var injectingHistory:Boolean = false;
		
		private var sound_newUser:NewUserSound = new NewUserSound();
		private var sound_newMessage:NewMessageSound = new NewMessageSound();
		private var sound_exitUser:ExitUserSound = new ExitUserSound();
		private var sounds:Boolean = true;
		
		/*Initiates the chat on load*/
		public function Chat()
		{   
			trace("Flash Chat v1.503 Deluxe Engine");
			trace("----------------------------------------------------------");
			trace("Created by Sven Kohn");
			trace("(C) 2009 by Mindprobe - www.mind-probe.com");
			trace("Report piracy and receive $$$ award");
			trace("----------------------------------------------------------");
			trace("-> Initializing chat");
			trace("-> Awaiting user login...");
			
			userlist_txt.htmlText = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
			messageArray.push({timestamp:"-", username:"-", chatmessage:"-", messagetime:10});

			updateTimerChat.addEventListener(TimerEvent.TIMER, updateChatData); // Chat window data refresh Timer
			updateTimerUserlist.addEventListener(TimerEvent.TIMER, updateUserListData); // Userlist window data refresh Timer
			
			send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
			input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
			logout_btn.addEventListener(MouseEvent.CLICK, onLogout);
			
			/*Timer updates the message and userlist window*/
			function updateChatData(event:TimerEvent):void
			{
			chatXmlLoader.load(new URLRequest("chathistory.xml" + "?nocache=" + new Date().getTime()));
			chatXmlLoader.addEventListener(Event.COMPLETE, processChatXML);
			}

			function updateUserListData(event:TimerEvent):void
			{
			userXmlLoader.load(new URLRequest("userlist.xml" + "?nocache=" + new Date().getTime()));
			userXmlLoader.addEventListener(Event.COMPLETE, processUserXML);
			}


// FUNCTION processChatXML - Retrieves new message data from XML, apply filters, add to message array and play sound effects
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************	
			
			function processChatXML(event:Event):void 
			{
				chatXML = new XML(event.target.data);
				
				if(String(messageArray[messageArray.length - 1].chatmessage) == String(chatXML.entry.message[chatXML.*.length() - 1]))
				{
				trace("[IDLE]");
				}
				
				if(String(chatXML.entry.message[chatXML.*.length() - 1]) != String(messageArray[messageArray.length - 1].chatmessage) || 
				injectingHistory == true)
				{
				trace("[NEW DATA]");
					
					if(injectingHistory == true)
					{
					messageArray.splice(1);
					injectingHistory = false;
					}

					if(currentMessages == maximumMessages)
					{
					currentMessages = currentMessages - 1;
					}
				
					if(chatXML.entry.messagetime[currentMessages] > lastMessageTime &&
					   sounds != false &&
					   chatXML.entry.name[currentMessages] != currentUser &&
					   chatXML.entry.message[currentMessages].substr(0,12) != "is no longer" &&
					   chatXML.entry.message[currentMessages].substr(0,6) != "Enters" &&
					   chatXML.entry.message[currentMessages].substr(0,6) != "Leaves" &&
					   chatXML.entry.message[currentMessages].substr(0,8) != "/private")
					{
					sound_newMessage.play();
					trace("-> New message incoming");
					}
				
					if(chatXML.entry.messagetime[currentMessages] > lastMessageTime &&
					   sounds != false &&
					   chatXML.entry.name[currentMessages] != currentUser &&
					   chatXML.entry.message[currentMessages].substr(0,12) != "is no longer" &&
					   chatXML.entry.message[currentMessages].substr(0,6) != "Enters" &&
					   chatXML.entry.message[currentMessages].substr(0,6) != "Leaves" &&
					   chatXML.entry.message[currentMessages].substr(0,8) == "/private" &&
					   chatXML.entry.message[currentMessages].substr(9,currentUser.length) == currentUser)
					{
					sound_newMessage.play();
					trace("-> New private message incoming");
					}

					if(chatXML.entry.messagetime[currentMessages] > lastMessageTime &&
					   sounds != false &&
					   String(chatXML.entry.name[currentMessages]) != "null" &&
					   chatXML.entry.message[currentMessages].substr(0,6) == "Enters")
					{
					trace("-> New user enters the chat");
					sound_newUser.play();
					}
				
					if(chatXML.entry.messagetime[currentMessages] > lastMessageTime && 
					   sounds != false &&
					   chatXML.entry.name[currentMessages] != currentUser &&
					   String(chatXML.entry.name[currentMessages]) != "null" &&
					   chatXML.entry.message[currentMessages].substr(0,6) == "Leaves")
					{
					sound_exitUser.play();
					trace("-> User leaves");
					}
					
					if(chatXML.entry.messagetime[currentMessages] > lastMessageTime && 
					   sounds != false &&
					   chatXML.entry.name[currentMessages] != currentUser &&
					   String(chatXML.entry.name[currentMessages]) != "null" &&
					   chatXML.entry.message[currentMessages].substr(0,12) == "is no longer")
					{
					sound_exitUser.play();
					trace("-> User leaves");
					}					

					currentMessages = 0;
				
					for (var i:int = 0; i < chatXML.*.length(); i++)
					{
						// Filter duplicate messages
						if(String(chatXML.entry.message[i - 1])!= String(chatXML.entry.message[i]) && 
						   initialServerDate < chatXML.entry.messagetime[i] && 
						   String(chatXML.entry.name[currentMessages]) != "null" &&
						   String(chatXML.entry.name[currentMessages]) != currentUser)
						{
							if(String(chatXML.entry.message[i].substr(0,8)) == "/private" &&
							   currentUser != "" && 
							   String(chatXML.entry.message[i].substr(9,currentUser.length)) == currentUser &&
							   Number(chatXML.entry.messagetime[i]) > messageArray[messageArray.length - 1].messagetime)
							{
							messageArray.push({timestamp:chatXML.entry.timestamp[i], username:chatXML.entry.name[i], chatmessage:"<b><font color='" + chatLinkColor + "'>[Pssst...]</font></b> " + String(chatXML.entry.message[i].substr(9 + currentUser.length + 1,300)), messagetime:Number(chatXML.entry.messagetime[i])});
							
							sa.addText("<font color='" + chatTextColor + "'>" + "[ " + chatXML.entry.timestamp[i] + " ] " + "<b>" + chatXML.entry.name[i] + ": <font color='" + chatLinkColor + "'>[Pssst...]</font></b> " + String(chatXML.entry.message[i].substr(9 + currentUser.length + 1,300)) + "</font>");
							
							privateMessageBox.x = 10;
							privateMessageBox.y = 10;
							addChild(privateMessageBox);
							
							privateMessageSender = chatXML.entry.name[i];
							privateMessageBox.privateMessageTitle_txt.htmlText = "<b>Private message from " + chatXML.entry.name[i] + "</b>";
							
							privateMessageBox.privateMessage_txt.htmlText = "<font color='#000000'>" + "[ " + chatXML.entry.timestamp[i] + " ] " + "<b>" + chatXML.entry.name[i] + ": </b>" + String(chatXML.entry.message[i].substr(9 + currentUser.length + 1,300)) + "</font>"
							
							privateMessageBox.close_btn.addEventListener(MouseEvent.CLICK, onClosePrivateMessageBox);
							privateMessageBox.privateSend_btn.addEventListener(MouseEvent.CLICK, onPrivateMessageSendMouseClick);
							privateMessageBox.privateInput_txt.addEventListener(KeyboardEvent.KEY_DOWN, onPrivateMessageSendKeyPress);
							}
											
							if(String(chatXML.entry.message[i].substr(0,8)) != "/private" && 
							Number(chatXML.entry.messagetime[i]) > messageArray[messageArray.length - 1].messagetime ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" &&
							Number(messageArray.length == 1) &&
							Number(chatXML.entry.messagetime[i]) == messageArray[messageArray.length - 1].messagetime &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 1].chatmessage ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" &&
							Number(chatXML.entry.messagetime[i]) == messageArray[messageArray.length - 1].messagetime &&
							Number(messageArray.length == 2) &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 1].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 2].chatmessage ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" &&
							Number(chatXML.entry.messagetime[i]) == messageArray[messageArray.length - 1].messagetime &&
							Number(messageArray.length == 3) &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 1].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 2].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 3].chatmessage ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" &&
							Number(chatXML.entry.messagetime[i]) == messageArray[messageArray.length - 1].messagetime &&
							Number(messageArray.length == 4) &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 1].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 2].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 3].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 4].chatmessage ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" &&
							Number(chatXML.entry.messagetime[i]) == messageArray[messageArray.length - 1].messagetime &&
							Number(messageArray.length > 4) &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 1].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 2].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 3].chatmessage &&
							String(chatXML.entry.message[i]) != messageArray[messageArray.length - 4].chatmessage ||
							
							String(chatXML.entry.message[i].substr(0,8)) != "/private" && 
							chatXML.entry.messagetime[i] == 2 && i > chatXML.*.length() - 36)
							{
							messageArray.push({timestamp:chatXML.entry.timestamp[i], username:chatXML.entry.name[i], chatmessage:String(chatXML.entry.message[i]), messagetime:Number(chatXML.entry.messagetime[i])});
							
								if(String(chatXML.entry.message[i]).substr(0,8) == "/private")
								{
								sa.addText("<font color='" + chatTextColor + "'>" + "[ " + chatXML.entry.timestamp[i] + " ] " + "<b>" + chatXML.entry.name[i] + ": [Sending Private Message]" + "</b>" + String(chatXML.entry.message[i]) + "</font>");
								}
								else if (String(chatXML.entry.message[i]).substr(0,8) != "/private")
								{
								sa.addText("<font color='" + chatTextColor + "'>" + "[ " + chatXML.entry.timestamp[i] + " ] " + "<b>" + chatXML.entry.name[i] + ": " + "</b>" + String(chatXML.entry.message[i]) + "</font>");
								}
							}

							if(i == chatXML.*.length() - 1)
							{
							previousTimeStamp = chatXML.entry.timestamp[i]; // Fake message timestamp for real-time message sending simulation
							}
						}
						lastMessageTime = chatXML.entry.messagetime[i]; // Store last message time to compare with new incoming message times
						currentMessages = i + 1;
					}
					
					// Maintain the Array containing the chat messages
					if(messageArray.length - 1 == 50)
					{
					messageArray.splice(0,1);
					}
						
					if(messageArray.length - 1 >= 51)
					{
					messageArray.splice(1);
					}
				}
			}
			

// FUNCTION processUserXML - Confirm login, check current user status, generate userlist, client overrides for kick and ban, alive ping
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************

			/*Updates the userlist window and users online counter*/
			function processUserXML(event:Event):void 
			{
			userXML = new XML(event.target.data);
			userlist_txt.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
			
				if(userEnter == "login") // Add new user to Userlist
				{
				sa.addText("<font color='" + chatLinkColor + "'><b>>> You have entered the chat room at " + firstServerTime + "</b></font>");
				
					if(userXML.*.length() == 1)
					{
					sa.addText("<font color='" + chatLinkColor + "'>1 User Online - You are the only person in the chat room :(</font>");
					}
					
					if(userXML.*.length() > 1)
					{
					sa.addText("<font color='" + chatLinkColor + "'>" + String(userXML.*.length()) + " Users Online - Enjoy your stay and be nice to others! :P</font>");
					}
				
				currentDate = new Date();
				
				phpRequest = new URLRequest(chatProcessUrl);
				phpLoader = new URLLoader();

				vars = new URLVariables();
				vars.var1 = currentUser;
				vars.var2 = "Enters @";
				
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;
				phpLoader.load(phpRequest);
				
				userEnter = "logged";
				}
				
			timeoutCheck = "offline";
				
				for (var i:int = 0; i < userXML.*.length(); i++)
				{
				var time:Number;
				var minutes:Number;
				var calc:Number;
				var seconds:Number;
				var secondsOutput:String;
				
					if(userEnter == "logged" && userXML.entry.name[i] == currentUser)
					{
					timeoutCheck = "online";
					}

					time = Number(userXML.entry.online_time[i]) / 60;
					minutes = Math.floor(time);
					calc = minutes * 60;
					seconds = Number(userXML.entry.online_time[i]) - calc;
					
					if(seconds < 10)
					{
					secondsOutput = "0" + String(seconds);
					}
					else
					{
					secondsOutput = String(seconds);
					}
					
			userlist_txt.text = userXML.entry.name[i] + " - " + minutes + ":" + secondsOutput + "\n" + String(userlist_txt.text);
					
					if(userXML.entry.user_love[i] == "kick" && userXML.entry.name[i] == currentUser)
					{
					//destroy chat!			
					sa.addText("<font color='" + chatLinkColor + "'><b>>> You have been kicked from the chat!</b></font>");
						
					userlist_txt.text = "";
					updateTimerChat.stop();
					updateTimerChat.removeEventListener(TimerEvent.TIMER, updateChatData); // Chat window data refresh Timer
					updateTimerUserlist.stop();
					updateTimerUserlist.removeEventListener(TimerEvent.TIMER, updateUserListData); // Chat window data refresh Timer
					send_btn.removeEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
					input_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
					logout_btn.removeEventListener(MouseEvent.CLICK, onLogout);
					}
					
					if(userXML.entry.user_love[i] == "ban" && userXML.entry.name[i] == currentUser)
					{
					//ban IP and destroy chat!
					phpRequest = new URLRequest(userProcessUrl);
					phpLoader = new URLLoader();
					
					vars = new URLVariables();
					vars.var1 = currentUser;
					vars.var2 = "suicide";
					vars.var3 = "suicide";
									
					phpRequest.data = vars;
					phpRequest.method = URLRequestMethod.POST;
					phpLoader.load(phpRequest);
						
					sa.addText("<font color='" + chatLinkColor + "'><b>>> You have been banned from the chat!</b></font>");
						
					userlist_txt.text = "";
					updateTimerChat.stop();
					updateTimerChat.removeEventListener(TimerEvent.TIMER, updateChatData); // Chat window data refresh Timer
					updateTimerUserlist.stop();
					updateTimerUserlist.removeEventListener(TimerEvent.TIMER, updateUserListData); // Chat window data refresh Timer
					send_btn.removeEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
					input_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
					logout_btn.removeEventListener(MouseEvent.CLICK, onLogout);
					}
				}
				
			status_txt.htmlText = "<b>" + String(userXML.*.length()) + "</b> User(s) Online";
			userscroll_cmp.scrollPosition = userscroll_cmp.minScrollPosition; // Moves the SCROLL BAR to end of chat message text
				
			phpRequest = new URLRequest(userProcessUrl);
			phpLoader = new URLLoader();
			
			vars = new URLVariables();
			vars.var1 = currentUser;
			vars.var2 = "ok";
			vars.var3 = "ping";
							
			phpRequest.data = vars;
			phpRequest.method = URLRequestMethod.POST;
			phpLoader.load(phpRequest);
			}
			
			updateTimerChat.start();
			updateTimerUserlist.start();
			
			

// FUNCTION onMessageSend - Processing typed message
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
			
			/*Send message via keypress*/
			function onMessageSendKeyPress(event:KeyboardEvent):void
			{
				if(event.keyCode == 13)
				{
				input_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				onMessageSend();
				}
			}	
		
			/*Send message via send button click*/
			function onMessageSendMouseClick(event:MouseEvent):void
			{
			send_btn.removeEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
			onMessageSend();
			}
			
			/*Sends user message to PHP to save the new data into the chathistory XML*/
			function onMessageSend():void
			{
				if(firstServerTime != "expired")
				{
				previousTimeStamp = firstServerTime;
				firstServerTime = "expired";
				}

				if(String(input_txt.text).substr(0,8) == "/private")
				{
				sa.addText("<font color='" + chatTextColor + "'>[ " + previousTimeStamp + " ]<b> " + currentUser + ": <font color='" + chatLinkColor + "'>[Private Sent]</font></b> " + String(input_txt.text) + "</font>");
				
				phpRequest = new URLRequest(chatProcessUrl);
				phpLoader = new URLLoader();

				vars = new URLVariables();
				vars.var1 = currentUser;
				vars.var2 = input_txt.text;
				
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;

				phpLoader.addEventListener(Event.COMPLETE, onMessageComplete);
				phpLoader.load(phpRequest);
				}
				else
				{
					if(String(input_txt.text).substr(0,5) == "/help")
					{
					sa.addText("<font color='" + chatTextColor + "'><b>List of Chat Commands</b></font>");
					sa.addText("<font color='" + chatTextColor + "'>---------------------------------------------------------------------------------------------</font>");
					sa.addText("<font color='" + chatTextColor + "'><b>Type these commands into the chat</b></font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/rooms</font> - View list of available chat rooms</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/private [username] [msg]</font> - Send private pop-up chat window to user</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/kick [username]</font> - Kick a user from the chat (admin only)</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/ban [username]</font> - Ban a user's IP address (admin only)</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/history</font> - View last 30 chat messages</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/sounds</font> - Switches sounds ON and OFF</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/clear</font> - Clear message history XML files (admin only)</font>");
					sa.addText("<font color='" + chatTextColor + "'><font color='" + chatLinkColor + "'>/help</font> - View list of all chat commands</font>");
					sa.addText("<font color='" + chatTextColor + "'>---------------------------------------------------------------------------------------------</font>");
					input_txt.text = "";
					}
						
					if(String(input_txt.text).substr(0,6) == "/rooms")
					{
					sa.addText("<font color='" + chatTextColor + "'><b>List of Chat Rooms</b></font>");
					sa.addText("<font color='" + chatTextColor + "'>---------------------------------------------------------------------------------------------</font>");
					sa.addText("<font color='" + chatTextColor + "'><b>Click on the room name to switch:</b></font>");
					sa.addText("<font color='" + chatTextColor + "'><a href='http://www.flashchatdeluxe.com/index.php'><u><font color='" + chatLinkColor + "'>#Main Chat Room</font></u></a> - Test the chat as much as you like here</font>");
					sa.addText("<font color='" + chatTextColor + "'><a href='http://www.flashchatdeluxe.com/rooms/fun/index.html'><u><font color='" + chatLinkColor + "'>#The Fun Room</font></u></a> - Tell jokes and laugh with others</font>");
					sa.addText("<font color='" + chatTextColor + "'><a href='http://www.flashchatdeluxe.com/rooms/challenge/index.html'><u><font color='" + chatLinkColor + "'>#The Challenge Room</font></u></a> - Stay online for 10 hours and win a beer</font>");
					sa.addText("<font color='" + chatTextColor + "'><a href='http://www.flashchatdeluxe.com/rooms/espanol/index.html'><u><font color='" + chatLinkColor + "'>#Chat en Español</font></u></a> - Viva España!</font>");
					sa.addText("<font color='" + chatTextColor + "'>Create unlimited chat rooms with Flash Chat v1.5 Deluxe</font>");
					sa.addText("<font color='" + chatTextColor + "'>---------------------------------------------------------------------------------------------</font>");
					input_txt.text = "";
					}
						
					if(String(input_txt.text).substr(0,7) == "/sounds")
					{
						if(sounds == true)
						{
						input_txt.text = ""
						trace ("[Sounds OFF]");
						sounds = false;
						sa.addText("<font color='" + chatLinkColor + "'>>> [Sounds OFF]</font>");
						}
						else if(sounds == false)
						{
						input_txt.text = ""
						trace ("[Sounds ON]");
						sounds = true;
						sa.addText("<font color='" + chatLinkColor + "'>>> [Sounds ON]</font>");
						}
					}
						
					if(String(input_txt.text).substr(0,8) == "/history")
					{
					input_txt.text = "";
					trace("[Loading History]");
					sa.addText("<font color='" + chatLinkColor + "'>>> [Loading History...]</font>");
						
					archiveXmlLoader.load(new URLRequest("chatarchive.xml" + "?nocache=" + new Date().getTime()));
					archiveXmlLoader.addEventListener(ProgressEvent.PROGRESS, loadArchiveXML);
					archiveXmlLoader.addEventListener(Event.COMPLETE, processChatXML);
					}
					
					if(String(input_txt.text).substr(0,6) == "/clear")
					{
					adminCodeBox.x = 10;
					adminCodeBox.y = 10;
					addChild(adminCodeBox);
						
					adminCodeBox.close_btn.addEventListener(MouseEvent.CLICK, onClosePasswordBox);
					adminCodeBox.kick_btn.addEventListener(MouseEvent.CLICK, onCodeClear);
					}
					
					if(String(input_txt.text).substr(0,5) == "/kick")
					{
					adminCodeBox.x = 10;
					adminCodeBox.y = 10;
					addChild(adminCodeBox);
						
					adminCodeBox.close_btn.addEventListener(MouseEvent.CLICK, onClosePasswordBox);
					adminCodeBox.kick_btn.addEventListener(MouseEvent.CLICK, onCodeKick);
					}
						
					if(String(input_txt.text).substr(0,4) == "/ban")
					{
					adminCodeBox.x = 10;
					adminCodeBox.y = 10;
					addChild(adminCodeBox);
						
					adminCodeBox.close_btn.addEventListener(MouseEvent.CLICK, onClosePasswordBox);
					adminCodeBox.kick_btn.addEventListener(MouseEvent.CLICK, onCodeBan);
					}
						
					if(String(input_txt.text).substr(0,1) == "/" &&
					String(input_txt.text).substr(0,5) != "/help" &&
					String(input_txt.text).substr(0,7) != "/sounds" &&
					String(input_txt.text).substr(0,8) != "/private" &&
					String(input_txt.text).substr(0,5) != "/kick" && 
					String(input_txt.text).substr(0,8) != "/history" &&
					String(input_txt.text).substr(0,4) != "/ban" && 
					String(input_txt.text).substr(0,6) != "/clear" && 
					String(input_txt.text).substr(0,4) != "/rooms")
					{
					trace("[Invalid Command]");
					sa.addText("<font color='" + chatLinkColor + "'>>> <b>[Invalid Command!]</b> Please type /help to see a list of commands.</font>");
					input_txt.text = "";
					}
					
					if(String(input_txt.text) != "" &&
					String(input_txt.text) == String(messageArray[messageArray.length - 1].chatmessage) &&
					currentUser == String(messageArray[messageArray.length - 1].username))
					{
					sa.addText("<font color='" + chatLinkColor + "'>>> <b>[Flood Control]</b> Duplicate messages are not allowed!</font>");
					input_txt.text = "";
					}
					
					if(String(input_txt.text) != "" &&
					String(input_txt.text).substr(0,6) != "/clear" && 
					String(input_txt.text).substr(0,5) != "/kick" && 
					String(input_txt.text).substr(0,8) != "/history" &&
					String(input_txt.text).substr(0,4) != "/ban")
					{
					phpRequest = new URLRequest(chatProcessUrl);
					phpLoader = new URLLoader();
		
					vars = new URLVariables();
					vars.var1 = currentUser;
					vars.var2 = input_txt.text;
						
					phpRequest.data = vars;
					phpRequest.method = URLRequestMethod.POST;
		
					phpLoader.addEventListener(ProgressEvent.PROGRESS, onMessageStart);
					phpLoader.addEventListener(Event.COMPLETE, onMessageComplete);
					phpLoader.load(phpRequest);
					}
				}
				
				if(String(input_txt.text) == "")
				{
				input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
				}
			}
			
			
			function onMessageStart(event:ProgressEvent):void
			{
			trace("-> Message Sending");
			messageArray.push({timestamp:previousTimeStamp, username:currentUser, chatmessage:String(input_txt.text), messagetime:lastMessageTime});
			
			sa.addText("<font color='" + chatTextColor + "'>[ " + previousTimeStamp + " ] " + "<b>" + currentUser +": " + "</b>" + input_txt.text + "</font>");
			input_txt.text = "";
			}
			
			
			function onMessageComplete(e:Event):void
			{
			input_txt.text = "";
			send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
			input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
			timeoutControler(timeoutCheck); // Check if the user has timed-out
			}
			
			
// CHAT COMMAND FUNCTIONS - Process called chat commands
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************

			// Private Message Box Functions
			function onClosePrivateMessageBox(event:MouseEvent):void
			{
			privateMessageBox.privateInput_txt.text = "";
			removeChild(privateMessageBox);
			}	
			
			
			function onPrivateMessageSendKeyPress(event:KeyboardEvent):void
			{
				if(event.keyCode == 13)
				{
				privateMessageBox.privateInput_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onPrivateMessageSendKeyPress);
				onPrivateMessageSend();
				}
			}	
		
		
			function onPrivateMessageSendMouseClick(event:MouseEvent):void
			{
			privateMessageBox.privateSend_btn.removeEventListener(MouseEvent.CLICK, onPrivateMessageSendMouseClick);
			onPrivateMessageSend();
			}
			
			
			function onPrivateMessageSend():void
			{
				if(String(privateMessageBox.privateInput_txt.text) != "")
				{
				sa.addText("<font color='" + chatTextColor + "'>[ " + previousTimeStamp + " ]<b> " + currentUser + ": <font color='" + chatLinkColor + "'>[Private Sent]</font></b> " + String(privateMessageBox.privateInput_txt.text) + "</font>");
				
				phpRequest = new URLRequest(chatProcessUrl);
				phpLoader = new URLLoader();

				vars = new URLVariables();
				vars.var1 = currentUser;
				vars.var2 = "/private " + privateMessageSender + " " + privateMessageBox.privateInput_txt.text;
				
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;

				phpLoader.addEventListener(Event.COMPLETE, onMessageComplete);
				phpLoader.load(phpRequest);
				
				privateMessageBox.privateInput_txt.text = "";
				removeChild(privateMessageBox);
				}
			}	
			
			// Loading Chat History Function
			function loadArchiveXML(event:ProgressEvent):void 
			{
			var per = event.bytesLoaded/event.bytesTotal;
			
			input_txt.text = "Loading Chat History. Please wait... " + "Total: " + String(event.bytesTotal) + " Bytes - Loaded: " + String(event.bytesLoaded) + " Bytes";
			
				if(Number(event.bytesTotal) >= 50000)
				{
				input_txt.text = "";
				sa.addText("<font color='" + chatLinkColor + "'>>> History XML file has become too large to load. Please reset.</font>");
				injectingHistory = false;
				archiveXmlLoader.removeEventListener(Event.COMPLETE, processChatXML);
				archiveXmlLoader.removeEventListener(ProgressEvent.PROGRESS, loadArchiveXML);
				}
				
				if(Number(event.bytesTotal) <= 50000)
				{
					if(Math.round(per*10*10) == 100) 
					{
					input_txt.text = "";
					trace("[Injecting History]");
					injectingHistory = true;
					}
				}
			}
			
			// Administrator Password Box Functions
			function onClosePasswordBox(event:MouseEvent):void
			{
			input_txt.text = "";
			input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
			send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
			removeChild(adminCodeBox);
			}	
			
			
			function onCodeKick(event:MouseEvent):void
			{
				if(String(adminCodeBox.adminCode_txt.text) == adminCode)
				{
				phpRequest = new URLRequest(userProcessUrl);
				phpLoader = new URLLoader();
					
				vars = new URLVariables();
				vars.var1 = String(input_txt.text).substr(6,20);
				vars.var2 = "kick";
				vars.var3 = "kick";
									
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;
				phpLoader.load(phpRequest);
						
				sa.addText("<font color='" + chatLinkColor + "'>>> [Kicking User] " + String(input_txt.text).substr(6,20) + "</font>");

				input_txt.text = "";
				input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
				removeChild(adminCodeBox);
				}
				
				if(String(adminCodeBox.adminCode_txt.text) != adminCode)
				{
				adminCodeBox.adminCodeError_txt.text = "Wrong Password!";
				adminCodeBox.adminCode_txt.text = "";
				}
			}
			
			
			function onCodeBan(event:MouseEvent):void
			{
				if(String(adminCodeBox.adminCode_txt.text) == adminCode)
				{
				phpRequest = new URLRequest(userProcessUrl);
				phpLoader = new URLLoader();
					
				vars = new URLVariables();
				vars.var1 = String(input_txt.text).substr(5,20);
				vars.var2 = "ban";
				vars.var3 = "ban";
									
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;
				phpLoader.load(phpRequest);
						
				sa.addText("<font color='" + chatLinkColor + "'>>> [Banning User] " + String(input_txt.text).substr(5,20) + "</font>");
					
				input_txt.text = "";
				input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
				removeChild(adminCodeBox);
				}
				
				if(String(adminCodeBox.adminCode_txt.text) != adminCode)
				{
				adminCodeBox.adminCodeError_txt.text = "Wrong Password!";
				adminCodeBox.adminCode_txt.text = "";
				}
			}	

			// Clearing Chat History XML Files Function
			function onCodeClear(event:MouseEvent):void
			{
				if(String(adminCodeBox.adminCode_txt.text) == adminCode)
				{
				phpRequest = new URLRequest(chatFunctionsUrl);
				phpLoader = new URLLoader();
					
				vars = new URLVariables();
				vars.var3 = "clear";
									
				phpRequest.data = vars;
				phpRequest.method = URLRequestMethod.POST;
				phpLoader.load(phpRequest);
						
				sa.addText("<font color='" + chatLinkColor + "'>>> [History Cleared]</font>");

				input_txt.text = "";
				input_txt.addEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				send_btn.addEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
				removeChild(adminCodeBox);
				}
				
				if(String(adminCodeBox.adminCode_txt.text) != adminCode)
				{
				adminCodeBox.adminCodeError_txt.text = "Wrong Password!";
				adminCodeBox.adminCode_txt.text = "";
				}
			}
			
			// User Timeout Check Function
			function timeoutControler(timeoutStatus:String) 
			{
			var timeoutCounter:Number = 0;	
			timeoutArray.push({control:timeoutStatus});

				for (var i:int = 0; i < timeoutArray.length; i++)
				{
					if(timeoutArray[i].control == "offline")
					{
					timeoutCounter = timeoutCounter + 1;
					}
				}
				
				if(timeoutCounter >= 3)
				{	
				sa.addText("<font color='" + chatLinkColor + "'><b>>> You lost connection! Please re-connect to the chatroom.</b></font>");
				userlist_txt.text = "";
				updateTimerChat.stop();
				updateTimerChat.removeEventListener(TimerEvent.TIMER, updateChatData); // Chat window data refresh Timer
				updateTimerUserlist.stop();
				updateTimerUserlist.removeEventListener(TimerEvent.TIMER, updateUserListData); // Chat window data refresh Timer
				send_btn.removeEventListener(MouseEvent.CLICK, onMessageSendMouseClick);
				input_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onMessageSendKeyPress);
				logout_btn.removeEventListener(MouseEvent.CLICK, onLogout);
				}

				if(timeoutArray.length == 5)
				{
				timeoutArray.splice(0,1);
				}
			}
			

// FUNCTION onLogout - Logout the user and send the logout command to PHP to remove the user name from the userlist
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************

			function onLogout(event:MouseEvent):void
			{
			updateTimerChat.stop();
			updateTimerUserlist.stop();
				
			phpRequest = new URLRequest(userProcessUrl);
			phpLoader = new URLLoader();

			vars = new URLVariables();
			vars.var1 = currentUser;
			vars.var2 = "ok";
			vars.var3 = "logout";
				
			phpRequest.data = vars;
			phpRequest.method = URLRequestMethod.POST;
			phpLoader.load(phpRequest);
				
			currentDate = new Date();
				
			phpRequest = new URLRequest(chatProcessUrl);
			phpLoader = new URLLoader();

			vars = new URLVariables();
			vars.var1 = currentUser;
			vars.var2 = "Leaves @";
			
			phpRequest.data = vars;
			phpRequest.method = URLRequestMethod.POST;
			phpLoader.addEventListener(Event.COMPLETE, onLogoutComplete);
			phpLoader.load(phpRequest);
			}
		
			/*When the logout process is completed, go to the logout screen*/
			function onLogoutComplete(e:Event):void 
			{
			userEnter = "logout";
			currentUser = "";
			gotoAndStop("logout");
			}
		
		
// Scrollbars Mouse Events
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************
// ***************************************************************************************************************************************

			userlist_txt.addEventListener(MouseEvent.MOUSE_OVER, onUserScroll);
			userlist_txt.addEventListener(MouseEvent.ROLL_OUT, onUserExitScroll);
			
			userscroll_cmp.addEventListener(MouseEvent.MOUSE_OVER, onUserScroll);
			userscroll_cmp.addEventListener(MouseEvent.MOUSE_DOWN, onUserScroll);
			userscroll_cmp.addEventListener(MouseEvent.MOUSE_UP, onUserExitScroll);
			userscroll_cmp.addEventListener(MouseEvent.ROLL_OUT, onUserExitScroll);
			
			function onUserScroll(event:MouseEvent):void
			{
			userscroll_cmp.alpha = .9;
			}
			
			function onUserExitScroll(event:MouseEvent):void
			{
			userscroll_cmp.alpha = .0;
			}
	    }
	}
}