#########################################################################################
#			This program schedules the notifications to be sent out via .js to APNs
#			This program is a part of a thesis project which is a small part of
#			the WSU Solar Decathlon Smart Home project, to compete October 2017
#			Orginal Author: Leah Zulas, Ph.D.
#			Additional Resources: 
#			https://docs.python.org/2/library/datetime.html
#           http://stackoverflow.com/questions/35788729/start-node-app-from-python-script
#           https://docs.python.org/3/library/sched.html
#
#			Please direct all questions and comments to alzulas@hotmail.com
#			Please leave proper documentation for any new code, as well as the authors name
#			Enjoy
#########################################################################################

import time #this need is obvious 
import datetime as dt
import sched
from datetime import datetime
from datetime import timedelta
from subprocess import call #needed to call terminal commands
#Don't forget to chmod +x this python application so that you can sudo out.

#Notifications to be sent via the app.js file
#Your garage door has opened (twice a day)
#Your front door has opened (Twice a day)
#Your back door has opened (Once a day)
#Your daily energy consumption is: 33.5 kWh (Once a day)
#Your thermostat has been changed to 73 degrees (Once a day)
#The weather for the day is: (Once a day)
#The solar cell battery status is 52% (8 times over 5 days)
#Tomorrow’s alarm is set for 9am (Once a day in the evening)
#Today’s schedule includes: (Once a day, pulled from user’s calendar)
#Don’t forget to get milk on your way home today. (once during the study)
#A light in the kitchen has been turned on (12 times over the study)
#The sensor above the door is not responding.  Please check on its status. (once during the study)
#A light in the kitchen has been switched off to conserve energy (3 times during the study)
#Your television utilizes 2 watts of energy when not in use.  It will be powered off
#	when not in use from now on. (Once during the study)
#The bedroom window has been opened to cool the room. (4 times during the study)


#notifications to be run on each day
#Day1 - weather, sched, thermo, manualKitchen, frontDoor, garage, window, solar, backDoor, garage, frontDoor, manualKitchen, solar, energyCom, alarm,
#Day2 - weather, sched, solar, manualKitchen, thermo, frontDoor, garage, manualKitchen, autokitchen, backDoor, frontDoor, manualKitchen, garage, sensor, solar, window, energyCom, alarm,
#Day3 - weather, sched, thermo, manualKitchen, frontDoor, garage, tvenergy, window, garage, backDoor, solar, frontDoor, manualKitchen, energyCom, alarm,
#Day4 - weather, sched, solar, thermo, manualKitchen, frontDoor, manualKitchen, garage, backDoor, milk, garage, frontDoor, manualKitchen, autokitchen, energyCom, alarm, 
#Day5 - weather, solar, sched, thermo, manualKitchen, backDoor, garage, window, frontDoor, autokitchen, manualKitchen, frontDoor, solar, garage, energyCom, alarm, 

# An array of notifications = [ , , , , , , , ]
# Each is a dictionary of notification name, notification text, notification day, notification time, epoch

#this order of the notifications that will be run, in an array
listOfNotificationNames = ['weather', 'sched', 'thermo', 'manualKitchen', 'frontDoor', 'garage', 'window', 'solar', 'backDoor', 'garage', 'frontDoor', 
	'manualKitchen', 'solar', 'energyCom', 'alarm', 'weather', 'sched', 'solar', 'manualKitchen', 'thermo', 'frontDoor', 'garage', 'manualKitchen', 
	'autokitchen', 'backDoor', 'frontDoor', 'manualKitchen', 'garage', 'sensor', 'solar', 'window', 'energyCom', 'alarm', 'weather', 'sched', 'thermo', 
	'manualKitchen', 'frontDoor', 'garage', 'tvenergy', 'window', 'garage', 'backDoor', 'solar', 'frontDoor', 'manualKitchen', 'energyCom', 'alarm', 
	'weather', 'sched', 'solar', 'thermo', 'manualKitchen', 'frontDoor', 'manualKitchen', 'garage', 'backDoor', 'milk', 'garage', 'frontDoor', 'manualKitchen', 
	'autokitchen', 'energyCom', 'alarm', 'weather', 'solar', 'sched', 'thermo', 'manualKitchen', 'backDoor', 'garage', 'window', 'frontDoor', 'autokitchen', 
	'manualKitchen', 'frontDoor', 'solar', 'garage', 'energyCom', 'alarm']

