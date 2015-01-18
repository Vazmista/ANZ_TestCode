# ANZ_TestCode

NOTE**** This project was part of a practice test for an iOS position with a time limit of 12 hours.

Hi, 

Hopefully this test project will demonstrate my skill level in objective-C. Although its been years since I had to do manual memory management, working off the top of my head I believe there aren’t any leaks.

Note:
- Usually I use cocoa pods in my projects, however I decided against this for this project because the only 3rd party library I wished to use was AFNetworking, which was simple enough to incorporate. However, due to this, I couldn’t disable arc for the whole project seeing as AFNetworking uses arc, therefore I disabled ARC per file as I made them.
- I was told not to spend more than 12 hours on this, therefore the flow is quite basic and the design is straight forward, as I spent most of my time setting the project up to be extended later in the future, and re-used.
- One of the requirements was for the project to run on a device, which I couldn’t understand how you would be able to test that as I’d have to create the provisioning profiles off my personal account, which you wouldn’t have the right certificates & profiles for. However, it does run on all the simulators iOS 8.1. 
- I picked iOS 8.1 as the deployment target as I didn’t have much time to code for older versions.
- There are no custom images in the app, again to save time and I’m not much of a designer :p

Usage:
- The app automatically open in the list view and will auto refresh to pull the latest data. (An auto refresh will happen every 5 minutes).
- To manually refresh there is a pull down refresh controller on the table.
- The table is unsorted (putting a sort feature in was in my plans but ran out of time)
- The map uses basic pin drops for the earthquakes, when tapping the callout accessory button it will go to the details view of the earthquake.
- In the details view you can either tap the tab at the bottom of the screen to slide the view in/out. Or you can swipe up to bring it up, or swipe down to pull it down.
- The app supports all orientations and will auto conform to each size.
- Works on both iPhone & iPad

Enjoy,
Valery Shorinov (Val)
