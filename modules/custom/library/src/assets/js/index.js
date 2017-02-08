jQuery(function() {
  var $ = jQuery,
      root = window.location.pathname;
  root = root.slice(0,root.slice(0,-1).lastIndexOf('/'));
  var path = root + '/library/';
  var writeDisplay = function(isPublic,files) {
      var frame = $('#library-display .frame').toggleClass('preview',isPublic).empty();
      if (files.length > 0) {
          $.each(files,function(index,entry) {
              var title = entry.Title||entry.Filename,
                  thumb = entry.ThumbnailFilename||"",
                  description = entry.Description||"",
                  file = entry.Filename;
              if (thumb === "") {
                  thumb = root+'/sites/default/files/library/placeholder.jpg';
              } else {
                  thumb = path+'files/thumbs/'+thumb;
              }
              frame.append(
                '<div class="item">'+
                    '<h4>'+title+'</h4>'+
                    '<img src="'+thumb+'"/>'+
                    '<p>'+description+'</p>'+
                    '<div><a href="'+path+'files/'+file+'">Download '+file.substr(file.lastIndexOf('.')+1).toUpperCase()+'</a></div>'+
                '</div>'
              );
          });
      } else {
          frame.append('<div class="item"><h4>No Files Found</h4></div>');
      }
  }
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
              'data' : folders,
              'multiple': false
          }
      }).on('changed.jstree', function(e, data) {
          var node = data.selected;
          if (node.length > 0) {
              $.get(path+'get/folder/'+data.selected[0]).done(function(response) {
                  writeDisplay(response.isPublic,response.files);
              });
          }
      });
  });
  $('#library-search .searchbox').on('click',function(e) {
      $(e.currentTarget).find('input').focus();
  });
});

