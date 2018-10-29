$(document).on('turbolinks:load', function() {
  if ($('.secondary-dropdown').length > 0) {
    initSecondaryDropdown();
  }
});

function initSecondaryDropdown() {
  $('.secondary-dropdown-toggle').on('click', function() {
    $(this).next('.secondary-dropdown-content').toggleClass("show");
  });
  

  /* Close dropdown when user clicks outside of dropdown */
  $(window).on('click', function(event) {
    if (!event.target.matches('.secondary-dropdown-toggle')) {
      var dropdowns = $(".secondary-dropdown-content");
      var i;
      for (i = 0; i < dropdowns.length; i++) {
        var openDropdown = $(dropdowns[i]);
        if (openDropdown.hasClass('show')) {
          openDropdown.removeClass('show');
        }
      }
    }
  });
}
