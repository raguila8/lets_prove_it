// error icon node
	const errorIcon = document.createElement("span");
	errorIcon.className = 'fa fa-exclamation-circle input-error';

  // Error msg node
  const errorMsg = document.createElement("span");
	errorMsg.className = "input-error-msg";
	let errorText = "Invalid input";
	errorMsg.textContent = errorText;

  // refractor later
  function addInputError(input) {
    if ($(input).data('field') == "content") {
      console.log($(input).closest('.input-container').next('.textAreaActions')[0]);
      $(input).addClass('has-error');
      $(input).closest('.input-container').next('.textAreaActions').addClass('has-error');
    } else {
      if ($(input).hasClass('taggle_input')) {
        $('#tags-input-container').addClass('has-error');
      } else {
        $(input).addClass('has-error');
      }
    }

    if ($(input).closest('.input-container').find('.input-error').length == 0) {
      console.log('running!');
      $(input).closest('.input-container').append(errorIcon.cloneNode(false));
    }

    if ($(input).closest('.problem-content-input-container').length) {
      let toolbarHeight = $('trix-toolbar').height();
      $('.problem-content-input-container .input-error').attr('style', 'margin-top: calc(23.7px - 8.575px) !important');
    }

  }

  function addInputErrorMsg(input, errorText) {
    if ($(input).closest('.form-group').find('.input-error-msg').length) {
      $(input).closest('.form-group').find('.input-error-msg').html(errorText);
    } else {
      let textNode = errorMsg.cloneNode(true);
      textNode.innerHTML = errorText;
      $(input).closest('.form-group').append(textNode);
    }
  }

  function removeInputValidations(input) {
    $(input).closest('.form-group').find('.has-error').removeClass('has-error');
	  if ($(input).next('.input-error').length > 0) {
      $(input).next('.input-error').remove();
      $(input).closest('.form-group').find('.input-error-msg').remove();
	  }
  }



