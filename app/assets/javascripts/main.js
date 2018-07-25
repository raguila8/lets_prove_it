$(document).on('turbolinks:load', function() {
  initNavbar();
  initScroller();
  initAnimation();
  initSelector();
  initAccordion();

  if ($('#frame').length) {
    initMessages();
  }

  if ($("[data-behavior='general-notifications']").length > 0) {
    initGeneralNotifications();
  }

  if ($("[data-behavior='message-notifications']").length > 0) {
    initMessageNotifications();
  }

  if ($('#img-edit-form').length > 0) {
    initProfileImage();
  }


  // Parallax disabled for mobile screens
  if ($(window).width() >= 1260) {
		initParallax();

		$(window).stellar({
			hideDistantElements: false
		});
	}


  // Preloader
  $('.preloader img').fadeOut(); // will first fade out the loading animation
	$('.preloader').delay(400).fadeOut('slow', function() {


	});

  if ($("#topics-input").length) {
    initTopicsTags();
  }

  if ($("#problem-form").length) {
    initProblemForm();
  }

  if ($("#newConversationModal").length) {
    initNewConversationForm();
  }


   
});


/* --------------------------------------------------
	Navigation | Navbar
-------------------------------------------------- */
	
	function initNavbar(){

		// Sticky Nav & Transparent Background
		$(window).scroll(function(){
			
			if ($(window).scrollTop() > 20) {
				$('nav').removeClass('navbar-trans', 300);
				$('nav').removeClass('navbar-trans-dark');
				$('nav').addClass('navbar-small', 300);
			}
			else {
				$('nav:not(.mobile-nav)').addClass('navbar-trans', 300);
				$('nav').removeClass('navbar-small', 300);

				if ($('nav').hasClass('trans-helper')) {
					$('nav:not(.mobile-nav)').addClass('navbar-trans-dark');
				}
			}

			$('nav:not(.navbar-fixed-top)').removeClass('navbar-trans navbar-small navbar-trans-dark');

		});


		// Nav on mobile screens
		$(window).resize(function() {
	        if ($(window).width() <= 1259) {
				$('nav').addClass('mobile-nav');		        
		    } else {
		    	$('nav').removeClass('mobile-nav');
		    }

    		if ($('nav').hasClass('mobile-nav')) {
    			$('nav').removeClass('navbar-trans');
    			$('nav').removeClass('navbar-trans-dark');
    		} else {
    			if ($(window).width() >= 1259 && $(window).top) {
    				$('nav').addClass('navbar-trans');
    			}
    		}

    		// Remove dropdown open on hover for small screens
    		if ($('nav').hasClass('mobile-nav')) {

    			$('.dropdown-toggle').on('mouseover', function(e){    
    			        e.preventDefault();

    			        $('.dropdown').removeClass('open');

    			    e.stopPropagation();
    			});
    		}

    		// Close mobile menu when clicked link
    		// var isNotDropdown = $('nav:not(.mobile-nav)');

    		if (!$('.nav a').hasClass('dropdown-toggle')) {

    			$('.nav a').on('click', function(){ 
			        if($('.navbar-toggle').css('display') !='none'){
			            $(".navbar-toggle").trigger( "click" );
			        }
			    });

    		}

	    }).resize();

		// Bugfix for iOS not scrolling on open menu
	    $(".navbar-collapse").css({ maxHeight: $(window).height() - $(".navbar-header").height() + "px" });


	} // initNavbar


/* --------------------------------------------------
	Scroll Nav
-------------------------------------------------- */

	function initScroller () {

		$('#navbar').localScroll({
			easing: 'easeInOutExpo'
		});

		$('#page-top').localScroll({
			easing: 'easeInOutExpo'
		});	
	} // initScroller


/* --------------------------------------------------
	Parallax
-------------------------------------------------- */

	
	function initParallax () {

		var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);

		if (!isSafari) {
		  $(".login-2").parallax("50%", 0.2);
		}		
	}

/* --------------------------------------------------
	Animation
-------------------------------------------------- */

	function initAnimation () {
		
		new WOW().init();

	}

/* ------------------------------------------------
  Problem Form
--------------------------------------------------*/

  function initProblemForm () {
    $(document).on("keypress", ".bootstrap-tagsinput input", function(event) { 
      if (event.keyCode == 13) {
        event.preventDefault();
        return false;
      }
    });
  }

/* -------------------------------------------------
  Selector Filters
---------------------------------------------------*/

  function initSelector () {
    // Filters

    if ($('.portfolio-filters').length > 0) {
		  $('.portfolio-filters a').click(function (e) {
			    e.preventDefault();
			    $('.portfolio-filters li').removeClass('active');
			    $(this).parent().addClass('active');
    
          $('.page-title .subheading').text($(this).text());
		  });
    }

    if ($('.ft-tabs').length > 0) {
      $('.ft-tabs .tabs-list li').on('click', function() {
        $('.ft-tabs .tabs-list li').removeClass('active');
        $(this).addClass('active');
        $('.page-title .subheading').text($(this).find('.tab-top h1').text());
      });
    }
  }

