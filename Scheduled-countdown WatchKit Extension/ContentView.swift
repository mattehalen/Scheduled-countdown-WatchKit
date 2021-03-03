//
//  ContentView.swift
//  Scheduled-countdown WatchKit Extension
//
//  Created by Administrator on 2021-03-02.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI
import UIKit
import SocketIO
import Foundation

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
final class Service: ObservableObject{
    
    
        
    @Published var currentTime = ""
    @Published var title = ""
    @Published var time = ""
    @Published var countDownBool = true
    @Published var bgColor = "#000000"
    @Published var countDownTimeInMS = 0
    @Published var ip = UserDefaults.standard.object(forKey: "ipAdress")
    @Published var connected = false
    @Published var default_ip_setting = ""
    @Published var default_notification_setting = true
    
    lazy var ipString : String = "http://172.20.10.4:3000"
    
    private lazy var manager = SocketManager(socketURL: URL(string: ipString)!, config: [.log(false),.compress,.path("/ws")])
    
    let defaults = UserDefaults.init(suiteName: "group.com.Scheduled-countdown.settings")

    
    init(){
        let default_ip = defaults?.string(forKey: "ip_adress") ?? "Nothing"
        let default_notification = defaults?.bool(forKey: "use_notifications")
        
        if(default_notification == true){
            self.default_notification_setting = true
        }else if(default_notification == false){
            self.default_notification_setting = false
        }
        self.default_ip_setting = String(default_ip)
        
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect){ (data, ack) in
            print("Connected")
            self.connected = true
        }
        socket.on(clientEvent: .error){ (data, ack) in
            print("error")
            self.connected = false
        }
        
        socket.on("message"){ [weak self] (data,ack) in
            if let getSocket = data as? [[String:Any]]{
                if let socketType = getSocket[0]["type"] as? String {
                    
                    if socketType == "currentTime"{
                        let socketMessage = getSocket[0]["message"]
                        DispatchQueue.main.async {
                            self!.currentTime = socketMessage as! String
                        }
                    }
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
                        //let socketCountDown = socketObj!["CountDown"] as! Int
                        
                        if (socketCountDownInMs > (-3*60000) && socketCountDownInMs < 0 ){
                            self!.bgColor = socketDownColor!
                        } else if(socketCountDownInMs > 0 && socketCountDownInMs < (socketCountUp)){
                            self!.bgColor = socketUpColor!
                        }else{
                            self!.bgColor = socketNormalColor
                        }
                        
                                        
                        //-------------------
                        if(socketCountDownInMs > (-5*60000) && socketCountDownInMs < (-5*60000+1000)){
                            WKInterfaceDevice.current().play(.success)
                        }
                        if(socketCountDownInMs > (-4*60000) && socketCountDownInMs < (-4*60000+1000)){
                            WKInterfaceDevice.current().play(.success)

                        }
                        if(socketCountDownInMs > (-3*60000) && socketCountDownInMs < (-3*60000+1000)){
                            WKInterfaceDevice.current().play(.success)

                        }
                        if(socketCountDownInMs > (-2*60000) && socketCountDownInMs < (-2*60000+1000)){
                          WKInterfaceDevice.current().play(.success)

                        }
                        if(socketCountDownInMs > (-1*60000) && socketCountDownInMs < (-1*60000+1000)){
                            WKInterfaceDevice.current().play(.success)
                        }
                        //-------------------
                        DispatchQueue.main.async {
                            self!.title = socketTitle ?? ""
                            self!.time = socketTime!
                            self!.countDownBool = socketBool!
                            self!.ip = self!.ipString
                        }
                    }
                }
            }
            
            
        }
        socket.connect()
    }
}

struct ContentView: View {
    @ObservedObject var service = Service()
    @State var ipAdress: String = ""
    var ipText = UserDefaults.standard.object(forKey: "ipAdress")

    var body: some View {
        Color.init(hexStringToUIColor(hex: service.bgColor)).edgesIgnoringSafeArea(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(
            VStack{
                Text(service.default_ip_setting)
                Text(String(service.default_notification_setting))
                if(service.connected){
                    if(service.countDownBool){
                        Text(service.title).font(.subheadline)
                        Text(service.time).fontWeight(.heavy).font(.title)
                    }else{
                        Text(service.currentTime).fontWeight(.heavy).font(.largeTitle)
                    }
                    
                    
                }else{
                    TextField("Enter ipAdress...", text: $ipAdress, onEditingChanged: { (changed) in
                        print("ipAdress onEditingChanged - \(changed)")
                    }) {
                        print("ipAdress onCommit")
                        UserDefaults.standard.set(self.ipAdress, forKey: "ipAdress")
                    }
                    Text("current IP \(ipAdress)")
                    Button("SendIpAdress"){
                    
                }
                
                    
                    
                }
                
                
            }
        )
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
