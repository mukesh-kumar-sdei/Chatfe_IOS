//
//  AppleCalendarVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 01/06/22.
//

import UIKit
import EventKit
import CalendarKit

class AppleCalendarVC: DayViewController {

    private var eventStore = EKEventStore()
    var generatedEvents = [EventDescriptor]()
    private var createdEvent: EventDescriptor?
    var alreadyGeneratedSet = Set<Date>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupDarkUI()
        didReloadCalendar()
        NotificationCenter.default.addObserver(self, selector: #selector(changedCalendarMonth(_:)), name: Notification.Name.MonthChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReloadCalendar), name: Notification.Name.CALENDAR_RELOAD, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didReloadCalendar()
    }
    
    @objc func changedCalendarMonth(_ notification: Notification) {
        if let row = notification.object as? Int {
            if let moveDate = Calendar.current.date(byAdding: .month, value: row, to: Date()) {
                self.move(to: moveDate)
            }
        }
    }
    
    @objc func didReloadCalendar() {
        DispatchQueue.main.async {
            self.dayView.reloadData()
            self.dayView.autoScrollToFirstEvent = true
            self.dayView.scrollToFirstEventIfNeeded(animated: false)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    override func loadView() {
        super.loadView()
//        calendar.timeZone = TimeZone(identifier: "Europe/Paris")!
        calendar.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        dayView = DayView(calendar: calendar)
        view = dayView
    }

    func setupDarkUI() {
        var style = CalendarStyle()
        style.header.backgroundColor = AppColor.accentColor ?? UIColor.white
        
        // WEEKDAY & WEEKEND SYMBOL - S M T W T F S
        style.header.daySymbols.weekDayColor = .gray // UIColor.white
        style.header.daySymbols.weekendColor = UIColor.gray
        
        // DATE SELECTOR
        style.header.daySelector.inactiveTextColor = .gray // UIColor.white
        style.header.daySelector.weekendTextColor = UIColor.gray
        
        style.header.swipeLabel.textColor = UIColor.white
        
        // TODAY' SELECTED DATE - TEXT AND BACKGROUND CIRCLE COLOR
        style.header.daySelector.todayActiveBackgroundColor = AppColor.appBlueColor
        style.header.daySelector.todayActiveTextColor = UIColor.white
        style.header.daySelector.todayInactiveTextColor = .white // AppColor.appBlueColor
        
        // OTHER SELECTED DATE
        style.header.daySelector.activeTextColor = UIColor.black
        style.header.daySelector.selectedBackgroundColor = UIColor.white
//        style.header.daySelector.
        
        // BOTTOM VIEW FOR EVENTs
        style.timeline.backgroundColor = AppColor.accentColor ?? UIColor.white
        style.timeline.timeColor = UIColor.gray
        style.timeline.separatorColor = UIColor.gray
        style.timeline.timeIndicator.color = UIColor.white
//        style.timeline.verticalDiff = 120
        self.updateStyle(style)
    }
    /*
    func updateSelectionUIForEvent() {
        var style1 = DayHeaderStyle()
        style1.backgroundColor = AppColor.accentColor ?? UIColor.white
        
        // WEEKDAY & WEEKEND SYMBOL - S M T W T F S
        style1.daySymbols.weekDayColor = .gray // UIColor.white
        style1.daySymbols.weekendColor = UIColor.gray
        
        // DATE
        style1.daySelector.inactiveTextColor = .gray // .white
        style1.daySelector.weekendTextColor = .gray
        
        // TODAY' SELECTED DATE - TEXT AND BACKGROUND CIRCLE COLOR
        style1.daySelector.todayActiveBackgroundColor = AppColor.appBlueColor
        style1.daySelector.todayActiveTextColor = UIColor.white
        style1.daySelector.todayInactiveTextColor = AppColor.appBlueColor
        
        // OTHER SELECTED DATE
        style1.daySelector.activeTextColor = AppColor.appBlueColor // UIColor.black
        style1.daySelector.selectedBackgroundColor = UIColor(red: 57.0/255.0, green: 153.0/255.0, blue: 207.0/255.0, alpha: 0.1)// UIColor.white
        
        dayView.dayHeaderView.updateStyle(style1)
    }
*/
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//        let models = AppInstance.shared.allEvents?.data ?? []
        let models = AppInstance.shared.allJoinedEvents?.data ?? [] // Get events (models) from the storage / API

        var events = [Event]()
        var row = 0
        
        for modelData in models {
            // Create new EventView
            guard let model = modelData.roomId else {return []}
            let event = Event()
            event.textColor = .white
            event.backgroundColor = AppColor.appBlueColor
            event.font = UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .bold)
            
            let startDate = model.startDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
            let endDate = model.endDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
            
            event.dateInterval = DateInterval(start: startDate, end: endDate)
            
            let startTime = model.startDate?.serverToLocalFormattedTime().extractFormattedStartTime()
            let endTime = model.endDate?.serverToLocalFormattedTime().extractFormattedStartTime()
            
            // Add info: event title, subtitle, location to the array of Strings
//            var info = [model.roomName ?? "", model.about ?? ""]
            var info = [model.roomName ?? ""]
//            info.append("\((model.startTime ?? "")) - \((model.duration ?? 0.0))")
            info.append("\((startTime ?? "")) - \((endTime ?? ""))")
            // Set "text" value of event by formatting all the information needed for display
            event.text = info.reduce("", {$0 + $1 + "\n"})
            event.userInfo = row
            events.append(event)
            
            /// SYNC WITH APPLE CALENDAR
            self.fetchnAddAppleCalendarEvents(model: model, startDate: startDate, endDate: endDate)
            row += 1
        }
        return events
    }
    
    
    // MARK: - DayViewDelegate
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else { return }
        
