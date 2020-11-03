package com.mapbox.navigation.core.navigator

import com.mapbox.navigation.base.trip.model.alert.RouteAlert

data class RouteInitInfo(
    val routeAlerts: List<RouteAlert>
)
