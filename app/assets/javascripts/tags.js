$(document).on('turbolinks:load', function() {
  if ($('#tags-input-container').length > 0) {
    new Taggle('tags-input-container', {
        duplicateTagClass: 'bounce' 
    });
	}
});
