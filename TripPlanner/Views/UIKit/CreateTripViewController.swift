//
//  CreateTripViewController.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import Combine

class CreateTripViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CreateTripViewModel
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    private var cancellables = Set<AnyCancellable>()
    
    // Form Fields
    private let nameTextField = UITextField()
    private let destinationTextField = UITextField()
    private let startDateTextField = UITextField()
    private let endDateTextField = UITextField()
    private let durationTextField = UITextField()
    private let travelStyleTextField = UITextField()
    private let descriptionTextView = UITextView()
    
    // Error Labels
    private let nameErrorLabel = UILabel()
    private let destinationErrorLabel = UILabel()
    
    // Save Button
    private let saveButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initialization
    init(editingTrip: Trip? = nil) {
        self.viewModel = CreateTripViewModel(editingTrip: editingTrip)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColors.lightBackground
        
        // Navigation Bar
        title = viewModel.editingTrip == nil ? "Create a Trip" : "Edit Trip"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        
        // Content View
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Stack View
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.md
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Form Fields
        setupTextField(nameTextField, placeholder: "Trip Name", errorLabel: nameErrorLabel)
        setupTextField(destinationTextField, placeholder: "Destination", errorLabel: destinationErrorLabel)
        setupTextField(startDateTextField, placeholder: "Start Date (YYYY-MM-DD)")
        setupTextField(endDateTextField, placeholder: "End Date (YYYY-MM-DD)")
        setupTextField(durationTextField, placeholder: "Duration (days)", keyboardType: .numberPad)
        setupTextField(travelStyleTextField, placeholder: "Travel Style")
        setupTextView(descriptionTextView, placeholder: "Trip Description")
        
        // Save Button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = AppColors.primaryBlue
        saveButton.setTitle("Save Trip", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.applyTypography(.b3SemiBold, color: .white)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Loading Indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        saveButton.addSubview(loadingIndicator)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, errorLabel: UILabel? = nil, keyboardType: UIKeyboardType = .default) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.backgroundColor = AppColors.white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.md, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.md, height: 0))
        textField.rightViewMode = .always
        textField.font = .appFont(style: .b3Medium)
        textField.textColor = AppColors.primaryText
        textField.keyboardType = keyboardType
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        stackView.addArrangedSubview(textField)
        
        if let errorLabel = errorLabel {
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            errorLabel.applyTypography(.b4Medium, color: .systemRed)
            errorLabel.isHidden = true
            stackView.addArrangedSubview(errorLabel)
        }
    }
    
    private func setupTextView(_ textView: UITextView, placeholder: String) {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = AppColors.white
        textView.layer.cornerRadius = 8
        textView.font = .appFont(style: .b3Medium)
        textView.textColor = AppColors.primaryText
        textView.textContainerInset = UIEdgeInsets(top: Spacing.md, left: Spacing.md, bottom: Spacing.md, right: Spacing.md)
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.addArrangedSubview(textView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -Spacing.md),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.screenPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.screenPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.screenPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.screenPadding),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.screenPadding),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.screenPadding),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.md),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        // Bind text fields to view model
        nameTextField.textPublisher
            .assign(to: &viewModel.$name)
        
        destinationTextField.textPublisher
            .assign(to: &viewModel.$destination)
        
        startDateTextField.textPublisher
            .assign(to: &viewModel.$startDate)
        
        endDateTextField.textPublisher
            .assign(to: &viewModel.$endDate)
        
        durationTextField.textPublisher
            .assign(to: &viewModel.$duration)
        
        travelStyleTextField.textPublisher
            .assign(to: &viewModel.$travelStyle)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: descriptionTextView)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .assign(to: &viewModel.$description)
        
        // Bind view model to UI
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.nameTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$destination
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.destinationTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$startDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.startDateTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$endDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.endDateTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$duration
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.durationTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$travelStyle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.travelStyleTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$description
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.descriptionTextView.text = text
            }
            .store(in: &cancellables)
        
        // Error labels
        viewModel.$nameError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.nameErrorLabel.text = error
                self?.nameErrorLabel.isHidden = error == nil
            }
            .store(in: &cancellables)
        
        viewModel.$destinationError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.destinationErrorLabel.text = error
                self?.destinationErrorLabel.isHidden = error == nil
            }
            .store(in: &cancellables)
        
        // Loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.saveButton.isEnabled = !isLoading
                self?.saveButton.alpha = isLoading ? 0.6 : 1.0
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // Success/Error messages
        viewModel.$showSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showSuccess in
                if showSuccess {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                if showError, let errorMessage = self?.viewModel.errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        Task {
            let success = await viewModel.saveTrip()
            if success {
                // Dismiss will be handled by binding
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextField Publisher Extension
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}

