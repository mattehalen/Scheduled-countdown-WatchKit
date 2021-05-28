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
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentTime = GlobalVaribles.sharedInstance.currentTime
            self.title = GlobalVaribles.sharedInstance.title
            self.time = GlobalVaribles.sharedInstance.time
            self.countDownBool = GlobalVaribles.sharedInstance.countDownBool
            self.bgColor = GlobalVaribles.sharedInstance.bgColor
            self.countDownTimeInMS = GlobalVaribles.sharedInstance.countDownTimeInMS
            self.connected = GlobalVaribles.sharedInstance.connected
        }
            
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
                Text("hello").foregroundColor(Color.white)
//                if(service.default_debug_setting){
//                    Text(service.default_ip_setting).foregroundColor(Color.white)
//                    Text(service.default_debug_var1).foregroundColor(Color.white)
//                    //Text(String(service.default_notification_setting)).foregroundColor(Color.white)
//                    //Text(String(service.default_debug_setting)).foregroundColor(Color.white)
//                    Text(var1)
//                }
//                if(service.countDownBool){
//                    Text(service.title).font(.subheadline).foregroundColor(Color.white)
//                    Text(service.time).fontWeight(.heavy).font(.title).foregroundColor(Color.white)
//                }else{
//                    Text(service.currentTime).fontWeight(.heavy).font(.largeTitle).foregroundColor(Color.white)
//                }
            }
        )
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
