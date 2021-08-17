//
//  DateConversionService.swift
//  DateConversionService
//
//  Created by Tino on 16.08.2021..
//

import Foundation


class TimeConversionService {
    
    func formatDay(date: String) -> WeekDay {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formateDate = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "E"
        
        let day = dateFormatter.string(from: formateDate)
        
        return WeekDay(rawValue: day) ?? .mon
        
    }
    
    func formatDateFromUnixDate(unixDate: Int)  -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixDate))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "E, dd.MM.yyyy - HH:mm"
        
        let formatedDate = dateFormatter.string(from: date)
        
        return formatedDate
        
    }
    
    
    func getStringTimeFromUnixDate(unixDate: Int) -> String {
        
        let time = Date(timeIntervalSince1970: TimeInterval(unixDate))
        
        let hours = Calendar.current.component(.hour, from: time)
        let minutes = Calendar.current.component(.minute, from: time)
        
        var minutesString = "\(minutes)"
        var hoursString = "\(hours)"
        
        if minutes < 10 {
            minutesString = "0\(minutes)"
        }
        if hours < 10 {
            hoursString = "0\(hours)"
        }
        
        let fullTime = "\(hoursString):\(minutesString)"
        
        return fullTime
    }
    
}
