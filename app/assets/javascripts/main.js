$(document).on('turbolinks:load', function() {
  $(window).unbind('scroll');

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
  if (window.MathJax && !$("body[data-mathjax]").length && !$("#edit-problem-page").length && !$("#edit-topic-page").length) {
    console.log("i am god");
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

  // cancel new-comment
  if ($("#problem-page").length > 0) {
    $("body").on('click', "#cancel-new-comment", function(e) {
      $('#comment-form').remove();
      $('.comment-replay-btn').show();
    });
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
        console.log(topicsMap.get($(this).text()));
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
          if ($("#help_center").length == 0) {
            $('.tab-list-content').html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          }
          if ($(this).closest('.priv-tabs-list').length > 0) {
            $(".priv-content .tab-pane").removeClass("in active");
            $(".priv-content " + $(this).find("a").attr("href")).addClass("in active");
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
    $("body").on('click', ".panel .version-toggle", function() {
      var $toggle = $(this).find('.glyphicon');
      if ($toggle.hasClass("glyphicon-chevron-down")) {
        $toggle.removeClass("glyphicon-chevron-down");
        $toggle.addClass("glyphicon-chevron-up");
      } else {
        $toggle.removeClass("glyphicon-chevron-up");
        $toggle.addClass("glyphicon-chevron-down");
      }      
    });

    var $versionContent = $(".version-content")
    $('body').on("shown.bs.collapse", '.version-content', function(e) {
      var versionId = $(this).data("version");
      var $content = $(this).find(".panel-body");
      if ($content.data("has-content") == false) {
        $.ajax({
          type: "GET",
			    url: "/versions/" + versionId,
			    headers: {
			     Accept: "text/javascript; charset=utf-8",
			      "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          beforeSend: function() {
            $content.html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          },
          succcess: function() {
          }
        });
      }
    });


    $("body").on('click', ".faq-panel .panel-title", function() {
      var $toggle = $(this).find('.glyphicon');
      if ($toggle.hasClass("glyphicon-chevron-down")) {
        $toggle.removeClass("glyphicon-chevron-down");
        $toggle.addClass("glyphicon-chevron-up");
      } else {
        $toggle.removeClass("glyphicon-chevron-up");
        $toggle.addClass("glyphicon-chevron-down");
      }

    });

    $("#collapse-general-3").on("shown.bs.collapse", function(e) {
      var $content = $(this).find(".panel-body");
      if ($content.data("has-content") == false) {
        $.ajax({
          type: "GET",
			    url: "/mathjax_cheatsheet",
			    headers: {
			     Accept: "text/javascript; charset=utf-8",
			      "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			    },
          beforeSend: function() {
            $content.html("<div class='spinner'> <div class='rect1'></div> <div class='rect2'></div> <div class='rect3'></div> <div class='rect4'></div> <div class='rect5'></div> </div>");
          },
          succcess: function() {
          }
        });

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
        console.log(content);
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

