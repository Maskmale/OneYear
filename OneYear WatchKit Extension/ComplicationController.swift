//
//  ComplicationDataSource.swift
//  OneYear WatchKit Extension
//
//  Created by Lojii on 2018/11/23.
//  Copyright © 2018 Lojii. All rights reserved.
//

import WatchKit
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    

    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void){
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void){
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void){
        let currentDate = Date()
        let endDate = currentDate.addingTimeInterval(TimeInterval(10))
        handler(endDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void){
        handler(.showOnLockScreen)
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void){
        let timeline:CLKComplicationTimelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getTemplate(complication: complication)!)
        handler(timeline)
    }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void){
        let template = getTemplate(complication: complication)
        handler(template)
    }
    
    func getTemplate(complication: CLKComplication) -> CLKComplicationTemplate?{
        var template:CLKComplicationTemplate? = nil
        let year = OneYear.share
        let per = year.currentProgressValue()
        let fraction = Float(per/100)
        let textProvider = String(format:"%.d",Int(per))
        let titleText = NSLocalizedString("Remaining 0", comment: "") + "\(year.year)" + NSLocalizedString("Remaining 1", comment: "")
        switch complication.family {
        case .circularSmall:
            let temp = CLKComplicationTemplateCircularSmallRingText()
            temp.fillFraction = fraction
            temp.ringStyle = .open
            temp.textProvider = CLKSimpleTextProvider(text: textProvider)
            template = temp
            break
        case .modularSmall:
            let temp = CLKComplicationTemplateModularSmallRingText()
            temp.textProvider = CLKSimpleTextProvider(text: textProvider)
            temp.fillFraction = fraction
            temp.ringStyle = .closed
            template = temp
            break
        case .modularLarge:
            let temp = CLKComplicationTemplateModularLargeTallBody()
            temp.headerTextProvider = CLKSimpleTextProvider(text: titleText)
            temp.bodyTextProvider = CLKSimpleTextProvider(text: "\(String(format:"%.2f",per))%")
            template = temp
            break
        case .utilitarianSmall:
            let temp = CLKComplicationTemplateUtilitarianSmallRingText()
            temp.textProvider = CLKSimpleTextProvider(text: textProvider)
            temp.fillFraction = fraction
            temp.ringStyle = .open
            template = temp
            break
        case .utilitarianSmallFlat:
            let temp = CLKComplicationTemplateUtilitarianSmallFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(String(format:"%.2f",per))%")
            template = temp
            break
        case .utilitarianLarge:
            let temp = CLKComplicationTemplateUtilitarianLargeFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(titleText)\(String(format:"%.2f",per))%")
            template = temp
            break
        case .extraLarge:
            let temp = CLKComplicationTemplateExtraLargeRingText()
            temp.fillFraction = fraction
            temp.ringStyle = .open
            temp.textProvider = CLKSimpleTextProvider(text: "\(String(format:"%.2f",per))%")
            template = temp
            break
        case .graphicCorner:
//            let temp = CLKComplicationTemplateGraphicCornerStackText() // 双行文件，可以动态变化
//            temp.outerTextProvider = CLKSimpleTextProvider(text: "\(year.year)")
//            temp.innerTextProvider = CLKSimpleTextProvider(text: "\(String(format:"%.6f",per))%")
            let temp = CLKComplicationTemplateGraphicCornerGaugeText() // 文字与进度
            temp.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: fraction)
            temp.outerTextProvider = CLKSimpleTextProvider(text: "\(String(format:"%.1f",per))%")//CLKSimpleTextProvider(text: "\(year.year)")
//            temp.leadingTextProvider = CLKSimpleTextProvider(text: "\(String(format:"%.1f",per))%")
            template = temp
            break
        case .graphicBezel:
            let temp = CLKComplicationTemplateGraphicBezelCircularText()
            let ogrt = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            ogrt.centerTextProvider = CLKSimpleTextProvider(text: textProvider)
            ogrt.bottomTextProvider = CLKSimpleTextProvider(text: "\(year.year)")
            ogrt.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.white,.gray], gaugeColorLocations: nil, fillFraction: fraction)
            temp.circularTemplate = ogrt
            temp.textProvider =  CLKSimpleTextProvider(text: "\(titleText)\(String(format:"%.4f",per))%")//CLKSimpleTextProvider(text: "\(year.year) \(String(format:"%.6f",per))%")
            template = temp
            break
        case .graphicCircular:
            let temp = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            temp.bottomTextProvider = CLKSimpleTextProvider(text: "\(year.year)")
            temp.centerTextProvider = CLKSimpleTextProvider(text: textProvider)
            temp.gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: [.green,.red], gaugeColorLocations: nil, fillFraction: fraction)
            template = temp
            break
        case .graphicRectangular:
            let temp = CLKComplicationTemplateGraphicRectangularTextGauge()
            temp.headerTextProvider = CLKSimpleTextProvider(text: titleText)
            temp.body1TextProvider = CLKSimpleTextProvider(text: "\(String(format:"%.2f",per))%")
            temp.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.white,.gray], gaugeColorLocations: nil, fillFraction: fraction)
            template = temp
            break
        case .graphicExtraLarge:
            
            
            
            break
        }
        return template
    }
}
