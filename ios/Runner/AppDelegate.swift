import UIKit
import Flutter
import WatchConnectivity

//AppDelegate for FlutterApp
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var session: WCSession?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Call a method to initialize communication channel between Flutter and iOS
        initFlutterChannel()
        
        // Check if WatchConnectivity is supported on the device
        if WCSession.isSupported() {
            //setup the session
            session = WCSession.default;
            session?.delegate = self;
            session?.activate();
        }
        
        //Register Flutter Plugins
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions) //return the overwrid application
    }
    
    //initialize the methodChannel
    private func initFlutterChannel() {
        if let controller = window?.rootViewController as? FlutterViewController {
            //create FlutterMethodChannel
            let channel = FlutterMethodChannel(
                name: "com.rectify.watch",
                binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler({ [weak self] (
                call: FlutterMethodCall,
                result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "flutterToWatch":
                    //handle communication between watchOS and Flutter
                    // Unwrap the session
                    guard let watchSession = self?.session,
                        // Check if the watch is paired
                        watchSession.isPaired,
                        // Check if the watch is reachable
                        watchSession.isReachable,
                          // Unwrap the method arguments
                        let methodData = call.arguments as? [String: Any],
                        // Extract the method name
                        let method = methodData["method"],
                        // Extract the data
                        let data = methodData["data"] else {
                        
                        // Return false if conditions are not met and exit
                        result(false)
                        return
                    }
                    
                    //fill in the values to send to the watch
                    let watchData: [String: Any] = ["method": method, "data": data]
                    
                    // Send the messsage with the data (declared in watchData) to the watch
                    watchSession.sendMessage(watchData, replyHandler: nil, errorHandler: nil)
                    result(true)
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
        }
    }
}




//WCSessionDelegate ist AppDelegate der WatchApp
//connect WCSEssionDelegate to AppDelegate
extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let method = message["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(name: "com.rectify.watch", binaryMessenger: controller.binaryMessenger)
                
                channel.invokeMethod(method, arguments: message)
            }
        }
    }
}
