# NearBy
 
> NearBy App is a mobile app for displaying realtime nearby places around you.

# App Description:
App displays nearby places around users using the user’s current location specified by Latitude and Longitude. App has two operational modes, “Realtime" and “Single Update”. “Realtime” allows the app to always display to the user the current nearby places based on his location, data should be seamlessly updated if the user moved by 500 m from the location of last retrieved places.
“Single update” mode means the app is updated once in-app is launched and doesn’t update again
User should be able to switch between the two modes, the default mode is “Realtime”.
 
     
# Features
- Location detection in two different modes (RealTime/single time).
- Real-time to detect a continuous location change after 500m.
- Single time mode updates your location one time when the app launches or if you changed the mode from realtime to single time to match the best user experience.
- Continous location update if changed in a distance of 500m from the recent time location updated.
- Displays information about nearby venues around the user in a range of 1000 m (sorted from the nearest to the most fare venue).
- Remember user choices for the next launches. 
- Cash data for venues around you and display it if there is no internet.
- Notify user in case he isn't connected to the internet and try to display cash data.
- Notify the user if his location hasn't any venues.
- Notify the user if the location is unknown to the system to change his location.
- Notify the user if there is a wrong issue.
<img width="250" alt="Screen Shot 2020-07-14 at 10 46 51 AM" src="https://user-images.githubusercontent.com/64661105/87411997-c2c45800-c5c8-11ea-957a-893a5238ce01.png"><img width="265" alt="Screen Shot 2020-07-14 at 10 40 15 AM" src="https://user-images.githubusercontent.com/64661105/87412026-c952cf80-c5c8-11ea-888b-ca139a6f21bc.png"><img width="250" alt="Screen Shot 2020-07-14 at 10 48 13 AM" src="https://user-images.githubusercontent.com/64661105/87412451-5b5ad800-c5c9-11ea-905d-8c9e29e406f0.png">


# <a href="https://developer.foursquare.com/docs/">FourSquare API</a> .
This app uses 2 features of  FourSquare API.
- Getting nearby venues based on location at <a href="https://developer.foursquare.com/docs/venues/explore">exploreEndPoint</a> .
- Getting photos for each venue at . <a href="https://developer.foursquare.com/docs/venues/photos">photosEndPoint</a> .
Important notes:
> Second feature (Getting photos for each venue) which means that you have only 50 requests as the limit for each user account.
> To use the app with the Foursquare API feature you have to get a client id & secret which is core elements for each URL request.

  Example: https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD
  
# How to use

- First, you should make sure that you have a client id & secret key for Foursquare API. If not, go to Foursquare API and create an account to get the client id & secret key.
- Remember that the premium account is the only account that can request more than 50 images (second feature).
- Download NearBy and open it to add your a client id & secret key before the run.
- Open NearBy - > NetworkLayer ->FourSquareEndPoint at the top of file you will capitalized (CLIENTSECRET & CLIENTID).
- Change the values for each element (CLIENTSECRET & CLIENTID). by your keys and run the app.
- To change the number of venues displayed as result, Change the value of limit attribute.
 
 
 
