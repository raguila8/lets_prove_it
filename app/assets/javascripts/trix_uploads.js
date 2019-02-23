Trix.config.attachments.preview.caption = {
  name: false,
  size: false
};

function uploadAttachment(attachment) {
  var file = attachment.file;
  var form = new FormData;
  form.append("Content-Type", file.type);
  form.append("image[image_data]", file)

  var xhr = new XMLHttpRequest;
  xhr.open("POST", "/images.json", true);
  xhr.setRequestHeader("X-CSRF-Token", Rails.csrfToken());

  xhr.upload.onprogress = function(event) {
    var progress = event.loaded / event.total * 100;
    attachment.setUploadProgress(progress);
  }

  xhr.onload = function() {
    if (xhr.status === 201) {
      var data = JSON.parse(xhr.responseText);
      if ($('#new-images').length) {
        images = $('#new-images').val();
        if ($('#new-images').val().length >= 1) {
          $('#new-images').val(images += "," + data.id);
        } else {
          $('#new-images').val(data.id);
        }
      }

      return attachment.setAttributes({
        url: data.image_url,
        href: data.image_url,
        id: data.id
      })
    }
  }
  return xhr.send(form);
}

function deleteFile(attachment) {
  $.ajax({
    type: 'DELETE',
    url: '/images/' + attachment.attachment.attributes.values.id,
    headers: {
      'X-CSRF-Token': Rails.csrfToken()
    },
    cache: false,
    contentType: false,
    processData: false
  });
}

document.addEventListener("trix-attachment-add", function(event) {
  var attachment = event.attachment;

  if (attachment.file) {
    uploadAttachment(attachment);
  }
});

document.addEventListener("trix-attachment-remove", function(event) {
  var attachment = event.attachment;
  
  deleteFile(attachment);
});

document.addEventListener("trix-initialize", function(event) {
  if ($('.proof-editor, #problem-form, #edit-problem-form').length > 0 && $('trix-toolbar .trix-button--icon-fullscreen').length == 0) {
    $('trix-toolbar').find('.trix-button-row').
      append("<span class='trix-button-group trix-button-group--custom-tools'><button type='button' class='trix-button trix-button--icon trix-button--icon-fullscreen' title='Fullscreen'>'Fullscreen'</button></span>");
  }
/*
  let trixEditor = document.querySelector('trix-editor');
  let wrapper = document.createElement('div');
  wrapper.classList.add('input-container');
  let parent = trixEditor.parentNode;

  // set the wrapper as child (instead of the element)
  parent.replaceChild(wrapper, trixEditor);
  // set element as child of wrapper
  wrapper.appendChild(trixEditor);
  */
});


