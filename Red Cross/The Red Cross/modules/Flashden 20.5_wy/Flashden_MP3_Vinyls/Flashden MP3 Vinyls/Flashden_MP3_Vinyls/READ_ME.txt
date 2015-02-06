Hi All,

Thanks for downloading my Record MP3 Player!

Below is a breakdown of some of the editable features the player offers and a few general notes.

GENERAL NOTES:
YOU DO NOT NEED THE FLASH APPLICATION TO USE THIS PLAYER.  You can add it to your html page, as is, and simply edit the xml info. The Flash movie is set to run on Flash Player 7 and above.  There is a blank record, with no artwork in the images/flash images folder if you'd like to create your own artwork.  The file is larger for that reason and needs to be scaled for adding to the fla.

XML:
In the xml document you can add info for:

1. MP3 Path
2. Song Title
3. Artist Title
4. Album Title
5. Needle Rotation Value
6. Album Cover Art
7. MP3 Volume

You can also set the player to Autostart (yes or no or random) and load an external jpg as a background for the swf.

MP3 Path:
Make sure the path name is exact - in relation to your swf.  If you take the music out of the music folder, make sure you note that in the xml.

Song - Album - Artist Title:
Letters or Numbers

Needle Rotation:
Keep the rotation between 20 and 40 to keep the needle on the record.  Use whatever number between those 2 you'd like.

Album Cover Art:
Make sure the path name is exact - in relation to your swf.  If you take the art out of the art folder, make sure you note that in the xml. Thumbnail size for the art should be 95x95.  And needs to be normal jpg format.  NOT A PROGRESSIVE JPG!

bgImage:
This changes the background image in the swf. Inserting "image1" loads the image1.jpg texture from the images folder.  "image2", the image2.jpg texture.  "other" is for an alt bg image of your choosing (name it image3.jpg)  or you can leave it blank for the default gradient bg. The bg is 575x350.  And the images needs to be jpg as well.  DO NOT CHANGE THE NAME OF THE IMAGES FOLDER OR REMOVE THE BG IMAGES FROM THAT FOLDER - THE PATH IS HARD CODED IN THE THE AS.

MP3 Volume:
Since mp3 volume can be all over the place, I've set it up so you can set a separate volume value for each mp3.

Final xml note: make sure to always keep the xml doc in the same folder as your swf.

THE FLASH (FLA) FILE:
If you do choose to edit the flash file all the code is fairly well commented.  You can change the record effects.  Or remove the record sounds outright.  You can easily change font types and colors and rearrange the elements to match your design needs.

Well, I believe that's it. 

Design, coding and kick-ass sample tracks for the player by Dave Carey/ Station 8 Design, Inc.