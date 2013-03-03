# If our map is being loaded, bind permanent hover events for all current and future
# map markers. This is necessary because on load the google map and markers aren't
# yet injected into the DOM.
$ -> 
  if $("#hospital_map").length > 0
    $(document).on 
        mouseenter: -> 
          $(this).next().fadeIn(400)
        mouseleave: -> 
          $(this).next().fadeOut(200)
        click: ->
          event.preventDefault()
          $(this).next().find("a")[0].click()
      , ".map_marker, .map_marker_silver, .map_marker_gold"

