//
//  SocketManager.swift
//  Scheduled-countdown
//
//  Created by Mathias Halén on 2021-05-26.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let defaults = UserDefaults.init(suiteName: "group.com.Scheduled-countdown.settings")
    lazy var default_ip = defaults?.string(forKey: "ip_adress") ?? "192.168.8.175"
    lazy var ipString : String = "http://\(default_ip):3000"
    
    lazy var manager = SocketManager(socketURL: URL(string: ipString)!, config: [.log(false),.compress,.path("/ws")])

    var socket: SocketIOClient!

    override init() {
    super.init()

        socket = manager.defaultSocket

        //Listener to capture any message that your server emits for "emitMessage" key. You can add multiple listeners to capture various emits from your server.
        socket.on("message") { (data, ack) in
            //print("Socket Ack: \(ack)")
            //print("Emitted Data: \(data)")
            //Do something with the data you got back from your server.
        }
    }

    //Function for your app to emit some information to your server.
    func emit(message: [String: Any]){
        print("Sending Message: \([message])")
        socket.emit("message", with: [message])
    }

    //Function to establish the socket connection with your server. Generally you want to call this method from your `Appdelegate` in the `applicationDidBecomeActive` method.
    func establishConnection() {
        socket.connect()
        print("Connected to Socket !")
    }

    //Function to close established socket connection. Call this method from `applicationDidEnterBackground` in your `Appdelegate` method.
    func closeConnection() {
        socket.disconnect()
        print("Disconnected from Socket !")
    }
    
    func on(message: [String: Any]){
        print("Reciving Message: \([message])")
    }
}
