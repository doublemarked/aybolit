$ ->
  $("#report-stats-panel-dismiss").click ->
    $(".report-stats-panel").slideUp duration: 200

  $(".report-stats-toggle").click ->
    if $(".report-stats-panel:hidden").length > 0
      $(".report-stats-panel").slideDown duration: 200
    else
      $(".report-stats-panel").slideUp duration: 200

