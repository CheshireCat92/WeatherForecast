//
//  InfoViewModel.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

enum InfoViewState {
    case initial
    case loading
    case error
    case normal
}

struct InfoViewModel {
    let state: InfoViewState
    let text: String
}
