<h1 align="center">Modernistik Framework</h1>

This framework represents extension, utilizies, design patterns and practices adopted for Modernistik software development in Swift / Objective-C. It has two main components: `Core` and `Hyperdrive`.

## Installation

Modernistik is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Modernistik'
# pod 'Modernistik', '~> 0.3.1' # for Swift 3.2
```

#### Examples
To run the example project, clone the repo, and run `pod install` from the Examples directory first.

## Core SDK
The CoreSDK (`Slate`) has several enhancements and helper methods as Swift extensions to the Swift Standard library, Foundation, CoreGraphics and UIKit. In addition it provides a set of protocols and base components that should be used when creating classes - these are usually prefixed with `Modern`. The CoreSDK is installed by default.

```ruby
pod 'Modernistik'
```

## Hyperdrive SDK
When buildling applications that interact with Hyperdrive or Parse Server, you can include this additional subspec in order to get the additional Parse SDK extensions as well as the Hyperdrive protocol, which should serve as a foundation for buildling a Hyperdrive-connected mobile application. To install this piece of the SDK, include `Modernistik/Hyperdrive` in your pod declaration:

```ruby
pod 'Modernistik/Hyperdrive'
```

## Author

Anthony Persaud, <https://www.modernistik.com>
