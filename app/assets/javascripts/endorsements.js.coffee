# Login status cache
fb_login_status = null
vk_login_status = null

$ ->
  $(".endorse_button").click (e) -> 
    e.preventDefault()
    display_endorsement_modal $(this) 

  $("#facebook_endorse").click (e) ->
    e.preventDefault()
    fb_endorse_report()
    
  $("#vkontakte_endorse").click (e) ->
    e.preventDefault()
    vk_endorse_report()
     
display_endorsement_modal = (dataobj) ->
  for k,v of dataobj.data()
    $("#endorsement_modal").data k, v

  endorsement_status ""
  $("#endorsement_modal_cnt").text dataobj.data("count")
  $("#endorsement_modal").modal 'show'

  # We fetch social network status on load to avoid having to do it
  # on the fly. This ensures that a click on the FB/VK button will pass
  # through all the way to a potential login popup handler, and therefor
  # avoid popup blockers.
  Aybolit.getCurrentUser (response) -> 
    current_user = response
    
    FB.getLoginStatus (response) -> 
      fb_login_status = response
      if !current_user && fb_login_status && fb_login_status.status == 'connected'
        $.get '/auth/facebook/callback'

    VK.Auth.getLoginStatus (response) -> 
      vk_login_status = response
      if !current_user && vk_login_status && vk_login_status.session
        $.get '/auth/vkontakte/client_link'
   

endorsement_status = (status) ->
  $("#endorsement_status").html status

  if status
    $("button .icon-spinner").hide()
    $("button .icon-double-angle-right").show()


#
# FACEBOOK RELATED FUNCTIONS
#

fb_endorse_report = () ->
  endorsement_status ""
  
  $("#facebook_endorse .icon-double-angle-right").hide()
  $("#facebook_endorse .icon-spinner").show()

  if fb_login_status && fb_login_status.status == 'connected'
    fb_perform_endorsement()
  else
    fb_perform_login()

fb_perform_login = () ->
  endorsement_status ""

  FB.login (response) ->
      if response.authResponse
        $.get '/auth/facebook/callback', () ->
          # TODO: Failure check?
          fb_perform_endorsement()
      else
        endorsement_status Aybolit.messages.login_failure
    ,{scope: 'user_location,publish_actions'}

fb_perform_endorsement = () ->
  endorsement_status ""

  report_id = $("#endorsement_modal").data 'reportid'
  report_url = [location.protocol, '//', location.host, "/reports/", report_id].join('');

  FB.api '/me/aybolit:endorse', 'post', {
      'fb:explicitly_shared': true,
      'report': report_url
    }, fb_endorsement_response

fb_endorsement_response = (response) ->
  if response.error
    if response.error.code == 3501
      endorsement_status Aybolit.messages.already_endorsed "Error: You've already endorsed this report! Thanks!"
    else 
      endorsement_status Aybolit.messages.error + ": "+ response.error.message
  else 
    endorsement_status Aybolit.messages.endorsement_complete
    $("#endorsement_modal").modal 'hide'
    $("#thanks_modal").modal 'show'
    
    # Report this endorsement back to the server.
    report_id = $("#endorsement_modal").data 'reportid'
    $.get "/reports/#{report_id}/endorse.json"


#
# VKONTAKTE RELATED FUNCTIONS
#

vk_endorse_report = () ->
  endorsement_status ""
  
  $("#vkontakte_endorse .icon-double-angle-right").hide()
  $("#vkontakte_endorse .icon-spinner").show()

  if vk_login_status && vk_login_status.session
    vk_perform_endorsement()
  else
    vk_perform_login()


vk_perform_login = () ->
  endorsement_status ""

  VK.Auth.login (response) ->
    if response.session && response.session.user 
      $.post "/auth/vkontakte/client_callback.json", 
        response.session,
        (r) -> 
          if r.status != "success" 
            endorsement_status r.error
          else
            vk_perform_endorsement()
        , "json"
    else
      endorsement_status Aybolit.messages.login_failure
  ,8192 # Wall perms


vk_perform_endorsement = () ->
  endorsement_status ""

  report_id = $("#endorsement_modal").data 'reportid'
  report_url = [location.protocol, '//', location.host, "/reports/", report_id].join('');
  
  $.get "/reports/#{report_id}/endorse.json"
  
  VK.Api.call 'wall.post', { message: $("#endorsement_modal").data('message'), attachments: report_url }, (r) ->
    if r.response && r.response.post_id
      endorsement_status Aybolit.messages.endorsement_complete
      $("#endorsement_modal").modal 'hide'
      $("#thanks_modal").modal 'show'
    else 
      endorsement_status Aybolit.messages.vk_wallpost_failure





