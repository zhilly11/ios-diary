//  Diary - DiaryListViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

/// 다이어리 목록 화면
final class DiaryListViewController: UIViewController {
    
    // MARK: - typealias & enum

    private typealias DataSource = UITableViewDiffableDataSource<DiarySection, Diary>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<DiaryListViewController.DiarySection, Diary>
    
    private enum DiarySection: Hashable {
        case main
    }
    
    private enum Constant {
        static let title = "일기장"
        static let sampleDataName = "sample"
        static let firstDiary: IndexPath = .init(row: 0, section: 0)
        static let deleteFailAlertTitle = "다이어리 삭제 실패"
        static let addFailAlertTitle = "다이어리 생성 실패"
    }
    
    // MARK: - Properties
    
    private let diaryManager: DiaryManager = DiaryManager.shared
    
    private let diaryTableView: UITableView = {
        let tableView: UITableView = .init(frame: .zero, style: .plain)
        
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var diaryDataSource: UITableViewDiffableDataSource = {
        let dataSource: DataSource = .init(
            tableView: diaryTableView
        ) { (tableView, indexPath, diary) -> UITableViewCell? in
            
            guard let cell: DiaryCell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell else { return nil }
            
            cell.configure(with: diary)
            
            return cell
        }
        
        return dataSource
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDiaries()
    }
    
    // MARK: - Method
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = Constant.title
        diaryTableView.delegate = self
        
        setupViews()
        setupBarButtonItem()
        setupSearchController()
    }
    
    private func setupViews() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        view.addSubview(diaryTableView)
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setupBarButtonItem() {
        let addAction: UIAction = .init { _ in
            self.tappedAddButton()
        }
        let rightBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "plus"),
                                                    primaryAction: addAction)
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func pushDiaryViewController(with indexPath: IndexPath) {
        guard let diary: Diary = diaryDataSource.itemIdentifier(for: indexPath) else { return }
        let diaryViewController: DiaryViewController = .init(diary: diary)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func showShareActivityView(for diary: Diary) {
        let activityViewController: UIActivityViewController = .init(activityItems: [diary.content],
                                                                     applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func delete(_ diary: Diary) {
        do {
            try diaryManager.remove(diary)
            deleteDiaryItem(of: diary)
        } catch {
            NSLog("Diary Delete Failed")
            let alert: UIAlertController = AlertFactory.make(
                .failure(title: Constant.deleteFailAlertTitle, message: nil)
            )
            
            present(alert, animated: true)
        }
    }
    
    private func deleteDiaryItem(of diary: Diary) {
        var snapshot: SnapShot = diaryDataSource.snapshot()
        
        snapshot.deleteItems([diary])
        diaryDataSource.apply(snapshot)
    }
    
    private func apply(_ diaries: [Diary]) {
        var snapshot: SnapShot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        diaryDataSource.apply(snapshot)
    }
    
    private func tappedAddButton() {
        do {
            try diaryManager.add(nil)
            fetchDiaries()
            pushDiaryViewController(with: Constant.firstDiary)
        } catch {
            NSLog("Diary Add Failed")
            let alert: UIAlertController = AlertFactory.make(
                .failure(title: Constant.addFailAlertTitle, message: nil)
            )
            
            present(alert, animated: true)
        }
    }
    
    private func fetchDiaries() {
        do {
            let diaries: [Diary] = try diaryManager.fetchObjects()
            apply(diaries)
        } catch {
            NSLog("Diaries Fetch Failed")
            let alert: UIAlertController = AlertFactory.make(.exit)
            
            present(alert, animated: true)
        }
    }
    
    private func searchDiaries(keyword: String?) {
        guard let keyword = keyword else { return }
        
        if !keyword.isEmpty {
            do {
                let diaries: [Diary] = try diaryManager.search(keyword: keyword)
                apply(diaries)
            } catch {
                NSLog("Diaries Search Failed")
                let alert: UIAlertController = AlertFactory.make(.exit)
                
                present(alert, animated: true)
            }
        } else {
            fetchDiaries()
        }
    }
    
    private func setupSearchController() {
        let searchController: UISearchController = .init(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "일기장"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - TableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushDiaryViewController(with: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive,
                                                     title: nil) { [weak self] (_, _, success) in
            if let diary: Diary = self?.diaryDataSource.itemIdentifier(for: indexPath) {
                self?.delete(diary)
                success(true)
            } else {
                success(false)
            }
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let shareAction: UIContextualAction = .init(style: .normal,
                                                    title: nil) { [weak self] (_, _, success) in
            if let diary: Diary = self?.diaryDataSource.itemIdentifier(for: indexPath) {
                self?.showShareActivityView(for: diary)
                success(true)
            } else {
                success(false)
            }
        }
        shareAction.backgroundColor = UIColor(named: "CustomBlue")
        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension DiaryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchDiaries(keyword: searchController.searchBar.text)
    }
}
