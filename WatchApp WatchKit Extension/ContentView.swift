//
//  ContentView.swift
//  WatchApp WatchKit Extension
//
//  Created by Mathias Halén on 2021-06-22.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI
import SocketIO

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

final class WatchService: ObservableObject{
    static let sharedInstance1 = WatchService()

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
        print("Watch -> Service")
        
        self.debug_number = BundleVersion as! String
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            GlobalVaribles.sharedInstance.startSocket()
            
            self.currentTime = GlobalVaribles.sharedInstance.currentTime
            self.title = GlobalVaribles.sharedInstance.title
            self.time = GlobalVaribles.sharedInstance.time
            self.countDownBool = GlobalVaribles.sharedInstance.countDownBool
            self.bgColor = GlobalVaribles.sharedInstance.bgColor
            self.countDownTimeInMS = GlobalVaribles.sharedInstance.countDownTimeInMS
            self.connected = GlobalVaribles.sharedInstance.connected

        }
        print("----------> WatchOS")
        
    }
}

struct ContentView: View {
    @ObservedObject var service = WatchService()

    var body: some View {
        Color.init(hexStringToUIColor(hex: service.bgColor)).edgesIgnoringSafeArea(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(
            VStack{
                if(service.connected){
                    if(service.countDownBool){
                        Text(service.title).font(.system(size: 15, weight: .medium, design: .default)).foregroundColor(Color.white)
                        Text(service.time).font(.system(size: 30, weight: .heavy, design: .default)).foregroundColor(Color.white)
                    }else{
                        Text(service.currentTime).fontWeight(.heavy).font(.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color.white)
                    }
                }
                else{
                    Text("Not Connected to Socket.IO Server")
                        .fontWeight(.heavy).font(.system(size: 15, weight: .bold, design: .default)).foregroundColor(Color.white)
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
