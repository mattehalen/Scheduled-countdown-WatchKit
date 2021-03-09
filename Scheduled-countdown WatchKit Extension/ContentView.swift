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
import UserNotifications

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
    @Published var default_debug_setting = false
    @Published var default_debug_var1 = ""
    
    let defaults = UserDefaults.init(suiteName: "group.com.Scheduled-countdown.settings")
    
    lazy var default_ip = defaults?.string(forKey: "ip_adress") ?? "Nothing"
    lazy var ipString : String = "http://\(default_ip):3000"
    lazy var  manager = SocketManager(socketURL: URL(string: ipString)!, config: [.log(false),.compress,.path("/ws")])

    init(){
        print(default_ip)
        
        let default_notification    = defaults?.bool(forKey: "use_notifications")
        if(default_notification == true){
            self.default_notification_setting = true
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        }else if(default_notification == false){
            self.default_notification_setting = false
        }

        let default_debug = defaults?.bool(forKey: "debug")
        if(default_debug == true){
            self.default_debug_setting = true
        }else if(default_debug == false){
            self.default_debug_setting = false
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
                            //localNotis(countdown: socketCountDownInMs)
                            
                            //---------- Local UNUserNotificationCenter
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            let fiveMin     = ((socketCountDownInMs/1000)+(5*60)) * -1
                            if(fiveMin > 0){
                                self?.default_debug_var1 = String(fiveMin)
                                
                                let content_five = UNMutableNotificationContent()
                                content_five.title = "5 min"
                                content_five.subtitle = ""
                                content_five.sound = UNNotificationSound.default
                                let trigger_five = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fiveMin), repeats: false)
                                let request_five = UNNotificationRequest(identifier: UUID().uuidString, content: content_five, trigger: trigger_five)
                                UNUserNotificationCenter.current().add(request_five)
                                
                            }
                            //--------------------------------------------------
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
                        }
                    }
                }
            }
            
            
        }
        socket.connect()
    }
}

func localNotis(countdown:Int) -> Int {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

    let fiveMin     = ((countdown + (5*60)) / 1000) * -1
    let fourMin     = ((countdown + (4*60)) / 1000) * -1
    let threeMin    = ((countdown + (3*60)) / 1000) * -1
    let twoMin      = ((countdown + (2*60)) / 1000) * -1
    let oneMin      = ((countdown + (1*60)) / 1000) * -1
    
    //---------- 5min
    if(fiveMin > 0){
        let content_five = UNMutableNotificationContent()
        content_five.title = "5 min"
        content_five.subtitle = ""
        content_five.sound = UNNotificationSound.default
        let trigger_five = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fiveMin), repeats: false)
        let request_five = UNNotificationRequest(identifier: UUID().uuidString, content: content_five, trigger: trigger_five)
        UNUserNotificationCenter.current().add(request_five)
    }
    //---------- 4min
    if(fourMin > 0){
        let content_four = UNMutableNotificationContent()
        content_four.title = "4 min"
        content_four.subtitle = ""
        content_four.sound = UNNotificationSound.default
        let trigger_four = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fourMin), repeats: false)
        let request_four = UNNotificationRequest(identifier: UUID().uuidString, content: content_four, trigger: trigger_four)
        UNUserNotificationCenter.current().add(request_four)
    }
    //---------- 3min
    if(threeMin > 0){
        let content_three = UNMutableNotificationContent()
        content_three.title = "3 min"
        content_three.subtitle = ""
        content_three.sound = UNNotificationSound.default
        let trigger_three = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(threeMin), repeats: false)
        let request_three = UNNotificationRequest(identifier: UUID().uuidString, content: content_three, trigger: trigger_three)
        UNUserNotificationCenter.current().add(request_three)
    }
    //---------- 2min
    if(twoMin > 0){
        let content_two = UNMutableNotificationContent()
        content_two.title = "2 min"
        content_two.subtitle = ""
        content_two.sound = UNNotificationSound.default
        let trigger_two = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(twoMin), repeats: false)
        let request_two = UNNotificationRequest(identifier: UUID().uuidString, content: content_two, trigger: trigger_two)
        UNUserNotificationCenter.current().add(request_two)
    }
    //---------- 1min
    if(oneMin > 0){
        let content_one = UNMutableNotificationContent()
        content_one.title = "1 min"
        content_one.subtitle = ""
        content_one.sound = UNNotificationSound.default
        let trigger_one = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(oneMin), repeats: false)
        let request_one = UNNotificationRequest(identifier: UUID().uuidString, content: content_one, trigger: trigger_one)
        UNUserNotificationCenter.current().add(request_one)
    }
    

    return countdown
}

struct ContentView: View {
    @ObservedObject var service = Service()
    @State var ipAdress: String = ""
    var ipText = UserDefaults.standard.object(forKey: "ipAdress")
    @State var var1: String = "Start"

    var body: some View {
        Color.init(hexStringToUIColor(hex: service.bgColor)).edgesIgnoringSafeArea(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(
            VStack{
                if(service.default_debug_setting){
                    Text(service.default_ip_setting)
                    Text(service.default_debug_var1)
                    //Text(String(service.default_notification_setting))
                    //Text(String(service.default_debug_setting))
                    Text(var1)
                }
                if(service.countDownBool){
                    Text(service.title).font(.subheadline)
                    Text(service.time).fontWeight(.heavy).font(.title)
                }else{
                    Text(service.currentTime).fontWeight(.heavy).font(.largeTitle)
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