#Dictionary of what the above short names connect to. Take short names, and connect them to full length notifications
listOfNotificationText = {'garage': 'Your garage door has opened', 'frontDoor': 'Your front door has opened', 'backDoor': 'Your back door has opened', 
	'energyCom': 'Your daily energy consumption is: 33.5 kWh', 'thermo': 'Your thermostat has been changed to 73 degrees', 'weather': 'The weather for the day is: Cloudy and cool',
	'solar': 'The solar cell battery status is 52%', 'alarm': 'Tomorrow’s alarm is set for 9am', 'sched': 'Today’s schedule includes: ', 
	'milk': 'Don’t forget to get milk on your way home today.', 'manualKitchen': 'A light in the kitchen has been turned on', 
	'sensor': 'The sensor above the door is not responding.  Please check on its status.', 
	'tvenergy': 'Your television utilizes 2 watts of energy when not in use.  It will be powered off when not in use from now on.',
	'window': 'The bedroom window has been opened to cool the room.', 'autokitchen': 'A light in the kitchen was turned off because no one was active there.'}

#dt = datetime.now()
#print (dt)
#calculating each day of the study
now = datetime.now()
print (now)
day1 = now+timedelta(days=1)
print(day1)
day2 = now+timedelta(days=2)
print(day2)
day3 = now+timedelta(days=3)
print(day3)
day4 = now+timedelta(days=4)
print(day4)
day5 = now+timedelta(days=5)
print(day5)

#day 1 is 15 total notifications total, list of times to schedule notifications
listOfTimesDay1 = [dt.datetime(day1.year, day1.month, day1.day, 9, 00), dt.datetime(day1.year, day1.month, day1.day, 9, 15), 
    dt.datetime(day1.year, day1.month, day1.day, 10, 00), dt.datetime(day1.year, day1.month, day1.day, 10, 10), 
    dt.datetime(day1.year, day1.month, day1.day, 11, 00), dt.datetime(day1.year, day1.month, day1.day, 11, 5), 
    dt.datetime(day1.year, day1.month, day1.day, 13, 00), dt.datetime(day1.year, day1.month, day1.day, 13, 10), 
    dt.datetime(day1.year, day1.month, day1.day, 15, 20), dt.datetime(day1.year, day1.month, day1.day, 17, 00), 
    dt.datetime(day1.year, day1.month, day1.day, 17, 5), dt.datetime(day1.year, day1.month, day1.day, 17, 10), 
    dt.datetime(day1.year, day1.month, day1.day, 20, 50), dt.datetime(day1.year, day1.month, day1.day, 21, 00), 
    dt.datetime(day1.year, day1.month, day1.day, 22, 00)]
#day 2 = 18
listOfTimesDay2 = [dt.datetime(day2.year, day2.month, day2.day, 9, 00), dt.datetime(day2.year, day2.month, day2.day, 9, 15), 
    dt.datetime(day2.year, day2.month, day2.day, 9, 30), dt.datetime(day2.year, day2.month, day2.day, 9, 50),
    dt.datetime(day2.year, day2.month, day2.day, 10, 00), dt.datetime(day2.year, day2.month, day2.day, 10, 10), 
    dt.datetime(day2.year, day2.month, day2.day, 11, 00), dt.datetime(day2.year, day2.month, day2.day, 13, 00),
    dt.datetime(day2.year, day2.month, day2.day, 13, 20), dt.datetime(day2.year, day2.month, day2.day, 15, 20), 
    dt.datetime(day2.year, day2.month, day2.day, 15, 30), dt.datetime(day2.year, day2.month, day2.day, 16, 5), 
    dt.datetime(day2.year, day2.month, day2.day, 15, 28), dt.datetime(day2.year, day2.month, day2.day, 17, 55), 
    dt.datetime(day2.year, day2.month, day2.day, 18, 1), dt.datetime(day2.year, day2.month, day2.day, 19, 13), 
    dt.datetime(day2.year, day2.month, day2.day, 21, 00), dt.datetime(day2.year, day2.month, day2.day, 22, 00)]
