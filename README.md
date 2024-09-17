**Currency Exchange**

Platform - iOS
Frameworks Used - SwiftUI, URLSession, Foundation, UIKit, Cache, User Defaults
Testing - XCTest Framework
Rest API Provider - Open Exchange (Free Account)


Project Overview - This app 'Currency Exchange' is build for iOS platform using swift ui. This app can be used to get currency rates of different country's currencies at a given point on time. 
The rest api request gets the data from 'Open Exchange' server in JSON format and parses the data for the ussage. You can change the selected currency to check other currencies value with respect to the selected currency.


Testing - 
I tried to cover UI tests & Mock Unit tests along with this app. API integration test is also added for the api testing. Although there is some scope of improvements too in the testing part of the app. 


Flow of the app - 
1. On launch, app fetches the data from 'Open Exchange' servers. 
2. The fetched data is cached for future use and then processed to show on UI
3. The amount field is 1 by default, it can be updated as per user's choice & respective data will be updated on UI.
4. By changing the current selected currency.. you can see the other currency values with respect to new selected currency.
5. If the app is previously launched within 30 minutes, the cached data is used.
6. On tap of a currency in list, I will show the current value with respect to new selected currency.


Future Improvements - 
1. For the UI Part, listing can be done in a separat module
2. Async / Awat or Publishers can be used in fetching data








