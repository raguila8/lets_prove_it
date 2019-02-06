$(document).on('turbolinks:load', function() {
  if ($('#problem-form').length > 0) {
    initNewProblemValidations();
	}

	/* ------------------------------------------------------------------
	  New Problem Validations
		------------------------------------------------------------------*/

	function initNewProblemValidations() {
	  // error icon node
	  var errorIcon = document.createElement("span");
		errorIcon.className = 'fa fa-exclamation-circle input-error';
	
	  // Error msg node
		var errorMsg = document.createElement("span");
		errorMsg.className = "input-error-msg";
		var errorText = "Invalid input";
		errorMsg.textContent = errorText;
    
	  var form  = document.getElementById('problem-form');
		var title = document.querySelector("#problem-form input[name='problem[title]']");

		title.addEventListener('input', function(event) {
		  if (title.validity.valid && title.value.trim().length >= 10) {
        document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
        title.classList.remove('has-error');
			} else {
        document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
			}
		});

		title.addEventListener('blur', function(event) {
      if (title.validity.valid && title.value.trim().length >= 10) {
        document.querySelector('.form-nav .btn-next').removeAttribute('disabled');
			} else if (title.value.length > 0) {
        document.querySelector('.form-nav .btn-next').setAttribute('disabled', true);
				title.classList.add('has-error');
				document.querySelector('.title-input-container').appendChild(errorIcon);

				if (title.validity.valid || title.validity.tooShort) {
          errorText = "Title must be at least 10 characters";
				} else if (title.validity.tooLong) {
          errorText = "Title can't be longer that 255 characters";
				}

        errorMsg.textContent = errorText;
        document.querySelector('.title-form-group').appendChild(errorMsg);
			}
    });

		title.addEventListener('focus', function(event) {
      title.classList.remove('has-error');
			if (document.querySelector('.title-input-container .input-error')) {
			  document.querySelector('.title-input-container .input-error').remove();
        document.querySelector('.title-form-group .input-error-msg').remove();
			}
		});
  }
});
