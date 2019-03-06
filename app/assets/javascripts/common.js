$(function(){
  // flash toast message OPTIONS
  toastr.options = {
    "closeButton": true,
    "debug": false,
    "progressBar": true,
    "positionClass": "toast-bottom-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "2000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }
  flashMessages();

  // Pagination
  $("body").on("click",".show-pagination-loader a",function(){
      container = $(this).closest('.pagination_container');
      showPaginationLoader(container);
  });

  // Flip Panel
  $(".down-arrow").click(function(){
    $(this).find(".fa-rotate").toggleClass('fa-rotate-180');
    $(this).parents('.filters-container').find('.filter-body-content').slideToggle("fast");
  });
});

function flashMessages(){
  if($(".flash-messages-container").find("div").length)
  {
      var messages_obj = $(".flash-messages-container").find("div")

      $.each( messages_obj, function( key, obj ) {
          var msgType = $(obj).attr("class"),
              content = $(obj).html();

          showFlashMessage(msgType, content);

      });
  }
}

function showFlashMessage(msgType,message){
  switch(msgType)
  {
      case "error":
          toastr.options.timeOut = 600000;
          toastr.options.extendedTimeOut = 150000;
          toastr.options.progressBar = false;
          toastr["error"](message, "Error");
          toastr.options.timeOut = 5000;
          toastr.options.extendedTimeOut = 2000;
          toastr.options.progressBar = true;
          break;
      case "explicit_success":

          toastr.options = {
              "closeButton": true,
              "tapToDismiss": false,
              "positionClass": "toast-top-right"
          }

          toastr.options.timeOut = 600000;
          toastr.options.extendedTimeOut = 150000;
          toastr.options.progressBar = false;
          toastr["success"](message, "");
          toastr.options.timeOut = 5000;
          toastr.options.extendedTimeOut = 2000;
          toastr.options.progressBar = true;

          break;
      case "success":
          toastr["success"](message, "Success");
          break;
      case "info":
          toastr["info"](message, "Info");
          break;
      case "notice":
          toastr["success"](message, "Info");
          break;
      case "warning":
          toastr["warning"](message, "Warning");
          break;
      case "alert":
          toastr["warning"](message, "Warning");
          break;
  }
}

function showModel(title, modal_type)
{
    modal_type = modal_type || false;
    if(modal_type)
    {
        $("#generic_modal").find(".modal-dialog").addClass("modal-lg");
    }

    $("#generic_modal .modal-title").html(title);
    $("#generic_modal").modal('show');
}
function hideModel()
{
    $("#generic_modal").modal('hide');
}

function showConfirmModel(title)
{
    $("#confirm_modal .modal-title").html(title);
    $("#confirm_modal").modal('show');
}
function hideConfirmModel()
{
    $("#confirm_modal").modal('hide');
}

function showPaginationLoader(container){
  container.find('.pagination-loader:first').fadeIn(300);
}

function hidePaginationLoader(container){
  container.find('.pagination-loader:first').fadeOut(300);
}

function gatherFilters(inputDataParams){
  var filterObjects = {}
  $('.page-data-filters .filters-container').each(function(){
    $(this).find('.filter-order-list').each(function(){
      $(this).find('input:checked').each(function(){
        filterObjects[$(this).attr('name')] = $(this).attr('value');
      });
    });
  });

  $('.page-data-filters .filters-container').each(function(){
    $(this).find('.text-filters-container').each(function(){
      $(this).find('input[type=text]').each(function(){
        filterObjects[$(this).attr('name')] = $(this).val();
      });
    });
  });

  if(inputDataParams){
      $('.page-data-params').each(function(){
          $(this).find('input[type=hidden]').each(function(){
              filterObjects[$(this).attr('name')] = $(this).attr('value');
          });
      });
  }
  return filterObjects;
}

function previewImage(input, targetObj, type) {
  var height = (type == "profile") ? "280px" : "159px";
  var width = (type == "profile") ? "280px" : "156px";
  if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
          //console.log(e.target.result);
          // $(targetObj).attr("src", e.target.result);
          $(targetObj).css({
              "background-image" : "url("+e.target.result+")",
              "background-size" : "100% 100%",
              "height" : "+"+height+"+",
              "width" : "+"+width+"+",
              "border-radius" : "50%",
              "border" : "1px solid #ddd",
              "overflow" : "hidden",
              "margin" : "0 auto"
          });
      }
      reader.readAsDataURL(input.files[0]);
  }
}
