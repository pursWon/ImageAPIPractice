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
        views.forEach { imageView in
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor.black.cgColor
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
                guard let imageURL1 = URL(string: self.dataList[0].image_url) else { return }
                        
                        if let imageData = try? Data(contentsOf: imageURL1) {
                            DispatchQueue.main.async {
                                self.imageViewOne.image = UIImage(data: imageData)
                            }
                        }
                
                guard let imageURL2 = URL(string: self.dataList[1].image_url) else { return }
                
                if let imageData = try? Data(contentsOf: imageURL2) {
                    DispatchQueue.main.async {
                        self.imageViewTwo.image = UIImage(data: imageData)
                    }
                }
                
                guard let imageURL3 = URL(string: self.dataList[2].image_url) else { return }
                
                if let imageData = try? Data(contentsOf: imageURL3) {
                    DispatchQueue.main.async {
                        self.imageViewThree.image = UIImage(data: imageData)
                    }
                }
                
                guard let imageURL4 = URL(string: self.dataList[3].image_url) else { return }
                
                if let imageData = try? Data(contentsOf: imageURL4) {
                    DispatchQueue.main.async {
                        self.imageViewFour.image = UIImage(data: imageData)
                    }
                }
                
            default:
                print("데이터 연결 실패")
            }
        }
        dataTask.resume()
    }
}

