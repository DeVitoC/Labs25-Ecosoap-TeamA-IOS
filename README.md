# Eco-Soap Bank

[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController) [![Swift Version][swift-image]][swift-url] [![License][license-image]][license-url] [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)

<img src="./EcoSoapBank/App/Images.xcassets/esbLogo.imageset/esbLogo.png" alt="Eco-Soap Bank" width="250" />

Eco-Soap Bank is a humanitarian and environmental non-profit organization working to save, sanitize, and supply recycled hotel soap for the developing world.

The iOS app enables hotel partners to track pickups of recycled supplies, payments, administrative information, and the positive impact their contributions are having on the world.

## Screenshots

<img src="./Assets/screenshot1.png" alt="app screenshot"/> <img src="./Assets/screenshot2.png" alt="app screenshot"/> <img src="./Assets/screenshot3.png" alt="app screenshot"/> <img src="./Assets/screenshot4.png" alt="app screenshot"/> <img src="./Assets/screenshot5.png" alt="app screenshot"/> <img src="./Assets/screenshot6.png" alt="app screenshot"/>

## YouTube Demo

[![YouTube Demo](YouTubeScreenshot.png)](https://youtu.be/B0UO93PjjzE)

## Contributors

- [Jon Bash](http://www.github.com/jonbash)
- [Christopher DeVito](http://www.github.com/DeVitoC)
- [Shawn Gee](http://www.github.com/swift-student)

## Build Instructions

**Requires**:

- [Xcode 11+](https://developer.apple.com/xcode/)
- [Carthage](https://github.com/Carthage/Carthage)

---

1. Clone the project
2. In a terminal in the project directory, run `carthage bootstrap`
3. Open the project in Xcode, build, and run.


[swift-image]: https://img.shields.io/badge/swift-5.2-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

## App Architecture

<img src="./Assets/ESB-App-architecture.png" alt="architecture diagram"/>
<img src="./Assets/ESB-Module-architecture.png" alt="architecture diagram"/>

This app utilizes the coordinator pattern to manage flow between views. For more on this pattern, see the following articles:

- https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
- https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios

## Known issues

- App styling is slightly inconsistent in some spots, especially on iOS14. This is largely due to limitations in SwiftUI. Due to time constraints, these were not able to be addressed. It may be worth replacing all SwiftUI views with UIKit implementations for more customizability if time permits.
- The user cannot currently make payments due to lack of access to a working Stripe backend. Once this is available, Stripe implementation will need to be completed in the Payment module.
