//
//  ContentView.swift
//  WatchApp WatchKit Extension
//
//  Created by Mathias Halén on 2021-06-22.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI
import SocketIO

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
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentTime = GlobalVaribles.sharedInstance.currentTime
            self.title = GlobalVaribles.sharedInstance.title
            self.time = GlobalVaribles.sharedInstance.time
            self.countDownBool = GlobalVaribles.sharedInstance.countDownBool
            self.bgColor = GlobalVaribles.sharedInstance.bgColor
            self.countDownTimeInMS = GlobalVaribles.sharedInstance.countDownTimeInMS
            self.connected = GlobalVaribles.sharedInstance.connected

            //GlobalVaribles.sharedInstance.startSocket()
        }
        print("----------> WatchOS")
        
    }
}

struct ContentView: View {
    @ObservedObject var service = WatchService()

    var body: some View {
        VStack{
            Text("Scheduled countDown - 5")
                .padding()
            Text("Scheduled countDown - \(service.currentTime)")
                .padding()
                
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
