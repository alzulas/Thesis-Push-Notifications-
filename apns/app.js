/////////////////////////////////////////////////////////////////////////////////////////
//			This program delivers notifications to APNs utilizing Amanda Leah Zulas's Personal Team
//			This .js file utilized NODE .js and is optimized for iOS 10 and Swift 3
//			Requires: sudo npm install apn
//			This program is a part of a thesis project which is a small part of
//			the WSU Solar Decathlon Smart Home project, to compete October 2017
//			Orginal Author: Leah Zulas, Ph.D. 
//			Additional Resources: 
//			https://github.com/node-apn/node-apn
//			https://eladnava.com/send-push-notifications-to-ios-devices-using-xcode-8-and-swift-3/
//			Please direct all questions and comments to alzulas@hotmail.com
//			Please leave proper documentation for any new code, as well as the authors name
//			Enjoy
/////////////////////////////////////////////////////////////////////////////////////////

var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({  
     token: {
        key: 'redacted for github', // Path to the key p8 file
        keyId: 'redacted for github', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: 'redacted for github', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: false // Set to true if sending a notification to a production iOS app
});

let tokens = ['redacted for github release']


// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'alzulas.com.pusherSwiftTest';

// Set expiration to 4 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 14400;

// Set app badge indicator
notification.badge = 1;

// Play ping.aiff sound when the notification is received
notification.sound = 'ping.aiff';

//Pull off of an arg from the cmd line. This should be the notification you want to send
var notify = (process.argv.slice(2)).toString();
notify = notify.replace('\'','\"');
// Display the following message (the actual notification text, supports emoji)
notification.alert = {"title": "Your smart home needs you", "body": notify};
console.log(notification.alert);

// says, this is the extra information to grab on the client side, creates buttons
notification.category = 'UserVote';

//console.log(process.argv.slice(2));

//notification.data = "https://pusher.com/static_logos/320x320.png"

// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
//Buttons however will trample all over your payload and not call didReveiveNotifications
var whichNotify = (process.argv.slice(3)).toString();
whichNotify = whichNotify.replace('\'','\"');
notification.payload = {"notification": "Hi, what's up, this is a notification payload"};
var payload = {"notification": "Hi, what's up, this is a notification payload"};

console.log(`Sending: ${notification.compile()} to ${tokens}`);
// Actually send the notification
apnProvider.send(notification, tokens).then( result => {
    console.log("sent:", result.sent.length);
    console.log("failed:", result.failed.length);
    console.log(result.failed);
});

//Code for python side
//from subprocess import call #needed to call terminal commands
//call(["node", "app.js", "The smart home turned off lights because we think you left", tokenOfUser])


apnProvider.shutdown();
