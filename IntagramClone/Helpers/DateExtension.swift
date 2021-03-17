//
//  DateExtension.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 17.03.2021.
//

import Foundation


extension Date {
    func calcTime() -> String {
        
        let secondAgo = Int(Date().timeIntervalSince(self))
        
        let min = 60
        let hour = 60 * min
        let day = 24 * hour
        let week = 7 * day
        let mount = 4 * week
        
        let rate : Int
        let unit : String
        
        
        if secondAgo < min {
            rate = secondAgo
            
            if rate >= 2 {
                unit = "seconds"
            }else {
                unit = "second"
            }
           
        } else if secondAgo < hour {
            rate = secondAgo / min
            
            if rate >= 2 {
                unit = "minutes"
            }else {
                unit = "minute"
            }
        } else if secondAgo < day {
            rate = secondAgo / hour
            
            if rate >= 2 {
                unit = "hours"
            }else {
                unit = "hour"
            }
        } else if secondAgo < week {
            rate = secondAgo / day
            if rate >= 2 {
                unit = "day"
            }else {
                unit = "day"
            }
        } else if secondAgo < mount {
            rate = secondAgo / week
            if rate >= 2{
                unit = "weeks"
            }else {
                unit = "week"
            }
        }else {
            rate = secondAgo / mount
            if rate >= 2 {
                unit = "mounts"
            }else {
                unit = "mount"
            }
        }
        
        
        return "\(rate) \(unit) ago"
        
        
    }
}
