$ ->
  $("#submit_step1").click (e) ->
    e.preventDefault()
    if $("#submission_panel_1 input[type=checkbox]:checked").length < 2
      $("#prereq_modal").modal 'show'
    else
      show_step(2)

  $("#submit_step2").click (e) ->
    e.preventDefault()
    show_step(3) if $("#new_report").validate().form()

  $("#submit_step3_fb").click (e) ->
    e.preventDefault()
    $("#provider").val "facebook"
    $("#new_report").submit()

  $("#submit_step3_vk").click (e) ->
    e.preventDefault()
    $("#provider").val "vkontakte"
    $("#new_report").submit()

  $("#report_doctor_experience, #report_hospital_experience").focusin ->
    $(this).animate { height: $(this).height() + 100 }, 200
  $("#report_doctor_experience, #report_hospital_experience").focusout ->
    $(this).animate { height: $(this).height() - 100 }, 200


  # Activate rich select box for Occurred field
  $("select#report_occurred").selectBoxIt()
  
  $("#oblast").select2({ allowClear: true }).on "change", (e) ->
    refresh_district()
  
  $("#district").select2({ allowClear: true, data: [], containerCss: { display: "none"} })
  $("#hospital").select2({ allowClear: true, data: [], containerCss: { display: "none"} })

  
  if $("#new_report").length > 0
    $("#new_report").validate {
      onkeyup: false,
      errorElement: "span",
      errorClass: "help-inline",
      errorPlacement: (error, element) -> 
        error.insertBefore $(element).closest("div.controls")
      ,
      highlight: (element, errorClass) ->
        $(element).closest("div.control-group").addClass "error"
      ,
      unhighlight: (element, errorClass) ->
        $(element).closest("div.control-group").removeClass "error"
      ,
      ignore: "",
      rules: {
        hospital: {
          required: true
        },
        doctor: {
          required: true,
          minlength: 5
        },
        "report[doctor_experience]": {
          required: true,
          minlength: 50
        },
        "report[hospital_experience]": {
          minlength: 30
        },
      }
    }


window.show_step = (step) ->
  $("#steps_block .step_link").removeClass('green_step').eq(step-1).addClass('green_step')

  current = $(".step_slide_block .current")
  target = $("#submission_panel_#{step}")

  current.fadeOut 300, ->
    $(this).removeClass 'current'
    target.fadeIn 300, ->
      $(this).addClass 'current'

  $('html, body').scrollTop $("#Submission").offset().top

selection_initialization = (element, callback) ->
  data = [ element.val() ]
  callback(data)

reload_location_data = ->
  parameters = { oblast: $("#oblast").val(), district: $("#district").val() }
  # FIXME: Hard coded paths are bad, but we don't have access to url helpers.
  $.get "/hospitals/locations.json", parameters, (data) ->
    if data.districts
      districts = ({ id:v,text:v } for v in data.districts)
      $("#district").select2({ data: districts, initSelection: selection_initialization, allowClear: true }).on "change", (e) ->
        refresh_hospital()

    if data.hospitals
      hospitals = ({ id:v.id,text:v.name } for v in data.hospitals)
      $("#hospital").select2({ data: hospitals, initSelection: selection_initialization, allowClear: true }).on "change", (e) ->
        refresh_doctor()

refresh_district = ->
  $("#district").val("")
  refresh_hospital()

  if $("#oblast").val()
    reload_location_data()
  else 
    $("#s2id_district").fadeOut()


refresh_hospital = ->
  $("#hospital").val ""
  refresh_doctor()

  if $("#district").val()
    reload_location_data()
  else 
    $("#s2id_hospital").fadeOut()


refresh_doctor = ->
  if $("#hospital").val() 
    $("#doctor").attr "data-autocomplete", "/hospital/#{ $("#hospital").val() }/autocomplete_doctors"
    $("#doctor_container:hidden").fadeIn()
  else 
    $("#doctor_container:visible").fadeOut()

