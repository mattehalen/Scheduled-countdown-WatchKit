//
//  SocketManager.swift
//  Scheduled-countdown
//
//  Created by Mathias Halén on 2021-05-26.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject,ObservableObject {
    @Published var currentTime = "first string of currentTime"
    static let sharedInstance = SocketIOManager()
    
    lazy var default_ip = UserDefaults.standard.object(forKey: "ios_ip_address")
    lazy var ipString : String = "http://\(default_ip ?? "127.0.0.1"):3000"
    
    lazy var manager = SocketManager(socketURL: URL(string: ipString)!, config: [.log(false),.compress,.path("/ws")])

    var socket: SocketIOClient!
    

    override init() {
    super.init()
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("message") { (data, ack) in
            if let getSocket = data as? [[String:Any]]{
                if let socketType = getSocket[0]["type"] as? String {
                    //print(socketType)
                    //--------------------------------------------------------------------------------
                    if socketType == "currentTime"{
                        let socketMessage = getSocket[0]["message"]
                        DispatchQueue.main.async {
                            self.currentTime = socketMessage as! String
                            //print(self.currentTime)
                            GlobalVaribles.sharedInstance.currentTime = socketMessage as! String
                        }
                    }
                    //--------------------------------------------------------------------------------
                    if socketType == "countDown"{
                        let socketObj = getSocket[0]["message"] as? [String: Any]
                        let socketTime = socketObj!["time"] as? String
                        let socketTitle = socketObj!["title"] as? String
                        let socketBool = socketObj!["bool"] as? Bool
                        
                        let socketColorObj = socketObj!["colors"] as? [String: Any]
                        let socketDownColor = socketColorObj!["countDownColor"] as? String
                        let socketUpColor = socketColorObj!["countUpColor"] as? String
                        let socketNormalColor = "#000000"

                        var socketCountDownInMs = -1000000
                        if socketObj!["countDownTimeInMS"] as? Int != nil {
                            socketCountDownInMs = socketObj!["countDownTimeInMS"] as! Int
                        }else{
                        }
                        
                        let socketCountUp = socketObj!["CountUp"] as! Int
                        
                        if (socketCountDownInMs > (-3*60000) && socketCountDownInMs < 0 ){
                            GlobalVaribles.sharedInstance.bgColor = socketDownColor!
                        } else if(socketCountDownInMs > 0 && socketCountDownInMs < (socketCountUp)){
                            GlobalVaribles.sharedInstance.bgColor = socketUpColor!
                        }else{
                            GlobalVaribles.sharedInstance.bgColor = socketNormalColor
                        }
                        
                        DispatchQueue.main.async {
                            GlobalVaribles.sharedInstance.title = socketTitle ?? ""
                            GlobalVaribles.sharedInstance.time = socketTime!
                            GlobalVaribles.sharedInstance.countDownBool = socketBool!
                        }
                    }
                    //--------------------------------------------------------------------------------
                }
            }
            //print("Socket Ack: \(ack)")
            //print("Emitted Data: \(data)")
            //Do something with the data you got back from your server.
        }
    }

    func emit(message: [String: Any]){
        print("Sending Message: \([message])")
        socket.emit("message", with: [message])
    }

    func establishConnection() {
        socket.connect()
        print("Connected to Socket !")
        GlobalVaribles.sharedInstance.connected = true
    }

    func closeConnection() {
        socket.disconnect()
        print("Disconnected from Socket !")
        GlobalVaribles.sharedInstance.connected = false
    }
    
    func on(message: [String: Any]){
        print("Reciving Message: \([message])")
    }
}
