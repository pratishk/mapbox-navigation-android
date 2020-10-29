package com.mapbox.navigation.core.telemetry.events

class CachedNavigationFeedbackEvent(
    val feedbackId: String,
    @FeedbackEvent.Type
    val feedbackType: String,
    var description: String? = null,
    val screenshot: String,
    val feedbackSubType: MutableSet<String> = HashSet()
)
