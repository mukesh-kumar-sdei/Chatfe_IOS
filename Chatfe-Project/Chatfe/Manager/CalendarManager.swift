//
//  CalendarManager.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 10/06/22.
//

import Foundation
import EventKit

class CalendarManager {
    
    static let shared = CalendarManager()
    
    private init() {}
    
    private var eventStore = EKEventStore()
    
    
    //MARK: - METHODs
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { status, error in
            if status {
                
            }
        }
    }
    
    func checkCalendarAccessStatus() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            // EXECUTE FUTHER CODE
            break
        case .denied:
            // SHOW ALERT MESSAGE
            break
        case .notDetermined:
            requestCalendarAccess()
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func addEventToCalendar(dataArr: [RoomData], completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            let event = EKEvent(eventStore: eventStore)
            
            for data in dataArr {
                event.title = data.roomName
                event.notes = data.about
                
//                let startDate = self.getDateFromString(strDate: data.startDate ?? "") ?? Date()
//                let endDate = self.getDateFromString(strDate: data.endDate ?? "") ?? Date()
                let startDate = data.startDate?.getFormattedDate() ?? Date()
                let endDate = data.endDate?.getFormattedDate() ?? Date()
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error {
                    completion?(false, error as NSError)
                    return
                }
            }
            completion?(true, nil)
        }
    }

}
