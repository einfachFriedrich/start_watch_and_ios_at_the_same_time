//
//  ViewModel.swift
//  watchapp Watch App
//
//  Created by Friedrich Vorländer on 09.05.24.
//

import Foundation
import WatchConnectivity

@Observable
class WatchViewModel: NSObject{
    var session: WCSession
    
    //counter doesn't get changed from the Button
    //counter gets set only through the message channel from swift
    var counter = 0
    
    // Add more cases if you have more receive method
    enum WatchReceiveMethod: String {
        case sendCounterToNative
    }
    
    // Add more cases if you have more sending method
    enum WatchSendMethod: String {
        case sendCounterToFlutter
    }
    
    //init WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    //declares the structure for the message that gets send to Flutter
    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        sendMessage(for: method.rawValue, data: data)
    }
    
}


//Sends Data from WatchOS to AppDelegate (to later push to Flutter)
extension WatchViewModel: WCSessionDelegate {
    
    //func necessary to make it conform to app delegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // data that gets passed from flutter to the AppDelegate File gets recieved on the Watch through this function
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            // if data should be send to the native side
            case .sendCounterToNative:
                //recieve the counter value from Flutter
                self.counter = (message["data"] as? Int) ?? 0 //if flutter didn't send something the value is 0
            }
        }
    }
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}
