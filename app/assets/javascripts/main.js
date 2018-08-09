$(document).on('turbolinks:load', function() {
  initNavbar();
  initScroller();
  initAnimation();
  initSelector();
  initAccordion();
  initVideoPlayer();

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

  if ($("#reportModal").length > 0) {
    $('.reportModalToggle').on('click', function() {
      $('#reportModal').modal('toggle');
    });
  }

  if ($('#msg-user-btn').length > 0) {
    $('#msg-user-btn').on('click', function() {
      $('#newConversationModal #user-input').val($('#username').text());
    });
  }

  // Mathjax
  if (window.MathJax && !$("body[data-mathjax]").length) {
    MathJax.Hub.Queue(
      ["Typeset",MathJax.Hub]
  	);
		$( "body" ).attr( "data-mathjax", true );
	}


  // Parallax disabled for mobile screens
  if ($(window).width() >= 1260) {
		initParallax();

		$(window).stellar({
			hideDistantElements: false
		});
	}

  if ($('#preview-modal').length > 0) {
    initPreview();
  }


  // Preloader
  $('.preloader img').fadeOut(); // will first fade out the loading animation
	$('.preloader').delay(400).fadeOut('slow', function() {


	});

  if ($("#topics-input").length > 0) {
    if ($('#topics-input').attr('data-behavior')) {
      $('.bootstrap-tagsinput').remove(); 
    }
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

    if ($('.navbar-fixed-top').length > 0) {
    console.log('noooooo');
		$(window).scroll(function(){
	    if ($('.navbar-fixed-top').length > 0) {
			if ($(window).scrollTop() > 20) {
				$('nav').removeClass('navbar-trans', 300);
				$('nav').removeClass('navbar-trans-dark');
				$('nav').addClass('navbar-small', 300);
      }
			else {
        if ($('.navbar-fixed-top').length > 0) {
				  $('nav:not(.mobile-nav)').addClass('navbar-trans', 300);
        
				  $('nav').removeClass('navbar-small', 300);

				  if ($('nav').hasClass('trans-helper')) {
					  $('nav:not(.mobile-nav)').addClass('navbar-trans-dark');
				  }
			  }
      }
      }
			$('nav:not(.navbar-fixed-top)').removeClass('navbar-trans navbar-small navbar-trans-dark');

		});
    }

		// Nav on mobile screens
		$(window).resize(function() {
	        if ($(window).width() <= 1259) {
				$('nav').addClass('mobile-nav');		        
		    } else {
		    	$('nav').removeClass('mobile-nav');
		    }

    		if ($('nav').hasClass('mobile-nav')) {
          console.log("sjdkjdjjjj");
    			$('nav').removeClass('navbar-trans');
    			$('nav').removeClass('navbar-trans-dark');
    		} else {
    			if ($(window).width() >= 1259 && $(window).top&& $('.navbar-fixed-top').length > 0) {
    				$('nav').addClass('navbar-trans');
            console.log("8=d");
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

    if (("#filter-btn").length > 0) {
      $('#filter-btn').on('click', function() {
        $('#item-filters').slideToggle('slow');
      });
    }

    if ($('.portfolio-filters').length > 0) {
      $('.portfolio-filters a').click(function(e) {
        e.preventDefault();
        if ($(this).attr('data-filter')) {
          $('.filter li').removeClass('active');
			    $(this).parent().addClass('active');
          $('#item-filters').attr('data-filter', $(this).attr('data-filter'));
        } else {
          $('.sorter li').removeClass('active');
			    $(this).parent().addClass('active');
          $('#item-filters').attr('data-sorter', $(this).attr('data-sorter'));
        }

 
        $.ajax({
          type: "GET",
			    url: "/problems",
			    headers: {
				    Accept: "text/javascript; charset=utf-8",
					  "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          data: {
            filter: $("#item-filters").attr('data-filter'),
            sorter: $("#item-filters").attr('data-sorter')
          },
          beforeSend: function() {
            $('#problem-feed').html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          },
          success: function() {
            $('.spinner').slideUp(1000);
          }
      });

      });

    }

    if ($('.ft-tabs').length > 0) {
      $('.ft-tabs .tabs-list li').on('click', function() {
        $('.ft-tabs .tabs-list li').removeClass('active');
        $(this).addClass('active');
        $('.tab-list-content').html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");

      });
    }
  }

/* --------------------------------------------------
  Topics Tags
 ----------------------------------------------------*/
  
  function initTopicsTags () {
    var tags = $('#problem-tags').val().split(",");
    var numOfTags = 0;
    if (tags[0] == "") {
      numOfTags = 0;
    } else {
      numOfTags = tags.length;
    }

    var tags = $('#problem-tags').val();
    $('#topics-input').change(function(){
      $(this).find('input').val('');
    });

    
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
    

    if ($('#problem-topics-data').length > 0 && !$('#topics-input').attr('data-behavior')) {
      var default_tags = $('#problem-topics-data').data()["topics"].split(",");
      for (var i = 0; i < default_tags.length; i++) {
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

    $('#topics-input').on('itemRemoved', function(event) {
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
    $('#topics-input').attr('data-behavior', 'processed') 
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

/* -------------------------------------------------------------
 Preview Modal
  -------------------------------------------------------------- */

  function initPreview() {
    $('body').on('click', '.preview-btn', function() {
		  $form = $(this).closest('form')[0];
		  var content = '';
      if ($($form).attr('id') == "problem-form") {
        content = $($form).find('input[name="problem[content]"]:first').val();
      } else if ($($form).attr('id') == "topic-form") {
        content = $($form).find('input[name="topic[description]"]:first').val();
      } else if ($($form).attr('id') == "proof-form") {
        content = $($form).find('input[name="proof[content]"]:first').val();
      } else if ($($form).attr('id') == "comment-form") {
        content = $($form).find('textarea[name="comment[content]"]:first').val();
      }
		  math = $('#preview-modal .preview_content > p');
		  math.html(content);	
		  setTimeout(function() {
			  MathJax.Hub.Queue(["Typeset", MathJax.Hub, math[0]]);
		  } ,500);
	  });
  }

/* --------------------------------------------------
	Video Background
-------------------------------------------------- */

	function initVideoPlayer () {

		var hasBgVideo = $('#fs-video-one-bg').hasClass('player');
		var hasFwBgVideo = $('#fw-video-one-bg').hasClass('player');
		var hasSecBgVideo = $('#section-video').hasClass('player');

		if (hasBgVideo || hasFwBgVideo || hasSecBgVideo) {

			$('.player').YTPlayer();

		}
		

	}

