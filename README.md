#RRuleSwift
Swift library for working with recurrence rules of calendar dates.

![Example](Gif/RRuleSwiftExample.gif "RRuleSwiftExample")

RRuleSwift is based on [rrule.js](https://github.com/jkbrzt/rrule).

##How To Get Started
###Carthage
Specify "RRuleSwift" in your Cartfile:
```ogdl 
github "teambition/RRuleSwift"
```

###Usage
##### Initialization
```swift
var recurrenceRule = RecurrenceRule(recurrenceWithFrequency: .Daily)
recurrenceRule.calendar = ...
recurrenceRule.frequency = ...
recurrenceRule.interval = ...
recurrenceRule.firstDayOfWeek = ...
recurrenceRule.startDate = ...
recurrenceRule.recurrenceEnd = ...
recurrenceRule.bysetpos = ...
recurrenceRule.byyearday = ...
recurrenceRule.bymonth = ...
recurrenceRule.byweekno = ...
recurrenceRule.bymonthday = ...
recurrenceRule.byweekday = ...
recurrenceRule.byhour = ...
recurrenceRule.byminute = ...
recurrenceRule.bysecond = ...
```

#####  Rule form string
```swift
let ruleString = "RRULE:FREQ=MONTHLY;DTSTART=20160404T021000Z;COUNT=5;INTERVAL=2;WKST=MO;BYDAY=MO,TU"
let rule = RecurrenceRule.ruleWithString(ruleString)
```

#####  String form rule
```swift
let ruleString = rule.toRRuleString()
print(ruleString)
// RRULE:FREQ=MONTHLY;DTSTART=20160404T021000Z;COUNT=5;INTERVAL=2;WKST=MO;BYDAY=MO,TU
```

##### Occurrence generator
```swift
let ruleString = "RRULE:FREQ=YEARLY;COUNT=5;WKST=MO"
if let rule = RecurrenceRule.ruleWithString(ruleString) {
    let allDates = rule.allOccurrences()
    print(allDates)
    /*
    2016-04-06 14:26:17 Wed, 
    2017-04-06 14:26:17 Thu, 
    2018-04-06 14:26:17 Fri, 
    2019-04-06 14:26:17 Sat, 
    2020-04-06 14:26:17 Mon
    */

    let date = dateFormatter.dateFromString("2017-01-01 00:00:00 Sun")
    let otherDate = dateFormatter.dateFromString("2020-01-01 00:00:00 Wed")
    let betweenDates = rule.occurrencesBetween(date: date!, andDate: otherDate!)
    print(betweenDates)
    /*
    2017-04-06 14:26:17 Thu, 
    2018-04-06 14:26:17 Fri, 
    2019-04-06 14:26:17 Sat
    */
}
```

## Minimum Requirement
iOS 8.0

## Release Notes
* [Release Notes](https://github.com/teambition/RRuleSwift/releases)

## License
RRuleSwift is released under the MIT license. See [LICENSE](https://github.com/teambition/RRuleSwift/blob/master/LICENSE.md) for details.

## More Info
Have a question? Please [open an issue](https://github.com/teambition/RRuleSwift/issues/new)!
