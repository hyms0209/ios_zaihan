
import UIKit

enum PermissionData {
    case network
    case phone
    case alarm
    case storage
    case camera
    case location
    case picture
    
    var isEssential: Bool {
        switch self {
        case .network  : return false
        case .phone    : return false
        case .alarm    : return false
        case .storage  : return true
        case .camera   : return true
        case .location : return true
        case .picture  : return false
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .network  : return UIImage(named: "access authority")
        case .phone    : return UIImage(named: "access authority-1")
        case .alarm    : return UIImage(named: "access authority-2")
        case .storage  : return UIImage(named: "access authority-3")
        case .camera   : return UIImage(named: "access authority-4")
        case .location : return UIImage(named: "access authority-5")
        case .picture  : return UIImage(named: "access authority-6")
        }
    }
    
    var title: String {
        switch self {
        
        case .network  : return "Wi-Fi 연결정보(필수)"
        case .phone    : return "전화(필수)"
        case .alarm    : return "알림(필수)"
        case .storage  : return "저장 공간(선택)"
        case .camera   : return "카메라(선택)"
        case .location : return "위치 정보(선택)"
        case .picture  : return "사진(선택)"
        }
    }
    
    var detail: String {
        switch self {
        case .network  : return "앱 이용 네트워크 연결 체크"
        case .phone    : return "전화번호 확인을 위해 사용"
        case .alarm    : return "이벤트, 공지 알림, 상품 수신 알림을 위해 사용"
        case .storage  : return "서비스 이용을 위한 데이터를 저장하기 위해 사용"
        case .camera   : return "모멘트 서비스 이용 시 사진 및 동영상 촬영을 위해 사용"
        case .location : return "사용자 위치 정보를 확인하여 정보 제공"
        case .picture  : return "재한의 서비스 이용 시 내 기기에서 사진 파일을 전송하기 위해 사용"
        }
    }
    
    static var allCases: [PermissionData] {
        return [
                .network,
                .phone,
                .alarm,
                .storage,
                .camera,
                .location,
                .picture
            ]
    }
    
    static var allModels: [PermissionModel] {
        return allCases.map {
            PermissionModel(data: $0)
        }
    }
}

class PermissionModel {
    
    private(set) var data: PermissionData!
    var isSelected = false
    
    init(data: PermissionData) {
        self.data = data
    }
}

class PermissionVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    static func instance() -> PermissionVC {
        return UIStoryboard(name: "Permission", bundle: nil)
            .instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
    }
    
    private var models = PermissionData.allModels
    
    /// 권한동의 체크 후 실행 할 블럭지정
    var complete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PermissionVCHeaderView.self, forHeaderFooterViewReuseIdentifier: PermissionVCHeaderView.identifier)
        //tableView.register(PermissionVCFooterView.self, forHeaderFooterViewReuseIdentifier: PermissionVCFooterView.identifier)
    }
    
    /// 권한동의 상태체크
    static func requiredPermissionCheck(_ complete: @escaping (() -> ())) {
        if globalDefaults.permissionComplete {
            complete()
        } else {
            let vc = instance()
            vc.complete = complete
            let topVc = UIApplication.topViewController()
            topVc?.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        self.complete?()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        exit(0)
    }
    
    deinit {
        print("PermissionVC Deinit!!!")
    }
}

extension PermissionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 148
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        func ratio(from: CGFloat) -> CGFloat {return (from / 513) * tableView.bounds.height}
//        switch models[indexPath.row].data {
//        case .storage?: return ratio(from: 80)
//        default: return ratio(from: 65)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PermissionVCHeaderView.identifier) as! PermissionVCHeaderView
        headerView.tableView = tableView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PermissionVCTableViewCell.identifier) as! PermissionVCTableViewCell
        cell.model = models[indexPath.row]
       
        return cell
    }
    
}
