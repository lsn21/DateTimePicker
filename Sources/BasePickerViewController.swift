//
//  BasePickerViewController.swift
//
//  Created by Siarhei Lukyanau on 17.11.25.
//

import UIKit

public class BasePickerViewController: UIViewController {
    
    // MARK: - IBInspectable Properties
    @IBInspectable public var toolbarBackgroundColor: UIColor? {
        didSet {
            toolbar.backgroundColor = toolbarBackgroundColor
            toolbarContainerView.backgroundColor = toolbarBackgroundColor
        }
    }
    
    @IBInspectable public var containerBackgroundColor: UIColor? {
        didSet {
            containerView.backgroundColor = containerBackgroundColor
        }
    }
    
    @IBInspectable public var backgroundOverlayColor: UIColor? {
        didSet {
            // Will be applied during animation
        }
    }
    
    @IBInspectable public var cancelButtonTextColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }
    
    @IBInspectable public var doneButtonTextColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }

    @IBInspectable public var cancelButtonTintColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }
    
    @IBInspectable public var doneButtonTintColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }

    /// Высота тулбара в пунктах. По умолчанию 44.
    public var toolbarHeight: CGFloat = 44 {
        didSet {
            toolbarHeightConstraint?.constant = toolbarHeight
        }
    }

    // MARK: - UI Properties
    private let toolbarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        return toolbar
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var pickerView: UIView?
    private var toolbarHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePresentation()
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .clear
        
        // Применяем цвета по умолчанию, если не установлены через IB
        if toolbarBackgroundColor == nil {
            toolbar.backgroundColor = UIColor.clear
        } else {
            toolbar.backgroundColor = toolbarBackgroundColor
        }
        toolbarContainerView.backgroundColor = toolbar.backgroundColor
        
        if containerBackgroundColor == nil {
            containerView.backgroundColor = .white
        } else {
            containerView.backgroundColor = containerBackgroundColor
        }
        
        // Фон для затенения
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Контейнер для пикера и тулбара
        view.addSubview(containerView)
        containerView.addSubview(toolbarContainerView)
        toolbarContainerView.addSubview(toolbar)
        
        // Настройка констрейнтов для контейнера
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Контейнер тулбара (настраиваемая высота)
        toolbarContainerView.translatesAutoresizingMaskIntoConstraints = false
        let containerHeightConstraint = toolbarContainerView.heightAnchor.constraint(equalToConstant: toolbarHeight)
        toolbarHeightConstraint = containerHeightConstraint
        NSLayoutConstraint.activate([
            toolbarContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            toolbarContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            toolbarContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerHeightConstraint
        ])
        
        // Тулбар по центру контейнера по высоте (фиксированная высота бара с кнопками)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.centerYAnchor.constraint(equalTo: toolbarContainerView.centerYAnchor),
            toolbar.leadingAnchor.constraint(equalTo: toolbarContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: toolbarContainerView.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Animation Methods
    private func animatePresentation() {
        // Устанавливаем начальную позицию (за экраном)
        containerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        
        // Анимация появления
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut) {
            self.containerView.transform = .identity
        } completion: { _ in
            // Плавное добавление затенения фона
            UIView.animate(withDuration: 0.2) {
                if let overlayColor = self.backgroundOverlayColor {
                    self.backgroundView.backgroundColor = overlayColor
                } else {
                    self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                }
                self.backgroundView.alpha = 1
            }
        }
    }
    
    private func animateDismissal(completion: (() -> Void)? = nil) {
        // Сначала убираем затенение
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            // Затем убираем пикер
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            } completion: { _ in
                super.dismiss(animated: false, completion: completion)
            }
        }
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            onWillDismissFromBackgroundTap()
            dismiss(animated: true, completion: nil)
        }
    }
    
    /// Вызывается перед dismiss при тапе вне окна пикера. Переопределить в подклассах для вызова delegate.
    func onWillDismissFromBackgroundTap() {}
    
    // MARK: - Public Methods
    func setupToolbarItems(cancelSelector: Selector, doneSelector: Selector) {
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: cancelSelector
        )
        let cancelTitleColor = cancelButtonTextColor ?? UIColor.systemRed
        let cancelAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: cancelTitleColor]
        cancelButton.setTitleTextAttributes(cancelAttributes, for: .normal)

        cancelButton.tintColor = cancelButtonTintColor ?? UIColor.systemRed

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: doneSelector
        )
        let doneTitleColor = doneButtonTextColor ?? UIColor.systemBlue
        print(doneTitleColor)
        let doneAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: doneTitleColor]

        doneButton.tintColor = doneButtonTintColor ?? UIColor.systemBlue
        doneButton.setTitleTextAttributes(doneAttributes, for: .normal)

        toolbar.items = [cancelButton, flexSpace, doneButton]
    }
    
    private func updateButtonColors() {
        guard let items = toolbar.items else { return }
        for item in items {
            if item.title == "Cancel" || item.title == "Done" {
                item.tintColor = doneButtonTintColor ?? UIColor.systemRed
            }
        }
    }
    
    func addPickerToContainer(_ picker: UIView) {
        self.pickerView = picker
        containerView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: toolbarContainerView.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            picker.heightAnchor.constraint(equalToConstant: 216)
        ])
    }
    
    public override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            animateDismissal(completion: completion)
        } else {
            super.dismiss(animated: false, completion: completion)
        }
    }
}
