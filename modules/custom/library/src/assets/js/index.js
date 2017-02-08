jQuery(function() {
  var $ = jQuery,
      path = window.location.pathname;
  path += path.endsWith("/") ? "" : "/";
  $.get(path+"get/initialize").done(function(response) {
    var folders = response.folders.map(function(entry) {
        return {
            id: entry.LibraryFolderID,
            parent: entry.ParentFolderID == "0" ? "#" : entry.ParentFolderID,
            text: entry.Name,
            state: {
              opened: false,
              disabled: false,
              selected: false
            }
        };
    });
    folders[0].state.selected = true;
    $('#library-tree').jstree({
        'core' : {
            'data' : folders
        }
    });
  });
  $('#library-search .searchbox').on('click',function(e) {
      $(e.currentTarget).find('input').focus();
  });
});

