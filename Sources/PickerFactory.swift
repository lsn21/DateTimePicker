//
//  PickerFactory.swift
//
//  Created by Siarhei Lukyanau on 17.11.25.
//

import UIKit

public enum PickerType {
    case date
    case time
}

public class PickerFactory {
    
    public static func createDatePicker(delegate: DatePickerDelegate, date: Date) -> DatePickerViewController {
        let vc = DatePickerViewController()
        vc.delegate = delegate
        vc.date = date
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
    
    public static func createTimePicker(delegate: TimePickerDelegate, date: Date) -> TimePickerViewController {
        let vc = TimePickerViewController()
        vc.delegate = delegate
        vc.date = date
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
}
