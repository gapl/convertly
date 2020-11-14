#  Convertly

Convertly is a currency converter app where user can select any given currency and any amount and see how that converts into other currencies.

![alt text](https://github.com/gapl/convertly/raw/master/screenshots.jpg "Screenshots")

## Quickstart

* This project uses [CurrencyLayer API](https://currencylayer.com/) with a free access key. To unlock full functionality, create an access key with a paid account and update the access key in `CurrencyLayerApi.accessKey`. Free plan limitations:
  * You can only see conversions from USD to other currencies.
  * Selecting any other source currency other than USD results in API access denied.
* Project uses no external dependencies, simply run it on a simulator or actual device.
* Uses Swift 5 with minimum deployment target iOS 14.

## Architecture

* Project uses MVVM architecture, which is best suited for a project of this size.
* Apple's [Combine](https://developer.apple.com/documentation/combine) framework is used for reactive programming instead of any ohter 3rd party library, e.g. [RxSwift](https://github.com/ReactiveX/RxSwift).
* There are no storyboards, xib's or SwiftUI components. All user interface is written in code for easier code review.
* Project uses code injection for modules such as `NetworkingClient` together with Swift protocols. This enables easy component substitution in the future as well as enables testing.
* API calls are defined as an Endpoint protocol to enable generic reuse.
* `NetworkingClient` uses generics to work with any type of API endpoint and response object.
* App supports both light and dark iPhone UI.

## Tests

* There is a `ConvertlyTests` target which includes some basic tests.
* These tests are made only to show how this project enables easy testing of components. It does not actually include a lot of tests, as this is a very simple code base.
