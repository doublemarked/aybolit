$ ->
  unless $.cookie "hide_survey" 
    $("#survey_popover").delay(3000).fadeIn('slow')

  $("#survey_popover .close").click ->
    $.cookie "hide_survey", 1, { expires: 7 }
    $("#survey_popover").hide()