$(document).on('turbolinks:load', function() {
  if ($('form').length > 0) {
    //initFormValidations();
  }

  if ($('#problem-form').length > 0) {
    initNewProblemForm();
	} else if ($('#proof-form').length > 0) {
    initGeneralFormValidations();
  }

 /* ---------------------------------------------------
  General Form validations
  -------------------------------------------------- */

  function initGeneralFormValidations() {
    $('body').on('focus', 'form .form-input-validate', function(event) {
      removeInputValidations(this);
    });
  }

  
	/* ---------------------------------------------------
	 New Problem Form
	 -----------------------------------------------------*/

  function initNewProblemForm() {
    // CONSTANTS

		titleContent = `
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

		tagsContent = `
		  <h2> What is your problem about? </h2>
      <p>
			  Topics are a way of connecting users with problems they are 
			  interested in by sorting problems into specific, well-defined 
				categories. Choose at least one and up to five tags.
			</p>
		`;

    problemContent = `
      <h2>What do you want to prove?</h2>
      <p>
        Make sure your problem is not a duplicate and is different from 
        the rest. <a href='#' class='bodyLink'>Search</a>, research and keep track of what you find. 
        You can link to similar problems so that others can better 
        understand your question and make sure it is not repeated.
      </p>
      <div class='light-grey-card'>
        <h4 class='bodyFont'>
          Make sure the problem is a theorem or that it 
          asks to prove a mathematical statement
        </h4>
 
        <ul>
          <p>
            If the theorem has a name make that your title. Sum up your entire 
            problem in one sentence. Include details that will help people identify 
            and solve your problem. Include any constraints or variants to your 
            problem that make it different from similar problems already on the site. 
          <p>
        </ul>
      </div>
      `;

      reviewContent = `
        <h2>Review your problem</h2>
        <p>
          Read the problem from start to finish and make sure everything is 
          clear and makes since. Add any details you missed and read through 
          it again. Before posting, read the title again and make sure it 
          still describes the problem.
        </p>

        <div class='light-grey-card'>
          <h4 class='bodyFont'>
            Respond to feedback after posting your problem
          </h4>

          <p>
            After posting your problem, frequently check on it to see if anyone 
            comments on it. If you missed a piece of information or made an 
            error in your problem, be ready to edit your problem and fix it. 
            If someone posts a proof, be ready to provide feedback.
          </p>
      </div>
      `;


    $li = $(".multi-step-bar li[data-open='true']");

    initNewProblemFormValidations();
	  initNewProblemFormGeneral();
    initProblemTags();
    initNewProblemSubmission();
	}


  /* -----------------------------------------------------------
	  Validations
		-------------------------------------------------------------*/

  function initFormValidations() { 
	  const $form  = $('.validate-form');

    if ($('#problem-form').length > 0) {
      $('#problem-form').on('input', '.form-input-validate', function(event) {
        let $input = $(this);
        let minLength = 10;
        if ($(this).data('field') == "content") {
          $input = $(this).closest('.form-group').find('#problem_content');
          minLength = 20;
        }
        if ($input[0].validity.valid) {
          if ($input[0].value.trim().replace(/\s+/g, " ").length >= minLength) {
            document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
          } else {
            document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
          }
        } else {
          document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
        }
      });
    }

    $form.on('input', '.form-input-validate', function(event) {
      if ($(this)[0].validity.valid) {
        if ($(this).closest('form').attr('id') == 'problem-form') {
          if ($(this).data('field') == "title") {
            if ($(this)[0].value.trim().replace(/\s+/g, " ").length >= 10) {
              document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
            } else {
              document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
            }
          }
        }
      } else {
        if ($(this).closest('form').attr('id') == 'problem-form') {
          document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
        }
      }
    });

    $form.on('blur', '.form-input-validate', function() {
      if ($(this)[0].validity.valid) {
        if ($(this).closest('form').attr('id') == 'problem-form') {
          if ($(this).data('field') == "title") {
            if ($(this).val().length > 0 && $(this)[0].value.trim().replace(/\s+/g, " ").length < 10) {
              errorText = "Title must be at least 10 characters";
              addInputError(this);
              addInputErrorMsg(this, errorText);
            }
          }
        }

      } else {
        if ($(this).val().length > 0) {
          addInputError(this);
          if ($(this)[0].validity.tooShort) {
            errorText = "Title must be at least 10 characters";
          } else if ($(this)[0].validity.tooLong) {
            errorText = "Title can't be longer that 255 characters";
          }
          addInputError(this);
          addInputErrorMsg(this, errorText);
        }
      } 
    });

    $form.on('focus', '.form-input-validate', function(event) {
      if ($(this).hasClass('taggle_input')) {
        if ($('#tags-input-container').hasClass('has-error')) {
          $('#tags-input-container').removeClass('has-error');
          $('#tags-input-container').find('.input-error').remove();
          $(this).closest('.form-group').find('.input-error-msg').remove();
        }
      } else {
        $(this).removeClass('has-error');
			  if ($(this).next('.input-error').length > 0) {
          $(this).next('.input-error').remove();
          $(this).closest('.form-group').find('.input-error-msg').remove();
			  }
      }
		});

    $form.on('keydown', '.form-input-validate', function(e) {
      var keyCode = e.keyCode || e.which;
      if (keyCode === 13) {
        if ($(this).closest('form').attr('id') == 'problem-form') {
          if ($(this).data('field') == "title") {
            e.preventDefault();
            if (!$('.form-nav .btn-next').attr('disabled')) {
			        $li.attr('data-open', false);
				      $li = $li.next('li');
              $li.addClass('active').attr('data-open', true);
				      $(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');

              updateForm($li);
		        } else {
              $(this).blur();
              addInputError(this);
              if ($(this)[0].validity.tooShort) {
                errorText = "Title must be at least 10 characters";
              } else if ($(this)[0].validity.tooLong) {
                errorText = "Title can't be longer that 255 characters";
              } else if ($(this)[0].validity.valueMissing) {
                errorText = "Title is missing";
              }
              addInputError(this);
              addInputErrorMsg(this, errorText);
            }
          }
        }             
        
      }
    });
  }

  function initNewProblemFormValidations() {
    const $form  = $('#problem-form');

    // When user is typing, check if input is valid. If it is not, disbale 
    // .next-btn, enable otherwise
    $('#problem-form').on('input', '.form-input-validate', function(event) {
      let $input = $(this);
      let minLength = 10;

      if ($input[0].validity.valid) {
        if ($input.attr("minlength")) {
          if ($input[0].value.trim().replace(/\s+/g, " ").length >= minLength) {
            document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
          } else {
            document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
          }
        }
      } else {
        document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
      }
    });

    // for trix
    document.addEventListener("trix-change", function(event) {
      if ($('#problem-form').length > 0) {
      $input = $('#problem_content');

      if ($input[0].validity.valid) {
        if ($input.attr("minlength")) {
          if ($input[0].value.trim().replace(/\s+/g, " ").length >= 30) {
            document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
          } else {
            document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
          }
        }
      } else {
        document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
      }
      }
    });

    // When input is blurred and its value is not empty, validate field.
    $form.on('blur', '.form-input-validate', function() {
      console.log('title');
      let $input = $(this);
      let minLength = 10;
      let maxLength = 255;

      if ($(this).data('field') == "content") {
        $input = $(this).closest('.form-group').find('#problem_content');
        minLength = 30;
        maxLength = 5000;

        if ($input.val().length > 0) { 
          let isValid = true;
          if ($input[0].value.trim().replace(/\s+/g, " ").length < minLength) {
            errorText = $li.text() + " must be at least " + minLength + " characters";
            isValid = false;
          } else if ($input[0].value.trim().length > maxLength) {
            errorText = $li.text() + " is too long. " + $li.text() + " can be at most " + maxLength + " characters";
            isValid = false;
          }
          if (!isValid) {
            addInputError($(this)[0]);
            addInputErrorMsg($input[0], errorText);
          }
        }
        return 0;
      }

      if ($input.val().length > 0) {
        if ($input[0].validity.valid) {
          console.log($input[0].validity);
          if ($input.attr("minlength") && $input.val().length > 0 && $input[0].value.trim().replace(/\s+/g, " ").length < minLength) {
              errorText = $li.text() + " must be at least " + minLength + " characters";
              addInputError($(this)[0]);
              addInputErrorMsg($input[0], errorText);
          }
        } else {
          if ($input[0].validity.tooShort) {
            errorText = $li.text() + " must be at least " + minLength + " characters";
          } else if ($(this)[0].validity.tooLong) {
            errorText = $li.text() + " must be at least " + minLength + " characters";
          }

          addInputError($(this)[0]);
          addInputErrorMsg($input[0], errorText);
        }
      }
    });



    $form.on('focus', '.form-input-validate', function(event) {
      if ($(this).hasClass('taggle_input')) {
        if ($('#tags-input-container').hasClass('has-error')) {
          $('#tags-input-container').removeClass('has-error');
          $('#tags-input-container').find('.input-error').remove();
          $(this).closest('.form-group').find('.input-error-msg').remove();
        }
      } else {
        removeInputValidations(this);
      }
		});

    $form.on('keydown', '.form-input-validate', function(e) {
      console.log('title');
      var keyCode = e.keyCode || e.which;
      if (keyCode === 13) {
        if ($(this).data('field') == "title") {
          e.preventDefault();
          if (!$('.form-nav .btn-next').attr('disabled')) {
			      $li.attr('data-open', false);
				    $li = $li.next('li');
            $li.addClass('active').attr('data-open', true);
				    $(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');

            updateForm($li);
		      } else {
            $(this).blur();
            addInputError(this);
            if ($(this)[0].validity.tooShort) {
              errorText = "Title must be at least 10 characters";
            } else if ($(this)[0].validity.tooLong) {
              errorText = "Title can't be longer that 255 characters";
            } else if ($(this)[0].validity.valueMissing) {
              errorText = "Title is missing";
            }
            addInputError(this);
            addInputErrorMsg(this, errorText);
          }
        }            
     
      }
    });
  }

  /* -----------------------------------------------------------------
    Form submission
    ------------------------------------------------------------------*/
  function initNewProblemSubmission() {
    $('.problem-form-container .form-nav').on('click', '.btn-submit', function() {
      const $inputs = $('#problem-form .form-input-validate');
      let isValid = true;
      $inputs.each(function(index) {
        let $input = $(this);
        let minLength = 10;
        let maxLength = 255;
        let errorText = "";
        let field = "Title";

        if ($(this).data('field') == "topics") {
          if ($('#tags-input-container .taggle_list .taggle').length < 1) {
            errorText = "Problem must have at least 1 tag";
            isValid = false;
          } else if ($('#tags-input-container .taggle_list .taggle').length > 5) {
            errorText = "Problem has too many tags. It can have at most 5 tags";
            isValid = false;
          }
        } else {
          if ($(this).data('field') == "content") {
            $input = $(this).closest('.form-group').find('#problem_content');
            minLength = 30;
            maxLength = 5000;
            field = "Problem"
          }

          if ($input.attr("minlength") && $input.val().trim().replace(/\s+/g, " ").length < minLength) {
            errorText = field + " must be at least " + minLength + " characters";
            isValid = false;
          } else if ($input.val().trim().length > maxLength) {
            errorText = field + " is too long. " + field + " can be at most " + maxLength + " characters";
            isValid = false;
          }
        }

        if (!isValid) {
          addInputError($(this)[0]);
          addInputErrorMsg($input[0], errorText);
        }
      });

      if (isValid) {
			  var form = document.getElementById('problem-form');
				Rails.fire(form, 'submit');
      }
    });
  }



  /* -----------------------------------------------------------------
	  General
		---------------------------------------------------------------------*/

  function initNewProblemFormGeneral() {

    		
    //var $li = $(".multi-step-bar li[data-open='true']");
	
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

        updateForm($li);
        updateNextButton();
			}
    });

    // Click on 'ready to submit button' 
    $('#problem-form .textAreaActions').on('click', '.btn-next', function() {
      const $input = $(this).closest('.form-group').find('#problem_content');
      const $trixEditor = $(this).closest('.form-group').find('trix-editor');

      const minLength = 30;
      const maxLength = 5000;

      
      let isValid = true;
      if ($input[0].value.trim().replace(/\s+/g, " ").length < minLength) {
        errorText = $li.text() + " must be at least " + minLength + " characters";
        isValid = false;
      } else if ($input[0].value.trim().length > maxLength) {
        errorText = $li.text() + " is too long. " + $li.text() + " can be at most " + maxLength + " characters";
        isValid = false;
      }

      if (!isValid) {
        addInputError($trixEditor[0]);
        addInputErrorMsg($input[0], errorText);
      } else {
        $li.attr('data-open', false);
				$li = $li.next('li');
        $li.addClass('active').attr('data-open', true);
				$(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');

        updateForm($li);
        updateNextButton();
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
      updateNextButton();
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
			} else {
        $(".form-nav span[data-nav='previous']").removeClass('hide').addClass('show');
      }

      updateForm($li);
      updateNextButton();
		});
  }

	function initProblemTags() {
    if ($('#tags-input-container').length > 0) {
      const myTaggle = new Taggle('tags-input-container', {
        duplicateTagClass: 'bounce',
        hiddenInputName: "tags[]",

        inputFormatter: function(inputElement) {
          $(inputElement).addClass('form-input-validate');
          $(inputElement).attr('data-field', 'topics');
        },

				onBeforeTagAdd: function(event, tag) {
          let $input = $('#tags-input-container .taggle_input');
          var errorText;

          if (!/^[A-Za-z\d\s]*$/.test(tag)) {
            errorText = "Tags only support letters, spaces and numbers";
          } else if (tag.length > 25) {
            errorText = "Tags can be at most 25 characters";
          } else if (tag.length < 3) {
            errorText = "Tags needs to be at least 3 characters";
          } else {
            return true;
          }

          $input.blur();
          addInputError($input[0]);
          addInputErrorMsg($input[0], errorText);
					return false;
				},

				onTagAdd: function(event, tag) {
          if ($('#tags-input-container .taggle_list .taggle').length == 5) {
            $('#tags-input-container .taggle_list .taggle_input').attr('disabled', true);
						$('#tags-input-container').css("cursor", "default !important");
					} else if ($('#tags-input-container .taggle_list .taggle').length == 1) {
            $('.form-nav .btn-next').attr('disabled', false);
					}
				},

				onTagRemove: function(event, tag) {
          if ($('#tags-input-container .taggle_list .taggle').length == 4) {
            $('#tags-input-container .taggle_list .taggle_input').attr('disabled', false);
						$('#tags-input-container').css("cursor", "text");
					} else if ($('#tags-input-container .taggle_list .taggle').length == 0) {
            $('.form-nav .btn-next').attr('disabled', true);
          }
				}
      });

      
      $('#tags-input-container .taggle_input').autocomplete({ 
        source: function( request, response ) {
          $.ajax({
            type: "GET",
            url: "/topics/search",
            data: {
              query: request.term
            },
            success: function(data) {
              response(data.suggestions);
            }
          });
        },
        appendTo: myTaggle.getContainer(),
        select: function(event, data) {
          event.preventDefault();
          //Add the tag if user clicks
          if (event.which === 1) {
            myTaggle.add(data.item.value);
          }
        },
        open: function() {
          let containerOffset = $('#tags-input-container').offset();
          let containerHeight = $('#tags-input-container').height();

          let left = containerOffset.left, top = containerOffset.top;
          $(".ui-menu").css({ left: 0 + "px",
                                top: containerHeight + 5 + "px",
                                width: "100%" });

        }
      })
      .data("ui-autocomplete")._renderItem = function( ul, item ) {
          return $("<li>")
					  .append("<span class='font-weight-600 g-ml-5 topic-label'>" + item.label.toLowerCase() + " <span style='color: rgba(0,0,0,0.64); font-weight: 500;'>(" + item.cached_problems_count + ")</span>")
					  .appendTo ( ul );
      };
    }
	}

  function updateForm($li) {
		$('.form-group').removeClass('show');
    if ($li.text() == "Title") {
      $('.problem-form-container').removeClass('trix-form-container');
      $('.problem-form-wrapper .step-meta').html(titleContent);
		  $('.title-form-group').addClass('show');
      $('.problem-form-wrapper').attr('id', 'title-step');
		} else if ($li.text() == "Tags") {
      $('.problem-form-container').removeClass('trix-form-container');
      $('.problem-form-wrapper .step-meta').html(tagsContent);
      $('.tags-form-group').addClass('show');
      $('.problem-form-wrapper').attr('id', 'tags-step');
  	} else if ($li.text() == "Problem") {
      $('.problem-form-container').addClass('trix-form-container');
      $('.problem-form-wrapper .step-meta').html(problemContent);
      $('.problem-content-form-group').addClass('show');
      $('.problem-form-wrapper').attr('id', 'problem-step');
    } else if ($li.text() == "Review") {
      $('.problem-form-container').addClass('trix-form-container');
      $('.problem-form-wrapper .step-meta').html(reviewContent);
      $('.title-form-group').addClass('show');
      $('.tags-form-group').addClass('show');
      $('.problem-content-form-group').addClass('show');
      $('.problem-form-wrapper').attr('id', 'review-step');
    }
	}

  function getProblemInputs() {
    return $('#problem-form .form-input-validate');
  }


  function readyForNextStep() {
    let $input = $('#problem-form .form-input-validate:visible');
    let minLength = 10;
    let maxLength = 255;
    let isValid = true;

    if ($input.data('field') == "topics") {
      if ($('#tags-input-container .taggle_list .taggle').length < 1) {
        isValid = false;
      } else if ($('#tags-input-container .taggle_list .taggle').length > 5) {
        isValid = false;
      }
    } else {
      if ($input.data('field') == "content") {
        $input = $input.closest('.form-group').find('#problem_content');
        minLength = 30;
        maxLength = 5000;
      }

      if ($input.attr("minlength") && $input.val().trim().replace(/\s+/g, " ").length < minLength) {
        isValid = false;
      } else if ($input.val().trim().length > maxLength) {
        isValid = false;
      }
    }
    return isValid;
  }

  function updateNextButton() {
    if ($('.form-nav .btn-next:visible').length > 0 && readyForNextStep()) {
      document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
    } else {
      document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
    }
  }
/*
  function submitProblem() {
    $form = $('#problem-form');
    let title = $form.find('.title-form-group .form-input-validate').val();
    let tags [];
    $form.find('tags-form-group .taggle_list .taggle_text').each(function(index) {
      tags.push($(this).
    });

    $.ajax({
      type: "POST",
			url: "/problems",
			headers: {
				Accept: "text/javascript; charset=utf-8",
		  	  "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRF-Token': Rails.csrfToken()
			}, data: {
        problem: { 'title' => 
      }
    });

  }
*/
});
