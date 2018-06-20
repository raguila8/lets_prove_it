/*
$(document).on('turbolinks:load', function() {
  if ($("#problem-form").length) {
    window.onbeforeunload = function() {
      return true;
    };
  }
});
*/

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