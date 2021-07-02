//
//  ContentView.swift
//  Scheduled-countdown
//
//  Created by Administrator on 2021-03-02.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI

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

final class MyUserDefaults: ObservableObject{
    static let sharedInstance1 = MyUserDefaults()
    
    let BundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"]
    let bundleIdentifier =  Bundle.main.bundleIdentifier
    
    @Published var debug_number     = ""
    @Published var ipAddress        = ""
    @Published var default_debug_setting = false
//
//    @Published var currentTime = ""
//    @Published var title = ""
//    @Published var time = ""
//    @Published var countDownBool = true
//    @Published var bgColor = "#000000"
//    @Published var countDownTimeInMS = 0
//    @Published var connected = false
    
    init() {
        self.debug_number = BundleVersion as! String
        self.ipAddress = UserDefaults.standard.object(forKey: "ios_ip_address") as! String
        self.default_debug_setting = UserDefaults.standard.object(forKey: "ios_debug") as! Bool
//        
//        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
//
//
//            self.currentTime = GlobalVaribles.sharedInstance.currentTime
//            self.title = GlobalVaribles.sharedInstance.title
//            self.time = GlobalVaribles.sharedInstance.time
//            self.countDownBool = GlobalVaribles.sharedInstance.countDownBool
//            self.bgColor = GlobalVaribles.sharedInstance.bgColor
//            self.countDownTimeInMS = GlobalVaribles.sharedInstance.countDownTimeInMS
//            self.connected = GlobalVaribles.sharedInstance.connected
//        }
        
        print("----------> IOS")
        
    }
}

func openSettings(){
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
}


struct ContentView: View {
    var settings = MyUserDefaults()
    @StateObject var service = GlobalVaribles.sharedInstance

    var body: some View {
        Color.init(hexStringToUIColor(hex: service.bgColor)).edgesIgnoringSafeArea(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(
            VStack{
                if(settings.default_debug_setting){
                    Text("Debug")
                        .fontWeight(.heavy)
                        .font(.system(size: 70, weight: .bold, design: .default))
                        .foregroundColor(Color.white)
                    Spacer()
                    Group{
                        Text("debug_number = \(settings.debug_number)")
                        Text("ipAddress = \(settings.ipAddress)").foregroundColor(Color.white)
                        Text("default_debug_setting = \(String(settings.default_debug_setting))").foregroundColor(Color.white)
                    }
                    Group{
                        Text("currentTime = \(service.currentTime)").fontWeight(.heavy).font(.largeTitle).foregroundColor(Color.white)
                        Text("title = \(service.title)").foregroundColor(Color.white)
                        Text("time = \(service.time)").foregroundColor(Color.white)
                        Text("countDownBool = \(String(service.countDownBool))").foregroundColor(Color.white)
                        Text("bgColor = \(service.bgColor)").foregroundColor(Color.white)
                        Text("countDownTimeInMS = \(String(service.countDownTimeInMS))").foregroundColor(Color.white)
                        Text("connected = \(String(service.connected))").foregroundColor(Color.white)
                    }
                    Spacer()
                    Button("Open Settings", action: { openSettings() } )
                        .font(.largeTitle)
                        .frame(width: 400, height: 100, alignment: .center)
                }
                else{
                    if(service.connected){
                        if(service.countDownBool){
                            Text(service.title).font(.system(size: 30, weight: .medium, design: .default)).foregroundColor(Color.white)
                            Text(service.time).font(.system(size: 70, weight: .heavy, design: .default)).foregroundColor(Color.white)
                        }else{
                            Text(service.currentTime).fontWeight(.heavy).font(.system(size: 90, weight: .bold, design: .default)).foregroundColor(Color.white)
                        }
                    }
                    else{
                        Text("Not Connected to Socket.IO Server")
                            .fontWeight(.heavy).font(.system(size: 45, weight: .bold, design: .default)).foregroundColor(Color.white)
                        Spacer()
                        Group{
                            Text("1. Check ipaddress in setting -> PUSH Open Settings Button")
                                .foregroundColor(Color.white)
                            Text("2. Check that desktop APP is running and Online")
                                .foregroundColor(Color.white)
                            Text("3.Remember Write ipaddress like 192.168.0.1:3000")
                                .foregroundColor(Color.white)
                        }
                        Spacer()

                        Button("Open Settings", action: { openSettings() } )
                            .font(.largeTitle)
                            .frame(width: 400, height: 100, alignment: .center)
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
