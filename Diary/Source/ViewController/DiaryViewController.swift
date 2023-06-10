//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController {
    private enum Constant {
        static let deleteAlertTitle = "진짜요??🤔"
        static let deleteAlertMessage = "정말로 삭제 하시겠어요??🙏"
        static let deleteActionTitle = "삭제"
        static let shareActionTitle = "공유"
        static let cancelActionTitle = "취소"
        static let deleteFailAlertTitle = "다이어리 삭제 실패"
        static let saveFailAlertTitle = "다이어리 저장 실패"
    }
    private let contentTextView = DiaryTextView(font: .preferredFont(forTextStyle: .body),
                                                textAlignment: .left,
                                                textColor: .black)
    private let locationManager: CLLocationManager?
    private var networkManager: NetworkManager?
    private let diaryManager: DiaryManager = DiaryManager.shared
    private var diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
        self.locationManager = CLLocationManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager?.requestWhenInUseAuthorization()
        if diary.content.isEmpty == false {
            contentTextView.contentOffset = .zero
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if diary.content.isEmpty == true {
            contentTextView.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if diary.content.isEmpty == true {
            do {
                try diaryManager.remove(diary)
            } catch {
                NSLog("Diary Delete Failed")
            }
        }
    }
    
    private func configure() {
        title = DateFormatter.converted(date: diary.createdAt,
                                        locale: Locale.preference,
                                        dateStyle: .long)
        contentTextView.delegate = self
        contentTextView.keyboardDismissMode = .interactive
        
        locationManager?.delegate = self
        locationManager?.startMonitoringVisits()
        
        setupView()
        setupBarButtonItem()
        setupData()
        setupNotification()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,
                                                    constant: -8),
            contentTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            contentTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupBarButtonItem() {
        let detailAction: UIAction = .init { _ in
            self.tappedDetailButton()
        }
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                             primaryAction: detailAction)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupData() {
        contentTextView.text = diary.content
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: .didEnterBackground,
                                               object: nil)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: Constant.deleteAlertTitle,
                                      message: Constant.deleteAlertMessage,
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: Constant.deleteActionTitle,
                                         style: .destructive) { [weak self] _ in
            self?.deleteDiary()
        }
        let cancelAction = UIAlertAction(title: Constant.cancelActionTitle, style: .cancel)
        
        [cancelAction, deleteAction].forEach(alert.addAction(_:))
        
        present(alert, animated: true)
    }
    
    private func deleteDiary() {
        do {
            try diaryManager.remove(diary)
            navigationController?.popViewController(animated: true)
        } catch {
            NSLog("Diary Delete Failed")
            let alert = AlertFactory.make(.failure(title: Constant.deleteFailAlertTitle, message: nil))
            present(alert, animated: true)
        }
    }
    
    private func showShareActivityView() {
        let activityViewController = UIActivityViewController(activityItems: [diary.content],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func tappedDetailButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: Constant.shareActionTitle,
                                        style: .default) { [weak self] _ in
            self?.saveDiary()
            self?.showShareActivityView()
        }
        let deleteAction = UIAlertAction(title: Constant.deleteActionTitle,
                                         style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: Constant.cancelActionTitle, style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach(actionSheet.addAction(_:))
        
        present(actionSheet, animated: true)
    }
    
    @objc
    private func saveDiary() {
        diary.content = contentTextView.text
        
        do {
            try diaryManager.update(diary)
        } catch {
            NSLog("Diary Save Failed")
            let alert = AlertFactory.make(.failure(title: Constant.saveFailAlertTitle, message: nil))
            present(alert, animated: true)
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
}

extension DiaryViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.stopUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if diary.weatherMain == nil,
           diary.weatherIconID == nil,
           let coordinate = locations.last?.coordinate {
            networkManager = NetworkManager()

            Task.init {
                do {
                    guard let networkManager = networkManager else { return }
                    let weather = try await networkManager.getWeatherInformation(
                        latitude: coordinate.latitude.description,
                        longitude: coordinate.longitude.description
                    )
                    
                    diary.weatherMain = weather.main
                    diary.weatherIconID = weather.icon
                } catch {
                    let alert = AlertFactory.make(.failure(title: error.localizedDescription,
                                                           message: nil))
                    present(alert, animated: true)
                }
            }
        }
    }
}
