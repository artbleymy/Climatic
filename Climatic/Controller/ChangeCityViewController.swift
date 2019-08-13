//
//  ChangeCityViewController.swift
//  Climatic
//
//  Created by Stanislav on 06/08/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
protocol ChangeCityDelegate {
    
    func userEnteredANewCityName(city: String)
    
}


class ChangeCityViewController: UIViewController {

    var delegate : ChangeCityDelegate?
    
    var cityName: String?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    @IBAction func changeCity(_ sender: UIButton) {
        
        guard let cityName = changeCityTextField.text else { return }
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let city = cityName{
            changeCityTextField.text = city

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