/* --------------------------------------------------
  Topics Tags
 ----------------------------------------------------*/
  
  function initTopicsTags () {
    var numOfTags = $('#problem-tags').val().split(",").length;
    var tags = $('#problem-tags').val();
    $('#topics-input').change(function(){
      $(this).find('input').val('');
    });

    var data = ['AMSTERDAM', 'SYDNEY', 'LOS ANGELES', 'NEW YORK'];

    // instantiate the bloodhound suggestion engine
var numbers = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.whitespace,
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  local:  ["(A)labama","Alaska","Arizona","Arkansas","Arkansas2","Barkansas"]
});

// initialize the bloodhound suggestion engine
numbers.initialize();
    
    $('#topics-input').tagsinput({
      typeahead: {
        afterSelect: function(val) { this.$element.val(""); },
        source: function(query) {
                var result = null;
                $.ajax({
                   url: "/topics",
                   type: "get",
                   headers: {
                     Accept: "application/json"
                   },
                   data: {
                     term: query
                   },
                   async: false,
                   success: function(data) {
                       result = data;
                   } 
                });
                console.log(result);

                return result.suggestions; 

        }
      },
      freeInput: false
    });

    if ($('#problem-topics-data').length) {
      var default_tags = $('#problem-topics-data').data()["topics"].split(",");

      for (var i = 0; i < default_tags.length; i++) {
        //console.log(default_tags[i]);
        $('#topics-input').tagsinput('add', default_tags[i]);
      }
    }


    $('#topics-input').on('itemAdded', function(event) {
      $('.bootstrap-tagsinput .tag').removeClass('label label-info');
      //var hidden_field = "<input type='hidden' name='topics[name{numOfTags}' id = '{event.item}-tag'} value='{event.item}'>
      tags = $("#problem-tags").val();
      if (numOfTags >= 1) {
        $("#problem-tags").val(tags += "," + event.item.toUpperCase())
      } else {
        $("#problem-tags").val(event.item.toUpperCase())
      }
      numOfTags += 1;
      //$('#problem-form').prepend(hidden_field)
    });

    $('input').on('itemRemoved', function(event) {
      tags = $("#problem-tags").val();
      if (tags.includes(event.item.toUpperCase())) {
        tags = tags.replace(event.item.toUpperCase(), "");
      } else {
        tags = tags.replace("," + event.item.toUpperCase(), "");
      }

      $("#problem-tags").val(tags);
      numOfTags -= 1;
    });

    $('#topics-input').on('beforeItemAdd', function(event) {
      
      // event.cancel: set to true to prevent the item getting added
    });


    $('.bootstrap-tagsinput').addClass('form-group');
    $('.bootstrap-tagsinput input').addClass('form-control');
  }

/* --------------------------------------------------
 Conversations
 ----------------------------------------------------*/

  function initNewConversationForm() {
    $('#user-input').typeahead({
      source: function(query, process) {
              return $.get('/users?term=' + query, function(data) {
                return process(data.suggestions);
              });
      },

      freeInput: false
    });
  }


/* --------------------------------------------------
  Messages
 ----------------------------------------------------*/
  
  function initMessages () {
    var $messages = $('#frame .content .messages');
    $messages.animate({ scrollTop: $messages.prop("scrollHeight")}, 1000);
    //$messages.scrollTop($messages.prop("scrollHeight"));
  }

/* --------------------------------------------------
  Message Notifications
 ---------------------------------------------------*/

  function initMessageNotifications() {
    // Load navbar messages through ajax
    $.ajax({
			type: "GET",
			url: "/conversations/",
			headers: {
				Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			}
	  });


    $('.messages-notifications').on('click', '.mark-as-read', function(e) {
      e.stopPropagation();
      e.preventDefault();
      var id = $(this).closest('.notification').attr('id');
      var conversationID = parseInt(id.substring(26, id.length));

      $.ajax({
				type: "POST",
				url: "/conversations/" + conversationID + "/mark_as_read",
				headers: {
					Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()

				}
			});

    });
  }

/* ---------------------------------------------------
  General Notifications
 ----------------------------------------------------*/

  function initGeneralNotifications() {
    $.ajax({
			type: "GET",
			url: "/notifications/",
			headers: {
				Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			}
	  });

    $("[data-behavior='general-notifications-link']").on('click', function() {
      $.ajax({
        type: "POST",
			  url: "/notifications/mark_all_as_read",
			  headers: {
				  Accept: "text/javascript; charset=utf-8",
					  "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			  }
      });
    });
  }

/* ---------------------------------------------------------
  Accordion
 ----------------------------------------------------------*/

  function initAccordion() {
    $("body").on('click', ".panel-title", function() {
      if ($(this).find(".glyphicon").hasClass("glyphicon-plus")) {
        $(this).find(".glyphicon").removeClass("glyphicon-plus");
        $(this).find(".glyphicon").addClass("glyphicon-minus");
      } else {
        $(this).find(".glyphicon").removeClass("glyphicon-minus");
        $(this).find(".glyphicon").addClass("glyphicon-plus");
      }
    });
  }

/* --------------------------------------------------------
  Profile Image
  ---------------------------------------------------------- */

  function initProfileImage() {
    $('#user_avatar').on('change', function() {
      $('#img-edit-form').submit();
    });
  }
