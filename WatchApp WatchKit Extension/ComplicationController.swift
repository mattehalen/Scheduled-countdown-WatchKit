//
//  ComplicationController.swift
//  WatchApp WatchKit Extension
//
//  Created by Mathias Halén on 2021-06-22.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import ClockKit
import SwiftUI


class ComplicationController: NSObject, CLKComplicationDataSource {
    final class Service: ObservableObject{
        static let sharedInstance1 = Service()
        @Published var currentTime = " first time"
        @Published var title = "Hello"
        @Published var time = "World"
        
        init() {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                print("----------> WatchOS -> ComplicationController \(Date())")
                self.currentTime = GlobalVaribles.sharedInstance.currentTime
                self.title = GlobalVaribles.sharedInstance.title
                self.time = GlobalVaribles.sharedInstance.time
            }
        }
    }
    
    // MARK: - Complication Configuration
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication",
                                      displayName: "Test 2",
                                      supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    // MARK: - Timeline Configuration
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        let currentDate = Date()
        handler(currentDate)
    }
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    // MY STUFF HERE
    //----------------------------------------------------------------------------------------------------
    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        @ObservedObject var service = Service()
        print("-------------------->>>>>>>>>> \(service.currentTime)")
        let date = Date()
        //let currentTime = service.currentTime
        let title = service.title
        let time = service.time
        
        var template: CLKComplicationTemplate!
        let line1 = CLKSimpleTextProvider(text:title)
        let line2 = CLKSimpleTextProvider(text:time)
        //let line3 = CLKSimpleTextProvider(text:currentTime)
        
        if complication.family == .modularLarge {
            template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: line1, body1TextProvider: line2)
            let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            handler(entry)
        }
        else{
            handler(nil)
        }
    }
   
}
