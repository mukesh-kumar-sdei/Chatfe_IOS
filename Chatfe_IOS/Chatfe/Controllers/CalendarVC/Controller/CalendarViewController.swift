//
//  CalendarViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//
/*
import UIKit
import EventKit
import CalendarKit
import AVFoundation


class CalendarViewController: DayViewController {

    private var eventStore = EKEventStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        navigationController?.navigationBar.isTranslucent = false
        self.dayView.autoScrollToFirstEvent = true
        self.reloadData()
        requestCalendarAccess()
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { status, error in
            if status {
//                self.showCalendar()
                
            }
        }
    }
    
    func checkCalendarAccessStatus() {
        
    }
    
    override func loadView() {
      calendar.timeZone = TimeZone(identifier: "Europe/Paris")!
      dayView = DayView(calendar: calendar)
      view = dayView
    }
    
    /*
    func showCalendar() {
        let chooser = EKCalendarChooser(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        chooser.delegate = self
        chooser.showsDoneButton = true
        chooser.showsCancelButton = true
        chooser.selectedCalendars = selectedCalendars
        
        let nvc = UINavigationController(rootViewController: chooser)
        
        present(nvc, animated: true, completion: nil)
    }*/
}
*/
