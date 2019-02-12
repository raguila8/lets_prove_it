$(document).on('turbolinks:load', function() {
if (!$('.search-dropdown').attr('data-behavior')) {
  initMainSearch();
}

function initMainSearch() {
    $('.search-dropdown').attr('data-behavior', 'added');
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
  	  _create: function() {
        this._super();
        this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
      },
		  _renderItem: function( ul, item ) {
			  if (item.category === "Users") {
          if (item.image_url !== "/assets/avatar.png") {
            item.image_url = "/uploads/user/avatar/" + item.id + "/thumb_" + item.image_url;
          }
				  return $("<li>")
					  .append("<a href='/users/" + item.id + "'><img class='inline-icon' src='" + item.image_url + "'> <span class='font-weight-500 ml-5'>" + item.label + "</span></a>")
				  	.appendTo ( ul );
			  } else if (item.category === "Problems") {
				  return $("<li>")
					  .append("<a href='/problems/" + item.id + "'><span class='font-weight-500 g-ml-5'>" + item.label + "</span></a>")
					  .appendTo ( ul );
			  } else {
          return $("<li>")
					  .append("<a href='/topics/" + item.id + "'><span class='font-weight-500 g-ml-5 topic-label'>" + item.label.toLowerCase() + "</span></a>")
					  .appendTo ( ul );
        }
		  },
      _renderMenu: function( ul, items ) {
        var that = this,
        currentCategory = "users";
        $.each( items, function( index, item ) {
          var li;
          if ( item.category != currentCategory ) {
            ul.append( "<li class='ui-autocomplete-category " + item.category + "-cat'>" + item.category + "</li>" );
            currentCategory = item.category;
          }
          li = that._renderItemData( ul, item );
          if ( item.category ) {
            li.attr( "aria-label", item.category + " : " + item.label );
          }
        });
      }
    });

    $("#main-search").catcomplete( {
		  delay: 0,
		  source: function( request, response ) {
			  $.ajax({
				  type: "GET",
				  url: "/main_search",
				  data: {
					  query: request.term
				  },
				  success: function(data) {
					  response(data.suggestions);
			  	}
			  });
		  },
		  select: function(event, ui) {	
			  $("#main-search").val(ui.item.name);
			  if (ui.item.category === "Users") {
				  window.location.href = "/users/" + ui.item.id;
			  } else if (ui.item.category === "Problems") {
				  window.location.href = "/problems/" + ui.item.id;
		  	} else {
          window.location.href = "/topics/" + ui.item.id;
        }
		  },
		  focus: function(event, ui) {
			  event.preventDefault();
			  $('#main-search').val(ui.item.label);
        $(this).addClass('ui-state-active');
		  },
      open: function() {
        var position = $(".ui-menu").position(),
          left = position.left, top = position.top;
        $(".ui-menu").css({ left: left + -15 + "px",
                                top: top + 20 + "px"});
      }
	  });	

  }
});
