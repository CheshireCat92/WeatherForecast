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
        static let defaultStringValue = LocalizedStrings.Weather.defaultValue
        static let nowString = LocalizedStrings.Weather.now
        static let tomorrowString = LocalizedStrings.Weather.tomorrow
        static let todayString = LocalizedStrings.Weather.today
        static let updated = LocalizedStrings.Weather.updated
        static let updatedAt = LocalizedStrings.Weather.updatedAt
        static let urlPathPart = "https:"
    }

    weak var viewController: ViewControllerProtocol?

    private func prepareCurrentPositionModel(_ data: PresenterWeatherModel) -> CurrentPositionViewModel {
        let minTemp = data.currentDayWeather?.day.mintempC.formatToMesurment(.celsius) ?? Constants.defaultStringValue
        let maxTemp = data.currentDayWeather?.day.maxtempC.formatToMesurment(.celsius) ?? Constants.defaultStringValue
        let temp = String(format: LocalizedStrings.Weather.maxMin, maxTemp, minTemp)
        let feelsLike = String(
            format: LocalizedStrings.Weather.feelsLike,
            data.currentWeather.feelslikeC.formatToMesurment(.celsius)
        )
        let currentPlaceViewModel = CurrentPositionViewModel(
            city: data.currentPlace.name,
            feelsLike: feelsLike,
            current: data.currentWeather.tempC.formatToMesurment(.celsius),
            maxMinTemp: temp
        )
        return currentPlaceViewModel
    }

    private func prepareHoursForecastModel(_ data: PresenterWeatherModel) -> HoursForecastViewModel {
        let models:[HourViewModel] = data.hoursForecast.enumerated().map {
            let isNextDayStart = $0.element.timeEpoch.isNextDayStart() ? Constants.tomorrowString : $0.element.time.formatDateString()
            return HourViewModel(
                isNow: $0.offset == 0,
                isNextDayStart: $0.element.timeEpoch.isNextDayStart(),
                time: $0.offset == 0 ? Constants.todayString : isNextDayStart ?? Constants.defaultStringValue,
                temperature: $0.element.tempC.formatToMesurment(.celsius),
                imageURL: URL(string: Constants.urlPathPart + $0.element.condition.icon)
            )
        }
        return HoursForecastViewModel(forecast: models)
    }

    private func prepareDailyForecastModel(_ data: PresenterWeatherModel) -> DailyForecastViewModel {
        let models: [DayViewModel] = data.daysForecast.enumerated().map {
            let isCurrentDay = $0.offset == 0
            return DayViewModel(
                isCurrentDay: isCurrentDay,
                day: isCurrentDay ? Constants.todayString : $0.element.date.formatToLocalizedDay() ?? Constants.defaultStringValue,
                imageURL: URL(string: Constants.urlPathPart + $0.element.day.condition.icon),
                minTemp: $0.element.day.mintempC.formatToMesurment(.celsius),
                maxTemp: $0.element.day.maxtempC.formatToMesurment(.celsius)
            )
        }
        return DailyForecastViewModel(forecast: models)
    }
}

extension Presenter: PresenterProtocol {
    func didFailWithError(error: String) async {
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
            model = .init(state: .loading, text: LocalizedStrings.Weather.loading)
        case .error:
            model = .init(state: .error, text: LocalizedStrings.Weather.errorText)
        case .normal:
            var text = Constants.updated
            if let time = Date.now.toString(.HHmm) {
                text = String(format: Constants.updatedAt, time)
            }
            model = .init(state: .normal, text: text)
        }

        await viewController?.displayInfoData(viewModel: model)
    }
}