        let row = (descriptor.userInfo as? Int) ?? 0
//        let arrData = AppInstance.shared.allEvents?.data ?? []
        let arrData = AppInstance.shared.allJoinedEvents?.data ?? []
        
        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
        nextVC.id = arrData[row].roomId?._id ?? "" // arrData[row]._id ?? ""
//        nextVC.hasJoinedRoom = arrData[row].hasRoomJoined ?? false
        nextVC.eventDelegate = self
        nextVC.selectedRow = row
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        let monthInt = date.get(.month)
        NotificationCenter.default.post(name: Notification.Name.APPLE_CALENDAR_MONTH_CHANGED, object: monthInt)
    }
    /*
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print(#function, date)

        let models = AppInstance.shared.allJoinedEvents?.data ?? []
        
        for m in models {
            guard let model = m.roomId else {return }
            let startDate = model.startDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
            print("EVENT DATE :> ", startDate)
            let result = Calendar.current.compare(date, to: startDate, toGranularity: .day)
            if result == .orderedSame {
                updateSelectionUIForEvent()
            } else {
                setupDarkUI()
            }
        }
    }
    */
    
}


// MARK: - APPLE CALENDAR - FETCH & ADD EVENTs
extension AppleCalendarVC {
    
    func removeEventFromAppleCalendar(event: EKEvent) {
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            do {
                try eventStore.remove(event, span: .thisEvent)
            } catch let e as NSError {
                debugPrint(e.localizedDescription)
                return
            }
        }
    }
    
    func addEventToAppleCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.recurrenceRules = .none
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch let e as NSError {
                debugPrint(e.localizedDescription)
                return
            }
        }
    }
    
    func fetchnAddAppleCalendarEvents(model: RoomData, startDate: Date, endDate: Date) {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == eventStore.defaultCalendarForNewEvents?.title {
                let selectedCalendar = calendar

                let currentCalendar = Calendar.current
//                var oneYearFromNow = currentCalendar.date(byAdding: oneYearEndDate, to: Date(), options: [])
                guard let oneYearEndDate = currentCalendar.date(byAdding: .year, value: 1, to: Date()) else { return }
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: oneYearEndDate, calendars: [selectedCalendar])
                let allEvents = eventStore.events(matching: predicate)

                var isEventExists = false
                for event in allEvents {
//                    print("APPLE CALENDAR EVENT IDENTIFIER :> \(event.eventIdentifier)")
                    if event.title == model.roomName {
                        isEventExists = true
//                        print("isEventExists :> \(isEventExists)\n")
                    }
                }
                
                if !isEventExists {
                    self.addEventToAppleCalendar(title: model.roomName ?? "", description: model.about ?? "", startDate: startDate, endDate: endDate, completion: nil)
//                    print("ADDED EVENT IS :> \(model.roomName ?? "")")
                }
            }
        
        }
    }
    
    func fetchnRemoveEvents(model: RoomData, startDate: Date, endDate: Date, completion: @escaping ((_ events: [EKEvent]) -> Void)) {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == eventStore.defaultCalendarForNewEvents?.title {
                let selectedCalendar = calendar

                let currentCalendar = Calendar.current
//                var oneYearFromNow = currentCalendar.date(byAdding: oneYearEndDate, to: Date(), options: [])
                guard let oneYearEndDate = currentCalendar.date(byAdding: .year, value: 1, to: Date()) else { return }
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: oneYearEndDate, calendars: [selectedCalendar])
                let allEvents = eventStore.events(matching: predicate)
                completion(allEvents)
            }
        }
    }
    
}

extension Date {

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}


extension AppleCalendarVC: EventDetailsDelegate {
    func didJoinRoom(row: Int, status: Bool) {
        //
    }
    
    func didUnjoinRoom(row: Int, status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.dayView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func didDeleteRoom(status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.dayView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
}
