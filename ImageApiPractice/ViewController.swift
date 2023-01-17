import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    
    var dataList: [Contents] = []
    
    let url: String = "https://dapi.kakao.com/v2/search/image?query=%EC%BF%A8%EB%A3%A8%EC%85%89%EC%8A%A4%ED%82%A4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder()
        getImage()
    }
    
    func setBorder() {
        let views: [UIView] = [imageViewOne, imageViewTwo, imageViewThree, imageViewFour]
        views.forEach {
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
        }
    }
    
    func getImage() {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK d8b066a3dbb0e888b857f37b667d96d2", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard error == nil else { return  }
            
            switch response.statusCode {
            case 200:
                guard let data = try? JSONDecoder().decode(Image.self, from: data) else { return }
                self.dataList = data.documents
                guard let imageURL = URL(string: self.dataList[0].image_url) else { return }
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.imageViewOne.image = UIImage(data: data)
                    }
                }
            default:
                print("데이터 연결 실패")
            }
        }
        dataTask.resume()
    }
}
