//  Diary - DiaryListViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    private enum DiarySection: Hashable {
        case main
    }
    private enum Constant {
        static let title = "일기장"
        static let sampleDataName = "sample"
    }
    
    var container: NSPersistentContainer?
    
    private let diaryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var diaryDataSource: UITableViewDiffableDataSource = {
        let dataSource = UITableViewDiffableDataSource<DiarySection, DiaryData>(
            tableView: diaryTableView
        ) { (tableView, indexPath, diary) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell else { return nil }
            
            cell.configureWithCoreData(with: diary)
            
            return cell
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        applySampleData()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = Constant.title
        diaryTableView.delegate = self
        
        setupContainer()
        setupViews()
        setupBarButtonItem()
    }
    
    private func setupContainer() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.container = appDelegate.persistentContainer
    }
    
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(diaryTableView)
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setupBarButtonItem() {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tappedAddButton))
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc
    private func tappedAddButton(_ sender: UIBarButtonItem) {
        pushDiaryViewController()
    }
    
    private func pushDiaryViewController(with diary: Diary = Diary()) {
        let diaryViewController = DiaryViewController(diary: diary)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func applySampleData() {
        guard let diaryData = try? self.container?.viewContext.fetch(DiaryData.fetchRequest()) as? [DiaryData]
        else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, DiaryData>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryData)
        diaryDataSource.apply(snapshot)
    }
    
    private func appendSampleData() {
        guard let container = self.container?.viewContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "DiaryData", in: container) else {
            return
        }
        
        let diary = NSManagedObject(entity: entity, insertInto: container)
        diary.setValue("잘 되니?..", forKey: "title")
        diary.setValue("잘 되니?..", forKey: "body")
        diary.setValue(Date(), forKey: "createdAt")
        
        do {
            try container.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let diary = diaryDataSource.itemIdentifier(for: indexPath) else { return }
        //pushDiaryViewController(with: diary)
    }
}
