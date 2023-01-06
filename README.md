# 📔 일기장 📔
<br>

## 📜 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [UML](#-UML)
6. [실행화면](#-실행-화면)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [프로젝트 수행 중 핵심 경험](#-프로젝트-수행-중-핵심-경험)
9. [참고링크](#-참고-링크)

<br>

## 🗣 소개
[Ayaan🦖](https://github.com/oneStar92), [zhilly🔥](https://github.com/zhilly11) 이 만든 Core Data를 활용한 일기장 애플리케이션 입니다.

***개발 기간 : 2022-12-19 ~ 2023-01-06***

<br>

## 💻 개발환경 및 라이브러리
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-15.0-blue)]()
[![swift](https://img.shields.io/badge/Xcode_Compatible-9.3-orange)]()

<br>

## 🧑 팀원
|Ayaan|zhilly|
|:---:|:---:|
|<img src= "https://i.imgur.com/Unq1bdd.png" width ="200"/>|<img src = "https://i.imgur.com/UGDRDhT.png" width=200 height=200>|

<br>

## 🕖 타임라인

### STEP 1 - [22.12.19 ~ 22.12.23]
- 22.12.20
    - SwiftLint 적용
    - DiaryTableView Type 구현
    - DiaryCell Type 구현
- 22.12.21
    - DiaryView Type 구현
    - DiaryListViewController Type 구현
    - DiaryViewController Type 구현
    - Keyboard 관련 기능구현
    - DiaryTextView의 PlaceHolder 기능구현
- 22.12.22
    - 코드 리팩터링
    - 매직 리터럴 제거

### STEP 2 - [22.12.26 ~ 23.01.02]
- 22.12.26
    - CoreData에 DiaryData Entity 구현
    - DiaryManageable Protocol 구현
    - DiaryDataManager Type 구현
    - Diary Type 재정의
    - DiaryCoreDataStack Type 구현
- 22.12.27
    - DiaryViewController 리팩토링
    - 키보드관련 기능구현
    - ObjectID를 활용하여 CoreData를 수정, 삭제할 수 있도록 구현
- 22.12.28
    - Diary 상세 화면에 더보기 버튼 기능(공유, 삭제) 구현
    - CoreData의 데이터를 관찰하는 NotificationCenter 구현
    - Cell의 Swipe 기능 구현
    - Activity View 기능 구현
    - 코드 리팩터링
    - 매직 리터럴 제거 및 네이밍 변경 
- 23.01.02
    - ManagedObjectModel protocol 구현
    - DiaryExtractor 타입 구현 및 적용
    - DiaryManageable를 CoreDataManageable로 변경 및 수정
    - DiaryManager에 싱글톤 패턴 적용
    - Alert Factory 메서드 구현 및 적용
    - DiaryError Type 구현 및 적용
    - 코드 리팩터링
<br>

## 📊 UML

![](https://i.imgur.com/kUtqP1W.jpg)

<br>

## 💻 실행 화면

### 기본 기능
<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
|새로운 일기 추가|백그라운드 진입 시 자동 저장|빈 다이어리 자동 삭제|
|:---:|:---:|:---:|
|![](https://i.imgur.com/aPMKZuA.gif)|![](https://i.imgur.com/PkyxizR.gif)|![](https://i.imgur.com/G2GAhH2.gif)|

|가로모드|
|:---:|
|![](https://i.imgur.com/E1iFEE9.gif)|

</div>
</details>

### 상세화면

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
|상세화면에서 일기 삭제|상세화면에서 공유 기능|
|:---:|:---:|
|![](https://i.imgur.com/ZttmuOn.gif)|![](https://i.imgur.com/SeDvWzq.gif)|
        
</div>
</details>

### 스와이프

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
|스와이프를 이용하여 일기 삭제|스와이프를 이용하여 공유 기능|
|:---:|:---:|
|![](https://i.imgur.com/jpPwcAh.gif)|![](https://i.imgur.com/6SNlduZ.gif)|
        
</div>
</details>

<br>

## 🎯 트러블 슈팅 및 고민

### **DiaryManager 구현**
- CRUD를 구현하기 위해서 CoreData의 Container를 이용해야했습니다.
- `AppDelegate`에 구현을 해두면 사용할 때마다 `AppDelegate`에서 가져오고 언래핑하고 할당해주는 번거로움이 있었습니다.
- CoreData를 사용하기 위해 접근해야 되는 Container는 `DiaryCoreDataStack`이라는 싱글톤 객체로 만들었고 `DiaryDataManager`객체를 통해 CRUD의 역할을 수행했습니다.
- `DiaryCoreDataStack`의 Singleton 객체를 `DiaryDataManager`에서 사용하는 구조가 어색하게 느껴졌습니다.
- `DiaryDataManager`에 `Core Data Container`를 가지도록 구현하여 `DiaryManager` 타입을 구현했습니다.

### **ObjectID 사용**
- CoreData의 Object에서 `UUID`를 `id`로 사용하여 관리할지 제공되는 `ObjectID`를 이용할지를 고민했습니다.
- `UUID`를 사용하면 특정 object를 얻으려면 `fetch`작업을 따로 정의해서 사용해야 하는 단점이 있었습니다.
- `objectID`를 사용하면 context의 메서드를 이용해서 `update`, `delete`를 손쉽게 사용할 수 있기 때문에 `objectID`를 사용했습니다.

### **모델 분리**
- CoreData로 사용하는 모델 하나로 구현을 해야할까, 아니면 앱에서 실질적으로 사용하는 모델 타입 하나를 추가로 만들어 두개의 모델로 구현을 해야할 까 고민했습니다.
- 한 개로 하면 CoreData 모델이 비즈니스 로직을 담당할 수는 있겠지만, CoreData 모델의 역할이 많아진다고 판단했습니다.
- 그렇다고 `ViewController`에서 비즈니스 로직을 담당하는 것도 아키텍처 관점에서 어긋난다고 생각했습니다.
- 따라서 실질적으로 사용하는 모델 타입을 만들어 비즈니스 로직을 처리하게 하여 이를 해결하였습니다.

### **ManagedObjectModel 구현**
- Core Data Entity를 추가해야 할 때, Entity를 관리하는 Manager 및 VC에서 사용할 Model의 추상화를 위해 `objectID` 프로퍼티를 소유하고, `init?(from: NSManagedObject)`을 할 수 있는 추상화 객체를 프로토콜로 구현했습니다.

### **AlertFactory**
- 프로젝트를 구현하다 보니 같은 비슷한 Alert을 생성하는 코드가 많았습니다.
- 팩토리 패턴을 이용하면 반복되는 코드는 줄이고 편리하게 Alert을 보여줄 수 있다고 생각하여 구현하였습니다.




### Locale

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
- 지역 및 언어에 맞는 작성일자를 표현해주려고 했습니다. 하지만 `Locale.current`의 값이 지역을 변경하고 언어를 변경해도 `eu_KR`과 같이 언어 부분이 `eu`로 표현되는 문제가 발생했습니다.

<details>
<summary>이미지 보기</summary>
<div markdown="1">
    
|Locale Current|Device Setting|
|:---:|:---:|
|![](https://i.imgur.com/KDKMb8l.png)|![](https://i.imgur.com/vW4CMqj.png)|
    
</div>
</details>
    
- `Locale.preferredLanguages.first`를 사용하여 설정된 언어 중 첫번째 언어에 해당하는 값으로 작성일자를 표현되게 해주어 문제를 해결했습니다.
- `Locale.current`는 현재 App의 지원되는 `Localization`에 영향을 받는 것을 알게되었습니다. 어떤 `Localization`을 사용할지 결정해서 `Locale.current`에 따라서 UI를 다르게 표현해 줄 예정입니다.
    
</div>
</details>
<br>


### MainStoryboard없이 Code로 구현

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
- 요구사항에 코드로만 UI를 작성하라는 문구가 있어서 시도해보았습니다.
    1. Main.storyboard 삭제
    2. info.plist에서 storyboard관련 삭제
    3. SceneDelegate에서 ViewController로 이동할 수 있도록 RootViewController 설정

- 이와 같이 진행하고 실행시에 Main스토리보드 관련하여 에러가 뜨는 것을 확인했습니다
    1. 프로젝트 설정에서 Info탭에서 추가로 StoryBoard관련해서 삭제
    2. Build Settings에서 main storyboard관련 삭제 ![](https://i.imgur.com/6IpdAis.png)

- 위의 추가 과정을 통해 Main 스토리보드 없이 프로젝트를 진행할 수 있었습니다!
    
</div>
</details>
<br>

### NavigationBar 구분선

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
- MainStoryboard가 없이 코드로만 UI를 구성해 봤습니다. `NavigationController`및 `rootViewController`를 `SceneDelegate`에서 인스턴스화 해주어서 첫 화면이 보여지게 구현해 봤습니다. 하지만 iOS 15부터 NavigationBar의 디자인이 수정되어 구분선이 보이지 않는 현상이 발생했습니다.
- `UINavigationBarAppearance`를 인스턴스화 한 후 `configureWithOpaqueBackground()`메서드로 현재 테마에 적합한 불투명한 bar appearance object로 구성한 뒤 `NavigationController.navigationBar`에 `standardAppearance`및 `scrollEdgeAppearance`에 할당해 줌으로 이전에 발생한 문제를 해결했습니다.
    
<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
let navigationController = UINavigationController(rootViewController: mainViewController)
let navigationBarAppearance = UINavigationBarAppearance()
navigationBarAppearance.configureWithOpaqueBackground()
        
navigationController.navigationBar.standardAppearance = navigationBarAppearance
navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
```
    
</div>
</details> 
</div>
</details>
<br>

### Cell의 identifier

<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
```swift
// 1번
static let identifier: String = String(describing: self)

// 2번
static func getIdentifier() -> String {
        return String(describing: self)
}
```

- 1번과 2번 방법 중 Cell의 identifier을 어떻게 사용하는 방법이 더 나은지 고민했습니다.
- 프로토콜을 사용해서 해결했습니다.
    
<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
```
    
</div>
</details>
</div>
</details>
<br>

## 💡 프로젝트 수행 중 핵심 경험

- CoreData 모델 사용
- Factory Method Pattern 활용
- Singleton Pattern 적용
- UITableViewDiffableDataSource
- Date Formatter 활용
- UIContextualAction
- UISwipeActionsConfiguration
- UIActivityViewController

## 📚 참고 링크

- [Core Data](https://developer.apple.com/documentation/coredata)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [Locale](https://developer.apple.com/documentation/foundation/locale)
- [UITableviewDiffableDatasource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
- [Cell Identifier Protocol](https://medium.com/@gonzalezreal/ios-cell-registration-reusing-with-swift-protocol-extensions-and-generics-c5ac4fb5b75e)
- [UIContextualAction](https://developer.apple.com/documentation/uikit/uicontextualaction)
- [UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
