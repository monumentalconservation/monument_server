core.Sites = {};

$( document ).on('turbolinks:load', function() {
  if ($('h3#site-info').size() > 0) {
    core.Sites.readySiteSubmissionTags()
    core.Sites.readyModal()
  } 
});

core.Sites.readySiteSubmissionTags = function() {
  $('.tags').tagsInput();
}

core.Sites.readyModal = function() {
  MicroModal.init();
}