#day 3 = 15
listOfTimesDay3 = [dt.datetime(day3.year, day3.month, day3.day, 9, 00), dt.datetime(day3.year, day3.month, day3.day, 9, 15), 
    dt.datetime(day3.year, day3.month, day3.day, 10, 00), dt.datetime(day3.year, day3.month, day3.day, 10, 10), 
    dt.datetime(day3.year, day3.month, day3.day, 11, 00), dt.datetime(day3.year, day3.month, day3.day, 11, 5), 
    dt.datetime(day3.year, day3.month, day3.day, 13, 00), dt.datetime(day3.year, day3.month, day3.day, 13, 10), 
    dt.datetime(day3.year, day3.month, day3.day, 15, 20), dt.datetime(day3.year, day3.month, day3.day, 17, 00), 
    dt.datetime(day3.year, day3.month, day3.day, 17, 5), dt.datetime(day3.year, day3.month, day3.day, 17, 10), 
    dt.datetime(day3.year, day3.month, day3.day, 20, 50), dt.datetime(day3.year, day3.month, day3.day, 21, 00), 
    dt.datetime(day3.year, day3.month, day3.day, 22, 00)]
#day 4 = 16
listOfTimesDay4 = [dt.datetime(day4.year, day4.month, day4.day, 9, 00), dt.datetime(day4.year, day4.month, day4.day, 9, 15), 
    dt.datetime(day4.year, day4.month, day4.day, 9, 50), dt.datetime(day4.year, day4.month, day4.day, 10, 00), 
    dt.datetime(day4.year, day4.month, day4.day, 10, 45), dt.datetime(day4.year, day4.month, day4.day, 13, 10), 
    dt.datetime(day4.year, day4.month, day4.day, 15, 10), dt.datetime(day4.year, day4.month, day4.day, 15, 15), 
    dt.datetime(day4.year, day4.month, day4.day, 15, 19), dt.datetime(day4.year, day4.month, day4.day, 15, 38), 
    dt.datetime(day4.year, day4.month, day4.day, 16, 00), dt.datetime(day4.year, day4.month, day4.day, 16, 20), 
    dt.datetime(day4.year, day4.month, day4.day, 16, 45), dt.datetime(day4.year, day4.month, day4.day, 18, 48), 
    dt.datetime(day4.year, day4.month, day4.day, 21, 00), dt.datetime(day4.year, day4.month, day4.day, 22, 00)]
#day 5 = 16
listOfTimesDay5 = [dt.datetime(day5.year, day5.month, day5.day, 9, 00), dt.datetime(day5.year, day5.month, day5.day, 9, 10), 
    dt.datetime(day5.year, day5.month, day5.day, 9, 15), dt.datetime(day5.year, day5.month, day5.day, 9, 55), 
    dt.datetime(day5.year, day5.month, day5.day, 10, 00), dt.datetime(day5.year, day5.month, day5.day, 12, 3), 
    dt.datetime(day5.year, day5.month, day5.day, 12, 10), dt.datetime(day5.year, day5.month, day5.day, 14, 8), 
    dt.datetime(day5.year, day5.month, day5.day, 14, 30), dt.datetime(day5.year, day5.month, day5.day, 15, 3), 
    dt.datetime(day5.year, day5.month, day5.day, 16, 00), dt.datetime(day5.year, day5.month, day5.day, 16, 45), 
    dt.datetime(day5.year, day5.month, day5.day, 17, 28), dt.datetime(day5.year, day5.month, day5.day, 18, 37), 
    dt.datetime(day5.year, day5.month, day5.day, 21, 00), dt.datetime(day5.year, day5.month, day5.day, 22, 00)]

