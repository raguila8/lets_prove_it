$(document).on('turbolinks:load', function() {
  initNavbar();
  initScroller();
  initAnimation();
  initSelector();


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
		$('.portfolio-filters a').click(function (e) {
			  e.preventDefault();

			  $('li').removeClass('active');
			  $(this).parent().addClass('active');
    
        $('.page-title .subheading').text($(this).text());
		});
  }

/* --------------------------------------------------
  Topics Tags
 ----------------------------------------------------*/
  
  function initTopicsTags () {
    var numOfTags = 0;
    var tags = "";
    $('#topics-input').change(function(){
      $(this).find('input').val('');
    });

    var data = ['Amsterdam', 'Sydney', 'Los Angeles', 'new york'];

  var bloodHoundObj = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    // url points to a json file that contains an array of country names, see
    // https://github.com/twitter/typeahead.js/blob/gh-pages/data/countries.json
    local: data
  });
  bloodHoundObj.initialize();

    
    $('#topics-input').tagsinput({
      typeahead: {
        afterSelect: function(val) { this.$element.val(""); },
        source: data,
      },
      freeInput: false
    });

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
      if (numOfTags > 1) {
        tags = tags.replace("," + event.item.toUpperCase(), "");
      } else {
        tags = tags.replace(event.item.toUpperCase(), "");
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

