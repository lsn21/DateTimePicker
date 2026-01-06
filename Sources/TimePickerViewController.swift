//
//  TimePickerViewController.swift
//
//  Created by Siarhei Lukyanau on 17.11.25.
//

import UIKit

public protocol TimePickerDelegate: AnyObject {
    func timePickerDone(date: Date)
    func timePickerCancelled()
}

public class TimePickerViewController: BasePickerViewController {
    
    weak var delegate: TimePickerDelegate?
    private var timePicker: WheelTimePicker!
    
    var date: Date?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTimePicker()
        setupToolbarItems(
            cancelSelector: #selector(cancelButtonTapped),
            doneSelector: #selector(doneButtonTapped)
        )
    }
    
    private func setupTimePicker() {
        timePicker = WheelTimePicker()
        timePicker.setTime(date: date)
        addPickerToContainer(timePicker)
    }
    
    func getDate(hours: Int, minutes: Int) -> Date {
        let dateStr = DateHelpers.dateFromDate(date: date ?? Date())
        let timeStr = String(format: "%02d:%02d", hours, minutes)
        let date = DateHelpers.convertToDate(dateString: dateStr, timeString: timeStr) ?? Date()
        return date
    }
    
    @objc private func doneButtonTapped() {
        let hours = timePicker.selectedHour
        let minutes = timePicker.selectedMinute
        delegate?.timePickerDone(date: getDate(hours: hours, minutes: minutes))
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.timePickerCancelled()
        dismiss(animated: true)
    }
}
