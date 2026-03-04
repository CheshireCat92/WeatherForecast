//
//  Presenter.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func updateInfoState(_ state: PresenterInfoState) async
    func didFailWithError(error: String) async
    func didFetchData(data: PresenterWeatherModel) async
}

final class Presenter {
    private enum Constants {
        static let defaultStringValue = "-"
    }

    weak var viewController: ViewControllerProtocol?

    private func prepareCurrentPositionModel(_ data: PresenterWeatherModel) -> CurrentPositionViewModel {
        let minTemp = data.currentDayWeather?.day.mintempC
        let maxTemp = data.currentDayWeather?.day.maxtempC
        let currentPlaceViewModel = CurrentPositionViewModel(
            city: data.currentPlace.name,
            feelsLike: data.currentWeather.feelslikeC.formatToMesurment(.celsius),
            current: data.currentWeather.tempC.formatToMesurment(.celsius),
            minTemp: minTemp?.formatToMesurment(.celsius) ?? Constants.defaultStringValue,
            maxTemp: maxTemp?.formatToMesurment(.celsius) ?? Constants.defaultStringValue
        )
        return currentPlaceViewModel
    }

    private func prepareHoursForecastModel(_ data: PresenterWeatherModel) -> HoursForecastViewModel {
        let models:[HourViewModel] = data.hoursForecast.enumerated().map {
            let isNextDayStart = $0.element.timeEpoch.isNextDayStart() ? "Завтра" : $0.element.time.formatDateString()
            return HourViewModel(
                isNow: $0.offset == 0,
                isNextDayStart: $0.element.timeEpoch.isNextDayStart(),
                time: $0.offset == 0 ? "Сейчас" : isNextDayStart ?? Constants.defaultStringValue,
                temperature: $0.element.tempC.formatToMesurment(.celsius),
                imageURL: URL(string: "https:" + $0.element.condition.icon)
            )
        }
        return HoursForecastViewModel(forecast: models)
    }

    private func prepareDailyForecastModel(_ data: PresenterWeatherModel) -> DailyForecastViewModel {
        let models: [DayViewModel] = data.daysForecast.enumerated().map {
            let isCurrentDay = $0.offset == 0
            return DayViewModel(
                isCurrentDay: isCurrentDay,
                day: isCurrentDay ? "Сегодня" : $0.element.date.formatToLocalizedDay() ?? Constants.defaultStringValue,
                imageURL: URL(string: "https:" + $0.element.day.condition.icon),
                minTemp: $0.element.day.mintempC.formatToMesurment(.celsius),
                maxTemp: $0.element.day.maxtempC.formatToMesurment(.celsius)
            )
        }
        return DailyForecastViewModel(forecast: models)
    }
}

extension Presenter: PresenterProtocol {
    func didFailWithError(error: String) async {
//        await viewController?.displayInfoData(viewModel: .init(state: .error, text: "Что-то не так. Нажми, чтобы обновить"))
        await updateInfoState(.error)
    }

    func didFetchData(data: PresenterWeatherModel) async {

        let current = prepareCurrentPositionModel(data)
        let hours = prepareHoursForecastModel(data)
        let daily = prepareDailyForecastModel(data)
        let model = ForecastViewModel(
            currentPositionModel: current,
            hoursForecastModel: hours,
            dailyForecastModel: daily
        )

        await updateInfoState(.normal)
        await viewController?.displayData(viewModel: model)
    }

    func updateInfoState(_ state: PresenterInfoState) async {
        var model: InfoViewModel
        switch state {
        case .initial:
            model = .init(state: .initial, text: Constants.defaultStringValue)
        case .loading:
            model = .init(state: .loading, text: "Осматриваемся...")
        case .error:
            model = .init(state: .error, text: "Что-то не так. Нажмите для обновления")
        case .normal:
            var text = "Обновлено."
            if let time = Date.now.toString(.HHmm) {
                text = "Обновлено в \(time)."
            }
            model = .init(state: .normal, text: text + " Нажмите для обновления")
        }

        await viewController?.displayInfoData(viewModel: model)
    }
}
