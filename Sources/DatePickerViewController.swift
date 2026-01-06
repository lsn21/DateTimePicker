//
//  DatePickerViewController.swift
//
//  Created by Siarhei Lukyanau on 17.11.25.
//

import UIKit

public protocol DatePickerDelegate: AnyObject {
    func datePickerDone(date: Date)
    func datePickerCancelled()
}

public class DatePickerViewController: BasePickerViewController {
    
    weak var delegate: DatePickerDelegate?
    private var datePicker: UIDatePicker!
    
    var date: Date?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupToolbarItems(
            cancelSelector: #selector(cancelButtonTapped),
            doneSelector: #selector(doneButtonTapped)
        )
    }
    
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        datePicker.date = date ?? Date()
        
        addPickerToContainer(datePicker)
    }
    
    @objc private func doneButtonTapped() {
        delegate?.datePickerDone(date: datePicker.date)
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.datePickerCancelled()
        dismiss(animated: true)
    }
}
