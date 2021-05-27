//
//  ContentView.swift
//  Scheduled-countdown
//
//  Created by Administrator on 2021-03-02.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI

final class Print: ObservableObject{
    let BundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"]
    let bundleIdentifier =  Bundle.main.bundleIdentifier

    var number = Int.random(in: 0..<100)
    @Published var debug_number     = ""
    @Published var ipAddress        = ""
    @Published var default_debug_setting = false

    
    init() {
        self.debug_number = BundleVersion as! String
        self.ipAddress = UserDefaults.standard.object(forKey: "ios_ip_address") as! String
        self.default_debug_setting = UserDefaults.standard.object(forKey: "ios_debug") as! Bool
        print("----------> IOS")
        print("bundleIdentifier \(bundleIdentifier ?? "value")")
        print("default_debug_setting \(default_debug_setting)")
        
    }
}


struct ContentView: View {
    @ObservedObject var myPrint = Print()

    var body: some View {
        VStack{
            Text("debug_number \(myPrint.debug_number)")
            Text(myPrint.ipAddress)
            Text(String(myPrint.default_debug_setting))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
