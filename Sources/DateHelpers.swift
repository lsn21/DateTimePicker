//
//  DateHelpers.swift
//
//  Created by Siarhei Lukyanau on 18.11.25.
//

import Foundation

public class DateHelpers {
    
    // Конвертация из строк в Date
    public class func convertToDate(dateString: String, timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: "\(dateString) \(timeString)")
    }

    // Конвертация из Date в строки
    public class func convertFromDate(_ date: Date, dateFormat: String = "MM/dd/yyyy HH:mm") -> (date: String, time: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let fullString = formatter.string(from: date)
        let parts = fullString.split(separator: " ")
        
        return (String(parts[0]), String(parts[1]))
    }
    
    // Конвертация из Date в строковую дату
    public class func dateFromDate(date: Date) -> String {
        let dateStr = DateHelpers.convertFromDate(date).date
        return dateStr
    }
    
    // Конвертация из Date в строковое время
    public class func timeFromDate(date: Date) -> String {
        let timeStr = DateHelpers.convertFromDate(date).time
        return timeStr
    }
    
    // Конвертация из Date в строковые часы и минуты
    public class func hoursMinutesFromDate(date: Date) -> (hours: String, minutes: String) {
        let timeStr = DateHelpers.timeFromDate(date: date)
        let parts = timeStr.split(separator: ":", maxSplits: 1)
        
        guard parts.count == 2 else {
            // Обработка случая, когда разделитель не найден
            fatalError("Неверный формат строки")
        }
        let hours = String(parts[0])
        let minutes = String(parts[1])
        
        return (hours, minutes)
    }
    
    // Конвертация из Date в строковые часы и минуты
    public class func hoursMinutesFromDateInt(date: Date) -> (hours: Int, minutes: Int) {
        let timeStr = DateHelpers.hoursMinutesFromDate(date: date)
        let hours = Int(timeStr.hours) ?? 0
        let minutes = Int(timeStr.minutes) ?? 0
        
        return (hours, minutes)
    }
}
