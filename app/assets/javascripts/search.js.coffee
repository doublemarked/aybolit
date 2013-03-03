more_results = false

$ ->
  # Activate rich select box for sorting
  $("select#sorting").selectBoxIt()

  $("select#sorting").change ->
    # Sorting changes should affect both the query_form for future queries
    # and the result set form (which we immediately update)
    $("form :input[name=sorting]").val $(this).val()
    $("form :input[name=offset]").val 0
    $("#results_container").empty()
    $("#results_form").submit()

  
  $(".autoselector").on "autocompleteselect", (e, ui) ->
    $(this).val ui.item.value
    $(this).autocomplete "close"
    $(this).closest("form").submit()
    e.preventDefault()
  
  # Manual changes to location should negate our geoloc position.
  # If they don't type in there, though, we'll keep using the coordinates.
  # This is to retain position precision obtained from geoloc 
  # even though our location field displays a simplified address.
  $("#query_form :input[name=location]").change ->
    clear_geolocation()


  $('#query_form').bind 'ajax:before', ->
    # Clear our result set before our search
    $("#results_container").empty()
    $("#results_empty").hide()
    $("#more_results_bar").hide()
    show_loading_pacifier()


  $('#results_form').bind 'ajax:before', ->
    $("#results_empty").hide()
    $("#more_results_bar").hide()
    show_loading_pacifier()


  $("#more_results_link").click (e) ->
    $("#results_form :input[name=offset]").val $('#results_container .query_result').length
    $("#results_form").submit()
    e.preventDefault()

  
  $(".onpage_query_link").click (e) ->
    location_query $(this).text()
    e.preventDefault()


  $("#geolocate_button").click (e) ->
    geolocation_query()
    e.preventDefault()


  $('#query_form, #results_form').bind 'ajax:complete', ->
    $("#results_loading").stop(true,true).hide()
    reveal_results()


# Cascade reveal our results w/ animation
window.reveal_results = -> 
  if $(".query_result").length > 0 
    count = $(".query_result:hidden").length
    $(".query_result:hidden").each (index) ->
      $(this).delay(index*100).fadeIn(500)
    if more_results
      $("#more_results_bar").delay(count*100).fadeIn(500)
  else 
    show_empty_results()
    $("#more_results_bar").hide()

window.has_more_results = (more) ->
  more_results = more

# Store criteria from our search back into our forms
window.store_criteria = (criteria) ->
  # Note: This updates both query_form and results_form fields
  $("form :input[name=#{k}]").val v for k,v of criteria
      
clear_geolocation = ->
  $("#query_form :input[name=latitude]").val ""
  $("#query_form :input[name=longitude]").val ""

show_loading_pacifier = ->
  $("#results_loading").delay(500).fadeIn()

show_empty_results = ->
  $("#results_empty_query").text $("#query").val()
  $("#results_empty").show()

location_query = (terms) ->
  clear_geolocation()
  $("#query_form :input[name=location]").val terms
  $("#query_form").submit()

geolocation_query = ->
  navigator.geolocation.getCurrentPosition (data) -> 
    return if !data.coords

    $("#query_form :input[name=latitude]").val(data.coords.latitude)
    $("#query_form :input[name=longitude]").val(data.coords.longitude)
    $("#query_form :input[name=location]").val("")

    $("#query_form").submit()
