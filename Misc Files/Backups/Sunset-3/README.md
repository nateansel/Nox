# Sunset-Countdown
This is an app being developed by Chase McCoy and Nathan Ansel to provide an easy way to look up when the sun will set at your location.


# Things to be completed:
- [ ] Optimize code
  - [x] Move sunset time look up to a separate function (maybe even class?)
  - [x] Bring in updated KosherCoda files
- [ ] New design
- [ ] Notification Center widget
- [ ] Local notification support
- [ ] IAP code



_old dictionary structure_
isSet - is the sun set
inHours - if the time left is greater than or equal to 60 mins
inMinutes - if the time left is less than 60 mins
date - string “h:mm a” for when the sun will set
minutes - minutes left until the sun sets
hours - hours left until the sun sets

_new dictionary structure_
time - string “h:mm a” for when the sun will set or rise
       ex. “7:56 PM”
       ex. “5:45 AM”
timeLeft - string, the time left in hours or minutes
           ex. “5¼ hours of sunlight left”
           ex. “32 minutes of sunlight left”
           ex. “2½ hours until the sun rises”
riseOrSet - string, if the sun will rise or set
            ex. “The sun will set at”
            ex. “The sun will rise at”