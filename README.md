# Currency Conversion

### APP Screens

[![app-screens.png](https://i.postimg.cc/NF41gw5Q/app-screens.png)](https://postimg.cc/JHsyqvNF)

### Architecture
The app uses **MVVM** architecture 

[![mvvm-pattern.png](https://i.postimg.cc/gkRWFnyR/mvvm-pattern.png)](https://postimg.cc/QHXPcNyx)

Every viewcontroller will have a viewmodel. The **Viewmodel** will be reponsible for the business logic and will feed the data to the view. The **Viewcontroller** is just a view whereas it's only reponsibility is to render the data provided by the **ViewModel**. The **Model** is just a struct/class that represents the data that will be retrieved in the apis. The complete the binding between the **ViewModel** and **View** the app uses [RXSwift](https://github.com/ReactiveX/RxSwift) to bind and make the **ViewModel** data reactive so that the view will be notified of changes instantaneously.

# Libraries Used
- RxSwift
- RxCocoa
- SnapKit
- R.swift
- Alamofire
- CDAlertView
- RealmSwift

# Implementation

### R.swift

All resource are stored in R.swift

**R.swift** is a tool to get strong typed, autocompleted resources like images, fonts and segues in Swift projects.
- Never type string identifiers again
- Supports images, fonts, storyboards, nibs, segues, reuse identifiers and more
- Compile time checks and errors instead of runtime crashes


### Alamofire

Used as middleware

**Alamofire’s** Session is roughly equivalent in responsibility to the URLSession instance it maintains: it provides API to produce the various Request subclasses encapsulating different URLSessionTask subclasses, as well as encapsulating a variety of configuration applied to all Requests produced by the instance.

### RealmSwift

Used as internal Database/Storage

**Realm Swift** is an easy to use alternative to SQLite and Core Data that makes persisting, querying, and syncing data as simple as working directly with native Swift objects.

[![Screen-Shot-2022-10-18-at-12-25-05-PM.png](https://i.postimg.cc/SRbChxdX/Screen-Shot-2022-10-18-at-12-25-05-PM.png)](https://postimg.cc/mzVt3R0R)

### SnapKit

Used as programatically constraint wrapper

### CDAlertView

Used as Custom Alertview

