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

final class Service: ObservableObject{
    static let sharedInstance1 = Service()
    
    let BundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"]
    let bundleIdentifier =  Bundle.main.bundleIdentifier
    
    var number = Int.random(in: 0..<100)
    @Published var debug_number     = ""
    @Published var ipAddress        = ""
    @Published var default_debug_setting = false
    
    @Published var currentTime = ""
    @Published var title = ""
    @Published var time = ""
    @Published var countDownBool = true
    @Published var bgColor = "#000000"
    @Published var countDownTimeInMS = 0
    @Published var connected = false
    

    
    init() {
        self.debug_number = BundleVersion as! String
        self.ipAddress = UserDefaults.standard.object(forKey: "ios_ip_address") as! String
        self.default_debug_setting = UserDefaults.standard.object(forKey: "ios_debug") as! Bool
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentTime = GlobalVaribles.sharedInstance.currentTime
            self.title = GlobalVaribles.sharedInstance.title
            self.time = GlobalVaribles.sharedInstance.time
            self.countDownBool = GlobalVaribles.sharedInstance.countDownBool
            self.bgColor = GlobalVaribles.sharedInstance.bgColor
            self.countDownTimeInMS = GlobalVaribles.sharedInstance.countDownTimeInMS
            self.connected = GlobalVaribles.sharedInstance.connected
        }
        
//        print("----------> IOS")
//        print("bundleIdentifier \(bundleIdentifier ?? "value")")
//        print("default_debug_setting \(default_debug_setting)")
        
    }
}


struct ContentView: View {
    @ObservedObject var service = Service()
    lazy var test2 = SocketIOManager()

    var body: some View {
        Color.init(hexStringToUIColor(hex: service.bgColor)).edgesIgnoringSafeArea(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(
            VStack{
                if(service.default_debug_setting){
                    Text("debug_number \(service.debug_number)")
                    Text(service.ipAddress)
                    Text(String(service.default_debug_setting))
                    Text(service.currentTime).fontWeight(.heavy).font(.largeTitle)
                    Text(service.title)
                    Text(service.time)
                    Text(String(service.countDownBool))
                    Text(service.bgColor)
                    Text(String(service.countDownTimeInMS))
                    Text(String(service.connected))
                }
                else{
                    if(service.connected){
                        if(service.countDownBool){
                            Text(service.title).font(.subheadline)
                            Text(service.time).fontWeight(.heavy).font(.title)
                        }else{
                            Text(service.currentTime).fontWeight(.heavy).font(.largeTitle)
                        }
                    }
                    else{
                        Text("Not Connected to Socket.IO Server")
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
