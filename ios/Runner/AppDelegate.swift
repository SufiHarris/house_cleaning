import Flutter
import UIKit
import "GoogleMaps/GoogleMaps.h"


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     [GMSServices provideAPIKey:@"AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs"];
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
