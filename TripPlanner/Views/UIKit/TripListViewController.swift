//
//  TripListViewController.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import Combine
import SwiftUI

class TripListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = TripListViewModel()
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var loadingIndicator: UIActivityIndicatorView!
    private var emptyStateView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
        Task {
            await viewModel.loadTrips()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColors.lightBackground
        
        // Navigation Bar
        title = "Your Trips"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Create navigation bar title with custom styling
        let titleLabel = UILabel()
        titleLabel.applyTypography(.b2SemiBold, color: AppColors.primaryText)
        titleLabel.text = "Your Trips"
        navigationItem.titleView = titleLabel
        
        // Add button
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createTripTapped)
        )
        addButton.tintColor = AppColors.primaryBlue
        navigationItem.rightBarButtonItem = addButton
        
        // Table View
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.identifier)
        view.addSubview(tableView)
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTrips), for: .valueChanged)
        refreshControl.tintColor = AppColors.primaryBlue
        tableView.refreshControl = refreshControl
        
        // Loading Indicator
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = AppColors.primaryBlue
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // Empty State
        setupEmptyState()
    }
    
    private func setupEmptyState() {
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Spacing.md
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.applyTypography(.b2SemiBold, color: AppColors.primaryText)
        titleLabel.text = "Planned Trips"
        titleLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.applyTypography(.b4Medium, color: AppColors.tertiaryText)
        descriptionLabel.text = "Your trip itineraries and planned trips are placed here"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        emptyStateView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: emptyStateView.leadingAnchor, constant: Spacing.screenPadding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: emptyStateView.trailingAnchor, constant: -Spacing.screenPadding)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$trips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trips in
                self?.tableView.reloadData()
                self?.emptyStateView.isHidden = !trips.isEmpty
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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Actions
    @objc private func createTripTapped() {
        let createVC = CreateTripViewController()
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true)
    }
    
    @objc private func refreshTrips() {
        Task {
            await viewModel.loadTrips()
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

// MARK: - UITableViewDataSource
extension TripListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as! TripTableViewCell
        cell.configure(with: viewModel.trips[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TripListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trip = viewModel.trips[indexPath.row]
        // Navigate to detail view (SwiftUI)
        let detailView = TripDetailView(trip: trip)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = viewModel.trips[indexPath.row]
            guard let id = trip.id else { return }
            
            Task {
                await viewModel.deleteTrip(id: id)
            }
        }
    }
}

// MARK: - TripTableViewCell
class TripTableViewCell: UITableViewCell {
    static let identifier = "TripTableViewCell"
    
    private let cardView = UIView()
    private let nameLabel = UILabel()
    private let destinationLabel = UILabel()
    private let durationLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Card View
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = AppColors.white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.1
        contentView.addSubview(cardView)
        
        // Name Label
        nameLabel.applyTypography(.b2SemiBold, color: AppColors.primaryText)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        // Destination Label
        destinationLabel.applyTypography(.b3Medium, color: AppColors.tertiaryText)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(destinationLabel)
        
        // Duration Label
        durationLabel.applyTypography(.b3Medium, color: AppColors.tertiaryText)
        durationLabel.textAlignment = .right
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(durationLabel)
        
        // Date Label
        dateLabel.applyTypography(.b3Medium, color: AppColors.primaryText)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.sm),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.screenPadding),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.screenPadding),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.sm),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Spacing.md),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Spacing.cardPadding),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -Spacing.sm),
            
            destinationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.xs),
            destinationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Spacing.cardPadding),
            destinationLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -Spacing.cardPadding),
            
            durationLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Spacing.md),
            durationLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Spacing.cardPadding),
            
            dateLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: Spacing.xs),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Spacing.cardPadding),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -Spacing.md)
        ])
    }
    
    func configure(with trip: Trip) {
        nameLabel.text = trip.name
        destinationLabel.text = trip.destination
        
        if let duration = trip.duration {
            durationLabel.text = "\(duration) Days"
        } else {
            durationLabel.text = nil
        }
        
        if let startDate = trip.startDate {
            dateLabel.text = formatDate(startDate)
        } else {
            dateLabel.text = nil
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        // Simple date formatting - can be enhanced
        return dateString
    }
}

