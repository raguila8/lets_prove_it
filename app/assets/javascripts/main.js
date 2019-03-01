$(document).on('turbolinks:load', function() {
  $(window).unbind('scroll');

  initNavbar();
  initScroller();
  initAnimation();
  initSelector();
  initAccordion();
  initVideoPlayer();
  initCommentsLinks();

  if ($('#proof-form, #edit-proof-form, #problem-form, #edit-problem-form').length > 0) {
    initFullscreen();
  }

  if ($('#problem-form').length > 0) {
    //initNewProblemForm();
  }
  
  if ($('textarea').length > 0) {
    initTextarea();
  }

  if ($('.fancy-tabs').length > 0) {
    initFancyTabs();
  }

  if ($('#sticky-nav').length > 0) {
    initStickyNav();
  }
  
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
  if (window.MathJax && !$("body[data-mathjax]").length && !$("#edit-problem-page").length && !$("#edit-topic-page").length) {
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

  if ($('.preview-btn').length > 0) {
    initPreview();
  }

  // cancel new-comment
  if ($("#problem-page").length > 0) {
    $("body").on('click', "#cancel-new-comment", function(e) {
      $('#comment-form').remove();
      $('.comment-replay-btn').show();
    });
  }

  // No comment privilige modal
  if ($('.no-comment-priv').length > 0) {
    $('body').on('click', '.no-comment-priv', function() {
      $('#noPriviligeModal .modal-body .custom-content').html("<p>You need at least 50 <a href='/help/reputation'>reputation</a> to comment. Gain more privileges by increasing your reputation by posting helpful problems and proofs.</p><a href='/help/priviliges/3' class='btn btn-ghost text-center btn-small mb-10'>Learn More</a>");
    });
  }

  // report-info-modal tabs
  if ($('#report-info-modal').length > 0) {
    $('#report-info-modal').on('click', '.nav-tabs li', function() {
      $('#report-info-modal .nav-tabs li').removeClass('active');
      $(this).addClass('active');
    });
  }


  // Preloader
  $('.preloader img').fadeOut(); // will first fade out the loading animation
	$('.preloader').delay(400).fadeOut('slow', function() {


	});

  // Report other checkbox
  if ($('#reportModal').length > 0) {
    $('#reportModal').on('click', '#other-checkbox input', function() {
      $('#reportModal #reason-input').toggle($(this).checked);
    });
  }

  if ($("#topics-input").length > 0) {
    if ($('#topics-input').attr('data-behavior')) {
      $('.bootstrap-tagsinput').remove(); 
    }
      initTopicsTags();
  }

  if ($("#edit-followed-topics").length > 0) {
    var topicsMap = new Map();
    $('.tags-widget .tag-list li a').each(function(idx, topic) {
      var $topic = $(topic);
      topicsMap.set($topic.text(), $topic.attr('data-id'));
    });

    $('.tags-widget #edit-followed-topics').on('click', function() {
      $(this).hide();
      var html = `<input value="" id="followed-topics" type="hidden" name="topic_following[topic]">
        <div class="form-group" id="followed-topics-data" data-topics="${Array.from(topicsMap.keys()).join(',')}">
        <label for="topic_name">Topics:</label>
        <input class="form-control" type="text" name="topic[name]" id="follow-topics-input" data-provide="typeahead" placeholder="Search for a topic">
      </div>`;
      $(".tags-widget .tag-list-container").html(html);
      $('#follow-topics-input').focus();
      $('body').on('click', '.tag-list-container .tag', function() {
        window.location.href = "/topics/" + topicsMap.get($(this).text());
      });

      if ($('#follow-topics-input').attr('data-behavior')) {
        $('.bootstrap-tagsinput').remove(); 
      }
      initFollowTopicsWidget(topicsMap);

    });
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
    			$('nav').removeClass('navbar-trans');
    			$('nav').removeClass('navbar-trans-dark');
    		} else {
    			if ($(window).width() >= 1259 && $(window).top&& $('.navbar-fixed-top').length > 0) {
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
    new SmoothScroll('a[href*="#page-top"]');
    if ($('#help_center').length > 0) {
      new SmoothScroll('a[href*="#problems"]');
      new SmoothScroll('a[href*="#general"]');
      new SmoothScroll('a[href*="#reputation"]');
      new SmoothScroll('a[href*="#proofs"]');
      new SmoothScroll('a[href*="#account"]');
      new SmoothScroll('a[href*="#editing-faq"]');
      new SmoothScroll('a[href*="#create-new-topic-faq"]');
      new SmoothScroll('a[href*="#topics-faq"]');
      new SmoothScroll('a[href*="#privilege-faq"]');
      new SmoothScroll('a[href*="#good-problems-faq"]');
      new SmoothScroll('a[href*="#mathjax-faq"]');
      new SmoothScroll('a[href*="#post-deletion-faq"]');
    }

    if ($(".landing-hero").length > 0) {
      new SmoothScroll('a[href*="#about"]');
    }

    if ($('.addProofIcon').length > 0) {
      new SmoothScroll('a[href*="#proof-form"]');

      $(document).on('scrollStop', function(e) {
        if ($(event.detail.anchor).is($('#proof-form'))) {
          $('#proof-form trix-editor').focus();
        }
      });
/*
      $('.addProofIcon').on('click', function() {
        $('#proof-form trix-editor').focus();
      });
      */
    }


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
  Selector and Search Filters
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

        var url = "";

        var data = new Object();
        data.sorter = $("#item-filters").attr('data-sorter');
        
        if ($('#problem-feed').length > 0) { 
          url = "/problems"
          $feed = $('#problem-feed');
          data.filter = $("#item-filters").attr('data-filter');
          data.search_filter = $("#item-filters").attr('data-search-filter')
        } else if ($('#topic-feed').length > 0) {
          url = "/topics";
          $feed = $('#topic-feed');
          data.search_filter = $("#item-filters").attr('data-search-filter')
        } else if ($('#users-feed').length > 0) {
          url = "/users";
          $feed = $('#users-feed');
          data.filter = $("#item-filters").attr('data-filter');
          data.search_filter = $("#item-filters").attr('data-search-filter')
        } else if ($('#notifications-feed').length > 0) {
          url = "/notifications";
          $feed = $('#notifications-feed');
          data.filter = $("#item-filters").attr('data-filter');
        }

        $.ajax({
          type: "GET",
			    url: url,
			    headers: {
				    Accept: "text/javascript; charset=utf-8",
				   "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          data: data,
          beforeSend: function() {
            $feed.html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          },
          success: function() {
            $('.spinner').slideUp(1000);
          }
        });

      });

    }

    if ($('#search-header').length > 0) {
      $('#search-header input').on('input', function(e) {
        e.preventDefault();
        $('#item-filters').attr('data-search-filter', $(this).val());
        var data = new Object();
        data.sorter = $("#item-filters").attr('data-sorter');
        data.search_filter = $("#item-filters").attr('data-search-filter');

        if ($('#topic-feed').length > 0) {
          url = "/topics";
          $feed = $('#topic-feed');
        } else if ($('#users-feed').length > 0) {
          url = "/users";
          $feed = $('#users-feed');
          data.filter = $("#item-filters").attr('data-filter');
        } else if ($('#problem-feed').length > 0) {
          url = "/problems"
          $feed = $('#problem-feed');
          data.filter = $("#item-filters").attr('data-filter');
        }


        $.ajax({
          type: "GET",
			    url: url,
			    headers: {
				    Accept: "text/javascript; charset=utf-8",
				   "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          data: data,
          beforeSend: function() {
            $feed.html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          },
          success: function() {
            $('.spinner').slideUp(1000);
          }
        });

      });
    }

    if ($('.ft-tabs').length > 0) {
      $('.ft-tabs .tabs-list li').on('click', function() {
        if ($(this).closest('.fixed-tabs-list').length > 0) {
          return;
        } else {
          $(this).closest(".tabs-list").find("li").removeClass("active");
          //$('.ft-tabs .tabs-list li').removeClass('active');
          $(this).addClass('active');
          if ($("#help_center").length == 0 && $("#priviliges-page").length == 0 ) {
            $('.tab-list-content').html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          }
          if ($(this).closest('.priv-tabs-list').length > 0) {
            $(".priv-content .tab-pane").removeClass("in active");
            $(".priv-content " + $(this).find("a").attr("href")).addClass("in active");
          }
          if ($(this).closest('#priviliges-page').length > 0) {
            $('.tab-pane').removeClass("in active");
            $(".tab-content " + $(this).find("a").attr("href")).addClass("in active");
          }
        }
      });
    }

    if ($('#help_center').length > 0) {
      $(window).scroll(function() {
        if ($(window).width() < 768 && $(this).scrollTop() >= $(".navbar").height()) {
          $('.tab-navbar .fixed-tabs-list').stop().animate({top: "15px"}, 500);
        }

        if ($(window).width() < 768 && $(this).scrollTop() < $(".navbar").height()) {
          $('.tab-navbar .fixed-tabs-list').stop().animate({top: "95px"}, 500);
        }

        if ($(this).scrollTop() >= $('#problems').offset().top - 60) {
          $('.fixed-tabs-list li').removeClass('active');
          $('.fixed-tabs-list li:eq(0)').addClass('active');
        }
        if ($(this).scrollTop() >= $('#general').offset().top - 60) {
          $('.fixed-tabs-list li').removeClass('active');
          $('.fixed-tabs-list li:eq(1)').addClass('active');
        }
        if ($(this).scrollTop() >= $('#reputation').offset().top - 60) {
          $('.fixed-tabs-list li').removeClass('active');
          $('.fixed-tabs-list li:eq(2)').addClass('active');
        }
        if ($(this).scrollTop() >= $('#proofs').offset().top - 60) {
          $('.fixed-tabs-list li').removeClass('active');
          $('.fixed-tabs-list li:eq(3)').addClass('active');
        }
        if ($(this).scrollTop() >= $('#account').offset().top - 60) {
          $('.fixed-tabs-list li').removeClass('active');
          $('.fixed-tabs-list li:eq(4)').addClass('active');
        }

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
        $("#problem-tags").val(tags += "," + event.item.toLowerCase())
      } else {
        $("#problem-tags").val(event.item.toLowerCase())
      }
      numOfTags += 1;
      //$('#problem-form').prepend(hidden_field)
    });

    $('#topics-input').on('itemRemoved', function(event) {
      tags = $("#problem-tags").val();
      if (tags.includes(event.item.toLowerCase())) {
        tags = tags.replace(event.item.toLowerCase(), "");
      } else {
        tags = tags.replace("," + event.item.toLowerCase(), "");
      }

      $("#problem-tags").val(tags);
      numOfTags -= 1;
    });

    $('#topics-input').on('beforeItemAdd', function(event) {
      
      // event.cancel: set to true to prevent the item getting added
    });
 
    $('.bootstrap-tagsinput input').addClass('form-control');
    $('#topics-input').attr('data-behavior', 'processed') 
  }

/* --------------------------------------------------
  Folow Topics Widget
  ---------------------------------------------------- */
  function initFollowTopicsWidget(topicsMap) {

    var valid_click = false;
    
    $('#follow-topics-input').change(function(){
      $(this).find('input').val('');
    });

    
    $('#follow-topics-input').tagsinput({
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
                return result.suggestions; 
        }
      },
      freeInput: false
    });
    

    if ($('#followed-topics-data').length > 0 && !$('#follow-topics-input').attr('data-behavior')) {
      var default_tags = $('#followed-topics-data').data()["topics"].split(",");
      for (var i = 0; i < default_tags.length; i++) {
        $('#follow-topics-input').tagsinput('add', default_tags[i]);
      }
    }

 


    $('#follow-topics-input').on('itemAdded', function(event) {
      $("#followed-topics").val(event.item.toLowerCase());
      $('.tags-widget .bootstrap-tagsinput .tag').attr('data-id', topicsMap.get(event.item));


      $.ajax({
        type: "POST",
			  url: "/topics/" + event.item.toLowerCase() + "/follow",
			  headers: {
				  Accept: "text/javascript; charset=utf-8",
				 "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			  },

        success: function() {
          id = $(".tag-list-container .tag:contains(" + event.item + ")").attr('data-id');
          topicsMap.set(event.item, id);
        }
      });

    });

    $('#follow-topics-input').on('itemRemoved', function(event) {
      topicsMap.delete(event.item);
      $.ajax({
        type: "DELETE",
			  url: "/topics/" + event.item.toLowerCase() + "/unfollow",
			  headers: {
				  Accept: "text/javascript; charset=utf-8",
				 "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			  }
      });

    });


    $('.tags-widget .bootstrap-tagsinput').addClass('form-group');
    $('.tags-widget .bootstrap-tagsinput input').addClass('form-control');
    $('#follow-topics-input').attr('data-behavior', 'processed') 
    $('.tag-list-container .bootstrap-tagsinput input').focus();

    $('.tags-widget .bootstrap-tagsinput').on('mousedown', function() {
      valid_click = true;
    });

    $('.tag-list-container .bootstrap-tagsinput input').on('focusout', function() {
       if (valid_click) {
         valid_click = false;
         return;
       }

       var html = "<ul class='tag-list'>";
       for (const k of topicsMap.keys()) {
         html += "<li><a href='/topics/" + topicsMap.get(k) + "' data-id='" + topicsMap.get(k) + "' class='arial-ff' style='padding: .4em .5em; line-height: 1; text-transform: lowercase; font-size: 12px;'>" + k + "</a></li>";
       }
       html += "</ul>";
       $(".tags-widget .tag-list-container").html(html);
       $('#edit-followed-topics').show();
    });

    $('.tags-widget .bootstrap-tagsinput .tag').each(function(idx, item) {
      var $item = $(item);
      $item.attr('data-id', topicsMap.get($item.text()));
    });

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
    $("body").on('click', ".version-item .accordion-toggle", function() {
      var $toggle = $(this);
      var $version = $toggle.closest('.version-item');
      var versionId = $version.data('version-id');

      if ($toggle.hasClass("fa-caret-down")) {
        $toggle.removeClass("fa-caret-down");
        $toggle.addClass("fa-caret-up"); 

        if (!$version.data('has-content')) {
          $.ajax({
            type: "GET",
			      url: "/versions/" + versionId,
			      headers: {
			       Accept: "text/javascript; charset=utf-8",
			        "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			      },
            beforeSend: function() {
              $version.append("<div class='version-content-container'><div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div></div>");
            },
            succcess: function() {
            }
          });
        } else {
          $version.find('.version-content-container').slideDown();
        }
      } else {
        $toggle.removeClass("fa-caret-up");
        $toggle.addClass("fa-caret-down");
        $version.find(".version-content-container").slideUp();
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
		  $form = $($(this).closest('form')[0]);
		  var content = '';
      if ($form.attr('id') == "problem-form" || $form.attr('id') == "edit-problem-form") {
        content = $form.find('input[name="problem[content]"]:first').val();
        var data = [{ content: content }];
    
        if ($form.next('.postPreview').length > 0) {
          $form.next('.postPreview').find('.general-preview-content').html(data[0].content);
			  } else {
          $.tmpl($("#generalPreviewTemplate"), data).insertAfter( $form );
				}

        setTimeout(function() {
			    MathJax.Hub.Queue(["Typeset", MathJax.Hub, $form.next('.postPreview').find('.general-preview-content')[0]]);
		    } ,500);

        return 0;

      } else if ($form.attr('id') == "topic-form") {
        content = $form.find('input[name="topic[description]"]:first').val();
      } else if ($form.hasClass("proof-form")) {
        content = $form.find('input[name="proof[content]"]:first').val();
        var proofData = [{ content: content }];

        if ($form.next('.postPreview').length > 0) {
          $form.next('.postPreview').find('.general-preview-content').html(proofData[0].content);
			  } else {
          $.tmpl($("#generalPreviewTemplate"), proofData).insertAfter( $form );
				}

        setTimeout(function() {
			    MathJax.Hub.Queue(["Typeset", MathJax.Hub, $form.next('.proofPreview').find('#proof-preview-content')[0]]);
		    } ,500);

        return 0;

      } else if ($form.hasClass("comment-form")) {
			  content = $($form).find('textarea[name="comment[content]"]:first').val();
        var commentData;
				if ($form.hasClass('comment-reply-form')) {
          commentData = [{ content: content, paddingLeft: '60px' }];

				} else { 
          commentData = [{ content: content, paddingLeft: 0 }];
				}

        //var $comments = $($form).next('.commentsStream');
        if ($form.next('.postPreview').length > 0) {
          $form.next('.postPreview').find('.comment-content').html(commentData[0].content);
			  } else {
          $.tmpl($("#commentPreviewTemplate"), commentData).insertAfter( $form );
				}
/*
          if ($comments.find('.postPreview').length > 0) {
            $comments.find('.postPreview .comment-content').html(commentData[0].content);
          } else {
            $.tmpl($("#commentPreviewTemplate"), commentData).prependTo( $comments );
          }
        
          setTimeout(function() {
			      MathJax.Hub.Queue(["Typeset", MathJax.Hub, $comments.find('.commentPreview .comment-content')[0]]);
		      } ,500);
*/

        setTimeout(function() {
			    MathJax.Hub.Queue(["Typeset", MathJax.Hub, $form.next('.commentPreview').find('.comment-content')[0]]);
		    } ,500);

        return 0;
      }
 
		  math = $('#preview-modal .preview_content > p');
		  math.html(content);	
		  setTimeout(function() {
			  MathJax.Hub.Queue(["Typeset", MathJax.Hub, math[0]]);
		  } ,500);
	  });

    $('body').on('click', '.postPreview .close', function() {
      $(this).closest('.postPreview').remove();
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

/* --------------------------------------------------------
  Sticky Nav
--------------------------------------------------------- */

  function initStickyNav() {
    var $stickyNav = $('#sticky-nav');
    var sticky = $stickyNav.offset().top;

    $(window).scroll(function() {
      if ($(this).scrollTop() >= sticky) {
        $stickyNav.addClass("sticky")
      } else {
        $stickyNav.removeClass("sticky");
      }
    });
  }

  function initCommentsLinks() {
    $('.commentsDropdownLink').on('click', function() {
      if ($(this).find('.fa-angle-down').length == 1) {
        $(this).find('.fa-angle-down').removeClass('fa-angle-down').addClass('fa-angle-up');
      } else {
        $(this).find('.fa-angle-up').removeClass('fa-angle-up').addClass('fa-angle-down');
      }

      $(this).closest('.commentsButtonContainer').next('.commentSection').toggleClass('hidden');
    });

    $('.addCommentIcon').on('click', function() {
      $commentSection = $(this).closest('.postActions').next('.commentsButtonContainer').find('.commentsDropdownLink .fa-angle-down').removeClass('fa-angle-down').addClass('fa-angle-up');
      $commentSection = $(this).closest('.postActions').next('.commentsButtonContainer').next('.commentSection');
      $commentSection.removeClass('hidden');
      $commentSection.find('textarea').focus();
    });

    $(".bp-comment-reply .comment-edit").on('click', function() {
      let $comment = $(this).closest('.bp-comment-reply');
			if ($comment.next('form.comment-edit-form').length == 0) {
			  let commentId = $comment.data('comment-id');
				let commentContent = $comment.find('.comment-content').text().trim();
        let commentData = [{ commentId: commentId, commentContent: commentContent }];

			  $comment.find('.comment-content').hide();
				$comment.find('.comment-actions').hide();
				$comment.find('.vote-container').hide();

				$.tmpl($("#commentEditFormTemplate"), commentData).appendTo( $comment.find('.comment-content-container'));
   
        $comment.find('form').find('textarea').focus();
        txt = $('textarea');
        txt.addClass('txtstuff');
			}
    });

    $('.bp-comment-reply').on('click', "span[data-action='close-edit-form']", function() {
		  let $comment = $(this).closest('.bp-comment-reply');
      $comment.find('.commentPreview').remove();
      $(this).closest('form').remove();

      $comment.find('.comment-content').show();
			$comment.find('.comment-actions').show();
			$comment.find('.vote-container').show();
    });
  }

/* --------------------------------------------------------

  Textarea
  -------------------------------------------------------- */

  function initTextarea() {
    var txt = $('textarea'),
              hiddenDiv = $(document.createElement('div')),
              content = null;

    txt.addClass('txtstuff');
    hiddenDiv.addClass('hiddendiv common');

    $('body').append(hiddenDiv);

    $('.commentSection, .changes-form-group').on('keyup', 'textarea', function () {

      content = $(this).val();

      content = content.replace(/\n/g, '<br>');
      hiddenDiv.html(content + '<br class="lbr">');

      $(this).css('height', hiddenDiv.height());

    });

    $('body').on('click', '.replyCommentLink', function() {
      var $comment = $(this).closest('.bp-comment-reply');
      if ($comment.next('form.comment-reply-form').length == 0) {
        var commentId = $(this).data('comment-id');
        var paddingLeft = $(this).data('padding-left');
        var commentData = [{ id: commentId, paddingLeft: paddingLeft }];

        $.tmpl($("#commentReplyFormTemplate"), commentData).insertAfter( $comment);
    
        $comment.next('form').find('textarea').focus();
        txt = $('textarea');
        txt.addClass('txtstuff');
      }

/*
      if ($comments.find('.postPreview').length > 0) {
          $comments.find('.postPreview .comment-content').html(commentData[0].content);
        } else {

          $.tmpl($("#commentPreviewTemplate"), commentData).prependTo( $comments );
        }
*/
    });

    $('body').on('click', "span[data-action='close-reply-form']", function() {
      $(this).closest('form').next('.commentPreview').remove();
      $(this).closest('form').remove();
    });

    $('body').on('click', "input[data-action='submit-comment']", function() {
      $(this).closest('form').attr("data-status", "submitted");
    });

  }


/* ------------------------------------------------------------------
    Fancy Tabs
    ----------------------------------------------------------------- */

  function initFancyTabs() {

    function loadSection($input) {
      var $target = $($input.data('target'));

      if ($target.attr('data-loaded') == "false") {
        var user_id = $input.closest('.fancy-tabs').data('user');

        $.ajax({
          type: "GET",
			    url: "/users/" + user_id + "/" + $target.data('content'),
			    headers: {
			     Accept: "text/javascript; charset=utf-8",
			      "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          beforeSend: function() {
            $target.html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          }
        });

      }
    }

    $('.fancy-tabs').on('click', 'input', function() {
      loadSection($(this));
    });
  }

/* ------------------------------------------------------------------
    Fullscreen
  -----------------------------------------------------------------*/

  function initFullscreen() {
    $('#proof-form, #edit-proof-form, #problem-form, #edit-problem-form').on('click', 'trix-toolbar .trix-button--icon-fullscreen', function() {
      if ($('.trix-form-container').hasClass('trix-form-container-fullscreen')) {
        $('.trix-form-container').removeClass('trix-form-container-fullscreen');
        $('body').removeClass('overflow-y-hidden');
      } else {
        $('.trix-form-container').addClass('trix-form-container-fullscreen');
        $('body').addClass('overflow-y-hidden');
        $('trix-editor').focus();
      }
    });
  }

/* ---------------------------------------------------------------------
  Problem Form
 -----------------------------------------------------------------------*/

  function initNewProblemForm() {

    // CONSTANTS
		var titleContent = `
			  <h2>Write a title that summarizes the problem</h2>	
				<p>The title is the first thing that users will see. It should help them quickly understand what the problem is about.</p>
        <div class='light-grey-card'>
          <h4 class='bodyFont'>
            Here are some tips for making a good title:
          </h4>
 
          <ul>
            <li>
              If the theorem has a name make that your title. Sum up your entire 
              problem in one sentence. Include details that will help people identify 
              and solve your problem. Include any constraints or variants to your 
              problem that make it different from similar problems already on the site. 
            </li>
            <li>
              Spelling, grammar and punctuation are important! Make sure you proof-read 
              it or have someone proof-read it for you if your english is not good.
            </li>
            <li>
              Write the title last if you are having trouble summarizing the problem. 
              Sometimes writing the problem first can make it easier for you to 
              describe the problem.
            </li>
          </ul>
        </div>
    `;

		var tagsContent = `
		  <h2> What is your problem about? </h2>
      <p>
			  Topics are a way of connecting users with problems they are 
			  interested in by sorting problems into specific, well-defined 
				categories. Choose at least one and up to five tags.
			</p>
		`;
		
    var $li = $(".multi-step-bar li[data-open='true']");

		function updateForm($li) {
		  $('.form-group').removeClass('show');
      if ($li.text() == "Title") {
        $('.problem-form-wrapper .step-meta').html(titleContent);
				$('.title-form-group').addClass('show');
			} else if ($li.text() == "Tags") {
        $('.problem-form-wrapper .step-meta').html(tagsContent);
        $('.tags-form-group').addClass('show');
			}
		}

    if ($li.text() == "Title") {
      $(".form-nav span[data-nav='previous']").addClass('hide');
    }

    // Click on next
    $('.form-nav').on('click', '.btn-next', function() {
      if ($(this).attr('disabled')) {
        
      } else {
			  $li.attr('data-open', false);
				$li = $li.next('li');
        $li.addClass('active').attr('data-open', true);
				$(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');

        //$(".form-nav .btn-next").attr('disabled', true);

        updateForm($li);
			}
    });

    // Click on previous
    $('.form-nav').on('click', "span[data-nav='previous']", function() {
      $li.attr('data-open', false).removeClass('active');
			$li = $li.prev('li');
      $li.attr('data-open', true);
      if ($li.text() == "Title") {
        $(".form-nav span[data-nav='previous']").removeClass('show').addClass('hide');
			}

			updateForm($li);
		});

    // Click on multi-step-bar link
		$(".multi-step-bar").on('click', "li[data-open='false']", function() {
      $li.attr('data-open', false);
      $li = $(this);
			$li.nextAll('li').removeClass('active');
			$li.prevAll('li').addClass('active');
			$li.addClass('active').attr('data-open', true);

      if ($li.text() == "Title") {
        $(".form-nav span[data-nav='previous']").removeClass('show').addClass('hide');
			}

			updateForm($li);
		});

    // On enter
    $('#problem-form').on('keyup keypress', function(e) {
      var keyCode = e.keyCode || e.which;
      if (keyCode === 13) { 
        e.preventDefault();

        if ($li.text() != "Review") {
          if (!$('.form-nav .btn-next').attr('disabled')) {
			      $li.attr('data-open', false);
				    $li = $li.next('li');
            $li.addClass('active').attr('data-open', true);
				    $(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');

            updateForm($li);
		    	}
        }
        return false;
      }
    });
  }
