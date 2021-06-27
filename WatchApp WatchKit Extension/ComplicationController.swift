/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A controller that configures and updates the complications.
*/

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Timeline Configuration
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Indicate that the app can provide timeline entries for the next 24 hours.
        handler(Date().addingTimeInterval(24.0 * 60.0 * 60.0))
    }
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // This is potentially sensitive data. Hide it on the lock screen.
        handler(.hideOnLockScreen)
    }
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptor = CLKComplicationDescriptor(identifier: "Scheduled_Countdown",
                                                   displayName: "Scheduled Countdown",
                                                   supportedFamilies: CLKComplicationFamily.allCases)
        handler([descriptor])
    }
    
    // MARK: - Timeline Population
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        handler(createTimelineEntry(forComplication: complication, date: Date()))
    }
    
    // Return future timeline entries.
    func getTimelineEntries(for complication: CLKComplication,
                            after date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        
        let fiveMinutes = 1.0 * 60
        let twentyFourHours = 24.0 * 60.0 * 60.0
        
        var entries = [CLKComplicationTimelineEntry]()
        
        var current = date.addingTimeInterval(fiveMinutes)
        let endDate = date.addingTimeInterval(twentyFourHours)
        
        while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
            entries.append(createTimelineEntry(forComplication: complication, date: current))
            current = current.addingTimeInterval(fiveMinutes)
        }
        
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let future = Date().addingTimeInterval(25.0 * 60.0 * 60.0)
        let template = createTemplate(forComplication: complication, date: future)
        handler(template)
    }

    // MARK: - Private Methods
    private func createTimelineEntry(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry {
        
        // Get the correct template based on the complication.
        let template = createTemplate(forComplication: complication, date: date)
        
        // Use the template and date to create a timeline entry.
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    private func createTemplate(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTemplate {
        switch complication.family {
        case .modularSmall:
            return createModularSmallTemplate(forDate: date)
        case .modularLarge:
            return createModularLargeTemplate(forDate: date)
        case .utilitarianSmall, .utilitarianSmallFlat:
            return createUtilitarianSmallFlatTemplate(forDate: date)
        case .utilitarianLarge:
            return createUtilitarianLargeTemplate(forDate: date)
        case .circularSmall:
            return createCircularSmallTemplate(forDate: date)
        case .extraLarge:
            return createExtraLargeTemplate(forDate: date)
        case .graphicCorner:
            return createGraphicCornerTemplate(forDate: date)
        case .graphicCircular:
            return createGraphicCircleTemplate(forDate: date)
        case .graphicRectangular:
            return createGraphicRectangularTemplate(forDate: date)
        case .graphicBezel:
            return createGraphicBezelTemplate(forDate: date)
        case .graphicExtraLarge:
            if #available(watchOSApplicationExtension 7.0, *) {
                return createGraphicExtraLargeTemplate(forDate: date)
            } else {
                fatalError("Graphic Extra Large template is only available on watchOS 7.")
            }
        @unknown default:
            fatalError("*** Unknown Complication Family ***")
        }
    }
    
    // Return a modular small template.
    private func createModularSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
        var title = CLKSimpleTextProvider(text: "Loading")
        var time = CLKSimpleTextProvider(text: "...")
        GlobalVaribles.sharedInstance.startSocket()

        
        if(GlobalVaribles.sharedInstance.title == "G.Test.Title"){
            print(">>>>> Lets see if we can change title depeding on ....")
            
        }else{
            title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        }
        if(GlobalVaribles.sharedInstance.time == "G.Test.Time"){
            

            
        }else{
            time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        }
        
        // Create the template using the providers.
        return CLKComplicationTemplateModularSmallStackText(line1TextProvider: title,
                                                            line2TextProvider: time)
    }
    private func createModularLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        let titleTextProvider = CLKSimpleTextProvider(text: "Scheduled Countdown")
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: titleTextProvider,
                                                               body1TextProvider: title,
                                                               body2TextProvider: time)
    }
    private func createUtilitarianSmallFlatTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", title, time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: combinedMGProvider)
    }
    private func createUtilitarianLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", title, time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: combinedMGProvider)
    }
    private func createCircularSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateCircularSmallStackText(line1TextProvider: title,
                                                             line2TextProvider: time)
    }
    private func createExtraLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: title,
                                                          line2TextProvider: time)
    }
    private func createGraphicCornerTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let leadingValueProvider = CLKSimpleTextProvider(text: "0")
        leadingValueProvider.tintColor = .green
        
        let trailingValueProvider = CLKSimpleTextProvider(text: "500")
        trailingValueProvider.tintColor = .blue
        
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", title, time)
        
        let percentage = Float(0.5)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 300.0 / 500.0, 450.0 / 500.0] as [NSNumber],
                                                   fillFraction: percentage)
        
        // Create the template using the providers.
        return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider,
                                                             leadingTextProvider: leadingValueProvider,
                                                             trailingTextProvider: trailingValueProvider,
                                                             outerTextProvider: combinedMGProvider)
    }
    private func createGraphicCircleTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let percentage = Float(0.5)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 300.0 / 500.0, 450.0 / 500.0] as [NSNumber],
                                                   fillFraction: percentage)
        
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        // Create the template using the providers.
        return CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider,
                                                                         bottomTextProvider: title,
                                                                         centerTextProvider: time)
    }
    private func createGraphicRectangularTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let titleTextProvider = CLKSimpleTextProvider(text: "Coffee Tracker", shortText: "Coffee")
        
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", title, time)
        
        let percentage = Float(0.5)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 300.0 / 500.0, 450.0 / 500.0] as [NSNumber],
                                                   fillFraction: percentage)
        
        // Create the template using the providers.
        
        return CLKComplicationTemplateGraphicRectangularTextGauge(headerTextProvider: titleTextProvider,
                                                                  body1TextProvider: combinedMGProvider,
                                                                  gaugeProvider: gaugeProvider)
    }
    private func createGraphicBezelTemplate(forDate date: Date) -> CLKComplicationTemplate {
        
        // Create a graphic circular template with an image provider.
        let circle = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: #imageLiteral(resourceName: "CoffeeGraphicCircular")))
        
        // Create the text provider.
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        let separator = NSLocalizedString(",", comment: "Separator for compound data strings.")
        let textProvider = CLKTextProvider(format: "%@%@ %@",
                                           title,
                                           separator,
                                           time)
        
        // Create the bezel template using the circle template and the text provider.
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circle,
                                                               textProvider: textProvider)
    }
    private func createGraphicExtraLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        
        // Create the data providers.
        let percentage = Float(0.5)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 300.0 / 500.0, 450.0 / 500.0] as [NSNumber],
                                                   fillFraction: percentage)
        
        let title = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.title)
        let time = CLKSimpleTextProvider(text: GlobalVaribles.sharedInstance.time)
        
        return CLKComplicationTemplateGraphicExtraLargeCircularOpenGaugeSimpleText(
            gaugeProvider: gaugeProvider,
            bottomTextProvider: title,
            centerTextProvider: time)
    }
}
