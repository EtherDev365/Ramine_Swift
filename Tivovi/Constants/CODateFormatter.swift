//
//  DateFormatter.swift
//  TKTProject
//
//  Created by Jimmy on 7/21/16.
//  Copyright © 2016 CARTOMAT. All rights reserved.
//

import UIKit
import Foundation

public class CODateFormatter: NSObject {
    public static var currentCalendar: Calendar {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.firstWeekday = 1
        
        return calendar
    }
    
    public static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.timeZone = TimeZone.current
               dateFormatter.locale = Locale.current
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }
    
    public static var zeroTimeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        
        return dateFormatter
    }
    
    public static var noneTimeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }
    
    public static var noneTimeDateFormatterForBrandDate: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd/MM - yyyy"
        
        return dateFormatter
    }
    
    public static var noneTimeAndDashDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter
    }
    
    public static var fullTimeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        return dateFormatter
    }
    
    public static var slashSeparatorDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return dateFormatter
    }
    
    public static var shortSlashSeparatorDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "yy/MM/dd"
        
        return dateFormatter
    }
    
    public static var shortSlashSeparatorDMYDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter
    }
    
    public static var shortSlashSeparatorMDYDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter
    }
    
    public static var shortSlashSeparatorMDYDateFullYearFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }
    
    public static var fullMonthAndYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter
    }
    
    public static var monthAndYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter
    }
    
    public static var dayAndWeekdayDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd EEEE"
        
        return dateFormatter
    }
    
    public static var onlyWeekdayDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter
    }
    
    public static var dayAndMonthDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd MMM"
        
        return dateFormatter
    }
    
    public static var weekOfYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "'Week' ww"
        
        return dateFormatter
    }
    
    public static var quarterFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "Q"
        
        return dateFormatter
    }
    
    public static var quarterAndYearFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "Q, yyyy"
        
        return dateFormatter
    }
    
    public static var fullDayMonthYear: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
        
        return dateFormatter
    }
    
    public static var fullSlashSpeaceMDYDateFullYearTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = CODateFormatter.currentCalendar
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        return dateFormatter
    }
}
