//
//  MapViewRepresentable.swift
//  mapLibreMaskBug
//
//  Created by Nicolas Brunner on 12.03.2024.
//

import SwiftUI
import MapLibre

struct MapViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        mapView.setVisibleCoordinateBounds(swissBounds, animated: false)
        mapView.zoomLevel = 5.5
        mapView.styleURL = styleUrl
        return mapView
    }
    
    func updateUIView(_ mapView: MLNMapView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            addRainLayer(in: mapView)
        }
    }
    
    private var swissBounds: MLNCoordinateBounds {
        MLNCoordinateBounds(sw: Constant.swissSouthWest, ne: Constant.swissNorthEast)
    }
    
    private var swissQuad: MLNCoordinateQuad {
        MLNCoordinateQuad(topLeft: Constant.swissNorthWest, bottomLeft: Constant.swissSouthWest, bottomRight: Constant.swissSouthEast, topRight: Constant.swissNorthEast)
    }
    
    private var styleUrl: URL? {
        Bundle.main.url(forResource: "style", withExtension: "json")
    }
    
    private func addRainLayer(in mapView: MLNMapView) {
        let source = MLNImageSource(identifier: "rainLayer",
                                    coordinateQuad: swissQuad,
                                    url: URL(string: "https://www-stage.srf.ch/meteo/static/map/_assets/PPIMERCATORWEBP2.20240311150500.webp")!)
        mapView.style?.addSource(source)
        let rainLayer = MLNRasterStyleLayer(identifier: "rainLayer", source: source)
        mapView.style?.addLayer(rainLayer)
    }
    
    private enum Constant {
        static let swissSouthWest = CLLocationCoordinate2D(latitude: 45.742086, longitude: 5.299187)
        static let swissSouthEast = CLLocationCoordinate2D(latitude: 45.742086, longitude: 10.923908)
        static let swissNorthWest = CLLocationCoordinate2D(latitude: 47.912013, longitude: 5.299187)
        static let swissNorthEast = CLLocationCoordinate2D(latitude: 47.912013, longitude: 10.923908)
    }
}
