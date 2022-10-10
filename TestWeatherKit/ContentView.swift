//
//  ContentView.swift
//  TestWeatherKit
//
//  Created by Elliot Knight on 10/10/2022.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct ContentView: View {
	// Paris's location
	static let location = CLLocation(
		latitude: .init(floatLiteral: 48.856613),
		longitude: .init(floatLiteral: 2.352222)
	)

	@State private var weather: Weather?

	func getWeather() async {
		do {
			weather = try await Task {
				try await WeatherService.shared.weather(for: Self.location)
			}.value
		} catch {
			fatalError("\(error)")
		}
	}
	var body: some View {
		VStack(spacing: 15) {
			if let weather = weather {
				Text("Paris")
					.font(.title.bold())
				Text(weather.currentWeather.isDaylight == true ? "Journée" : "Nuit")
				HStack {
					Image(systemName: weather.currentWeather.symbolName)
					Text(weather.currentWeather.temperature.description)

				}
				.font(.headline)
			} else {
				ProgressView()
			}
		}
		.padding()
		.background(.thinMaterial)
		.task {
			await getWeather()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
