//
//  GlobalVaribles.swift
//  Scheduled-countdown
//
//  Created by Mathias Halén on 2021-05-27.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import Foundation
import SwiftUI

class GlobalVaribles: NSObject,ObservableObject {
    
    static let sharedInstance = GlobalVaribles()
    @Published var currentTime = "G.Test.C.Time"
    @Published var title = "G.Test.Title"
    @Published var time = "G.Test.Time"
    @Published var countDownBool = true
    @Published var bgColor = "#000000"
    @Published var countDownTimeInMS = 0
    @Published var connected = false
    @Published var default_debug_setting = false
    @Published var ipAddress        = ""
    
    func startSocket(){
        SocketIOManager.sharedInstance.establishConnection()
    }
}
