# Pizzaiolo iOS

Pizzaiolo is a demo iOS app built with Swift 3 and Xcode 8. I've been occassionally working for iOS since late 2013, but have never invested that much to be able to experiment with techniques and architectural choices. This app gave me the liberty of doing so.

![pizzaiolo](https://cloud.githubusercontent.com/assets/374519/24907143/31461114-1ebb-11e7-995c-3ad6113cc6e5.gif)

While being a fairly simple app, I've learnt so much in there that I wrote an article describing the different parts and how they're put together. If you're interested in [ReactiveX](https://github.com/ReactiveX/RxSwift), MVVM or [Realm](https://realm.io/), check the source code and maybe you'll find something new. Especially to newcomers to ReactiveX, this will put into perspective how observers can be set up to handle networking and merging with local data, binding to UI elements, creating reactive collectionviews with just a few lines, etc. In addition, you'll find out how I built views programmatically, used [SnapKit](http://snapkit.io/docs/) for Autolayout constraints, created custom viewcontroller transitions, a custom launch screen animation, worked with tableviews, collectionviews, scrollviews and much more.

## How to use

Opening the app in your own computer is pretty simple; it just needs a tiny bit of prep work. Make sure you have Xcode 8+ installed and if you don't, it's time to upgrade anyway. This project uses [CocoaPods](https://cocoapods.org/) for dependency management, so you'll need that too. If you aren't using it already in your project, take my word and give it a try.

1. Clone the repository

```bash
$ git clone [repo-name-placeholder]
```

2. Install dependencies. This may take a few minutes.

```bash
$ cd path/to/project
$ pod install
```

3. Open `Pizzaiolo.xcworkspace` with Xcode.

4. Run the Node.js server to fill the app with data, so you can test it in the simulator or device. Instructions on the [pizzaiolo-server repository](https://github.com/fadion/pizzaiolo-server). 

## Disclaimer

The "Pizzaiolo" name is a made up name for this specific project. It doesn't refer to any existing brand or company.
