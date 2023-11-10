//
//  WeatherViewControllerTests.swift
//  ExampleTests
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import YumemiWeather
@testable import Example

class WeatherViewControllerTests: XCTestCase {

    var weahterViewController: WeatherViewController!
    var weahterModel: WeatherModelMock!
    var disasterModel: DisasterModelMock!
    
    override func setUpWithError() throws {
        weahterModel = WeatherModelMock()
        disasterModel = DisasterModelMock()
        weahterViewController = R.storyboard.weather.instantiateInitialViewController()!
        weahterViewController.weatherModel = weahterModel
        weahterViewController.disasterModel = disasterModel
        _ = weahterViewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
        weahterModel.fetchedWeatherStub = {
            let response = Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())
            return Result<Response, WeatherError>.success(response)
        }()
        
        weahterViewController.loadWeather(nil)
        
        //XCTest内での非同期処理の呼び出し方の参考: https://qiita.com/chocoyama/items/620c7b0b6ec9e235e9ea
        let expectation = self.expectation(description: "wait for async task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.red())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.sunny())
            expectation.fulfill()
        }
        // fullfillメソッドが呼び出されるまでテストを終了させずに最大0.2秒間待機する
        self.wait(for: [expectation], timeout: 0.2)
    }
    
    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        weahterModel.fetchedWeatherStub = {
            let response = Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())
            return Result<Response, WeatherError>.success(response)
        }()
        
        weahterViewController.loadWeather(nil)
        //XCTest内での非同期処理の呼び出し方の参考: https://qiita.com/chocoyama/items/620c7b0b6ec9e235e9ea
        let expectation = self.expectation(description: "wait for async task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.gray())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.cloudy())
            expectation.fulfill()
        }
        // fullfillメソッドが呼び出されるまでテストを終了させずに最大0.2秒間待機する
        self.wait(for: [expectation], timeout: 0.2)
    }
    
    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        weahterModel.fetchedWeatherStub = {
            let response = Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())
            return Result<Response, WeatherError>.success(response)
        }()
        
        weahterViewController.loadWeather(nil)
        //XCTest内での非同期処理の呼び出し方の参考: https://qiita.com/chocoyama/items/620c7b0b6ec9e235e9ea
        let expectation = self.expectation(description: "wait for async task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.blue())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.rainy())
            expectation.fulfill()
        }
        // fullfillメソッドが呼び出されるまでテストを終了させずに最大0.2秒間待機する
        self.wait(for: [expectation], timeout: 0.2)
    }
    
    func test_最高気温_最低気温がUILabelに設定されること() throws {
        weahterModel.fetchedWeatherStub = {
            let response = Response(weather: .sunny, maxTemp: 100, minTemp: -100, date: Date())
            return Result<Response, WeatherError>.success(response)
        }()
        
        weahterViewController.loadWeather(nil)
        //XCTest内での非同期処理の呼び出し方の参考: https://qiita.com/chocoyama/items/620c7b0b6ec9e235e9ea
        let expectation = self.expectation(description: "wait for async task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.weahterViewController.minTempLabel.text, "-100")
            XCTAssertEqual(self.weahterViewController.maxTempLabel.text, "100")
            expectation.fulfill()
        }
        // fullfillメソッドが呼び出されるまでテストを終了させずに最大0.2秒間待機する
        self.wait(for: [expectation], timeout: 0.2)
    }
}

class WeatherModelMock: WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Example.Response, Example.WeatherError>) -> Void) {
        completion( fetchedWeatherStub )
    }
    
    var fetchedWeatherStub: Result<Response, WeatherError>!
}

class DisasterModelMock: DisasterModel {
    func fetchDisaster(completion: ((String) -> Void)?) {}
}
