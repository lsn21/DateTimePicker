//
//  WheelTimePicker.swift
//
//  Created by Siarhei Lukyanau on 17.11.25.
//

import UIKit

public class WheelTimePicker: UIPickerView {
    
    // MARK: - IBInspectable Properties
    @IBInspectable public var pickerBackgroundColor: UIColor? {
        didSet {
            backgroundColor = pickerBackgroundColor ?? UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    @IBInspectable public var textColor: UIColor? {
        didSet {
            reloadAllComponents()
        }
    }
    
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        backgroundColor = pickerBackgroundColor ?? UIColor.white.withAlphaComponent(0.8)
    }
    
    func setTime(date: Date?) {
        if let date = date {
            let time = DateHelpers.hoursMinutesFromDateInt(date: date)
            selectRow(time.hours, inComponent: 0, animated: true)
            selectRow(time.minutes, inComponent: 1, animated: true)
        }
    }
    
    var selectedHour: Int {
        return hours[selectedRow(inComponent: 0)]
    }
    
    var selectedMinute: Int {
        return minutes[selectedRow(inComponent: 1)]
    }
}

extension WheelTimePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hours.count : minutes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textColor != nil {
            return nil // Используем attributedTitleForRow если задан цвет текста
        }
        if component == 0 {
            return String(format: "%02d hours", hours[row])
        }
        else {
            return String(format: "%02d minutes", minutes[row])
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text: String
        if component == 0 {
            text = String(format: "%02d hours", hours[row])
        } else {
            text = String(format: "%02d minutes", minutes[row])
        }
        
        if let color = textColor {
            return NSAttributedString(string: text, attributes: [.foregroundColor: color])
        }
        
        return NSAttributedString(string: text)
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 144
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