#test code, can be used to test the notification system
time1 = now+timedelta(seconds=5)
time2 = now+timedelta(seconds=10)
time3 = now+timedelta(seconds=15)
testList = [dt.datetime(now.year, now.month, now.day, time1.hour, time1.minute, time1.second), 
    dt.datetime(now.year, now.month, now.day, time2.hour, time2.minute, time2.second), 
    dt.datetime(now.year, now.month, now.day, time3.hour, time3.minute, time3.second)]

#empty list to be filled
listOfTimeDelays = []

#takes all the lists above, and figures out how long each of them are from when I started the study.
#This creates a giant list of delays from the day I hit start
def calculateMinutesIntoSeconds(testList, listOfTimeDelays):
    i = 0
    for member in testList:
        print(member)
        listOfTimeDelays.append((member-dt.datetime(now.year, now.month, now.day, now.hour, now.minute, now.second)).total_seconds())
        print(listOfTimeDelays[i])
        i= i+1

# Note that you have to specify path to script
#This call runs the notification.

#Create a scheduler.
s = sched.scheduler(time.time, time.sleep)

#Takes a notification text and sends ends out the notification.
def notification(notify='failure to properly fill notification'):
	call(["node", "app.js", notify])
    #call(["node", "app.js", "Whatever my automation just did", tokenOfUser])

#test code. Mostly ignore this
def print_time(a='default'):
    print("From print_time", time.time(), a)


def send_notifications():
    #calculate all of the many times delays
    calculateMinutesIntoSeconds(testList, listOfTimeDelays)
    #calculateMinutesIntoSeconds(listOfTimesDay1, listOfTimeDelays)
    #calculateMinutesIntoSeconds(listOfTimesDay2, listOfTimeDelays)
    #calculateMinutesIntoSeconds(listOfTimesDay3, listOfTimeDelays)
    #calculateMinutesIntoSeconds(listOfTimesDay4, listOfTimeDelays)
    #calculateMinutesIntoSeconds(listOfTimesDay5, listOfTimeDelays)

    print("Time marker for beginning of study: ", time.time())
    #counter needed for calls
    i = 0
    #Just notify people that the study has started.
    s.enter(5, 1, notification, kwargs={'notify': 'Welcome to the WSU Smart Home Study!'})
    #This for loop fills the scheduler with every notification that needs to be sent.
    for member in listOfTimeDelays:
        nitfyication = 'notify: ' + listOfNotificationText[listOfNotificationNames[i]]
        print (nitfyication)
        #takes one of the time delays, a priority (I just made them all 1), and then sends the right notification
        s.enter(member, 1, notification, kwargs={'notify': listOfNotificationText[listOfNotificationNames[i]]})
        #Incriments the counter to make sure you get the next notification
        i = i+1
    #runs the scheduler
    s.run()
    #Marks the end of the study
    print("Time marker for end of study: ",time.time())

#Calls the above method
send_notifications()

 

#Code notes
# sleep this many seconds, then blah
# Get unix epoch of when you started
# now() -> epoch now
# then how many seconds until launch first event
# Make threads - eachnotification has a thread - do the math for each notification - sleep until that exact time - then run, then die

# Once that's built make an array of sleep times from calculating now to each of the above notifications
# sleep = [now to 1, 1 to 2, 2 to 3, 3 to 4, .... n to n+1]
# for i = 0, i < notifications.size(); i++
# 	sleep (sleep_times[i]));
# 	fire_notification(notifications[i])
# 	subprocess will call the .js files
# 	subprocess(["NODE", "app.js", notifications.text[i]]);

# Is there a sleep until epoch method in python?
#sched does a lot of the above

