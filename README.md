# Radar
Radar aims at developing an app through which you could ask for help from nearby strangers, in an anonymous manner.
The initial project is developed keeping in mind the setting of a typical University. Often students find themselves in need of trivial things like a charger for their phone while studying in the library. Instead of travelling all the way back to your hostel, one can simply post for help in the app, in an anonymous manner, and everyone in the nearby areas would recive a notification. Anyone willing to help can reply back on the app, thus saving the person lots of valuable time. The app can also be used to inform students about lost and found items.
This being said, the app can later be expanded to be used in a more general setting, wherein people might ask for first-aid help, or ask other people from their own locality to get them small things from the market. The second use case has the potential to become a major one, given the current situation of the COVID-19 pandemic, as it would help reduce crowding at shops.
While solving the above problems, the app ensures that the privacy of the user is not breached. No personal information related to you, other than your location, is broadcasted unless you choose to do it yourself.

## Example Scenarios
Assume that user A is a student sitting in the library, and I need a c-type charger. Now, using the app, I annonymously broadcast the fact that someone needs a c-type charger in the library. Now, if User B happens to have a c-type charger, and is leaving for the library, responds to A's request that he is willing to help. At this point, the two devices are connected togeather, and now User A might want to reveal the exact location where he wants the charger, or User B might want to specify a location near the library from where User A could pick-up the charger.

In another scenario, suppose that I find an unattended book in the library. I could broadcast information about this book through the app, and then the owner might respond to the broadcast saying that it is his. The devices of the two users are once again connected with each other, and I might want to ask the potential owner some more questions regarding the book to make sure that he is indeed the owner.

## Roadmap
To contribute to this repository, please refer our [Contribution Guidelines](https://github.com/bitsacm/Radar/blob/master/CONTRIBUTING.md)
- Version 0.1.0
    * [ ] Implement a basic Authentication mechanism
    * [ ] Implement Google Nearby Messaging API to broadcast messages for help
    * [ ] Implement Google Nearby Connections API to connect two nearby devices
    * [ ] Implement geo-fencing to get the location that is broadcasted.
   
## Conventions to follow:

 #### Package Structure

- Excluding the main.dart file all the files are to be written within respective packages inside the lib folder of the project.
- A new package is to be created when there is a need to add a new screen or a new functionality that doesn't overlap with the existing ones in the project.
- Avoid adding files directly into the packages and instead create appropriate sub packages with the files inside them.
- Structure the individual layers of code into respective sub packages to ensure model, view and the intermediate layer are properly separated for example, the
Screen widget and the associated helper widgets should be together inside a view sub package, data classes and repository in the model one, etc.
- Any classes, functions, constants that have an app wide use should be present in the util package.
- Try to minimise the number of widgets in a file to one and always prefer keeping the widget tree of screen files lean by moving the sub widgets used in the screen file 
into seperate files as helper widgets.
- Casing Conventions:
  - Package names should be in lower case.
  - Class names should follow Pascal case.
  - Variable and function names should follow Camel case.
