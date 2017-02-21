jQuery(function() {
    var $ = jQuery,
        root = window.location.pathname,
        tree = null
        role = null;
    root = root.slice(0,root.slice(0,-1).lastIndexOf('/'));
    var path = root + '/library/';
    var functions = {
        'writeDisplay': function(isPublic,files) {
            var frame = $('#library-display .frame').empty();
            if (files.length > 0) {
                frame.toggleClass('preview',isPublic);
                $.each(files,function(index,entry) {
                    var id = entry.LibraryID,
                        title = entry.Title||entry.Filename,
                        thumb = entry.ThumbnailFilename||"",
                        description = entry.Description||"",
                        file = entry.Filename;
                    if (thumb === "") {
                        thumb = root+'/sites/default/files/library/placeholder.jpg';
                    } else {
                        thumb = path+'file/thumb/'+thumb;
                    }
                    frame.append(
                      '<div class="item">'+
                          '<h4>'+title+'</h4>'+
                          '<img src="'+thumb+'"/>'+
                          '<p>'+description+'</p>'+
                          '<div><a href="'+path+'file/'+file+'">Download '+file.substr(file.lastIndexOf('.')+1).toUpperCase()+'</a></div>'+
                          '<button class="admin archive-file" data-id="'+id+'"></button>'+
                      '</div>'
                    );
                });
            } else {
                frame.removeClass('preview');
                frame.append('<div class="item"><h4>No Files Found</h4></div>');
            }
        },
        'mapTree': function(tree) {
            var exists = tree.map(function(entry) {
              return entry.LibraryFolderID;
            });
            return tree.map(function(entry) {
                return {
                    id: entry.LibraryFolderID,
                    parent: (exists.includes(entry.ParentFolderID) ? entry.ParentFolderID : "#"),
                    text: entry.Name,
                    state: {
                        opened: false,
                        disabled: false,
                        selected: false
                    },
                    data: {
                      'isPublic': entry.IsPublic != "0"
                    }
                }
            });
        },
        'initialize': function(response) {
            var folders = functions.mapTree(response.folders);
            role = response.role;
            folders[0].state.selected = true;
            $('#library').toggleClass('admin',role==="admin");
            $('#library-tree').jstree({
                'core' : {
                    'check_callback': true,
                    'data' : folders,
                    'multiple': false
                }
            }).on('ready.jstree', function(e, data) {
                tree = $('#library-tree').jstree();
            }).on('changed.jstree', function(e, data) {
                var node = data.selected;
                if (node.length > 0) {
                    $.get(path+'folder/'+data.selected[0]).done(function(response) {
                        functions.writeDisplay(role==="public",response.files);
                    });
                }
            });
        },
        'createNew': function(e,isFolder) {
            e.preventDefault();
            var node = functions.getNode()||{'id':1,'data':{'isPublic':0}},
                params = $('#library-parameters').toggleClass('folder',isFolder),
                ispub = params.find('[name="is_public"]');
            $('[name="is_public"]').parent().toggleClass('folder',isFolder);
            params.find('[name="parent"]').val(node.id);
            ispub.attr('checked',node.data.isPublic);
            ispub.parent().toggleClass('public',node.data.isPublic);
            $('#library-edit').addClass('active').siblings().removeClass('active');
        },
        'closeParams': function(e) {
            e.preventDefault();
            $('#library-view').addClass('active').siblings().removeClass('active');
            $('#library-edit').find('form')[0].reset();
        },
        'getNode': function() {
            var nodes = tree.get_selected(true);
            return nodes.length === 0 ? undefined : nodes[0];
        },
        'saveFolder': function(e) {
            var form = new FormData($('#library-parameters').closest('form')[0]);
            $.ajax({
                'url': path+'folder',
                'type': 'POST',
                'data': form,
                'cache': false,
                'contentType': false,
                'processData': false
            }).done(function(response) {
                if (response.success) {
                  var row = functions.mapTree(response.row);
                  tree.deselect_all();
                  tree.select_node(tree.create_node(row.parent,row,'last'));
                  functions.closeParams(e);
                }
            });
        },
        'archiveFolder': function(e) {
            var node = functions.getNode();
            $.ajax({
              'url': path+'folder/'+node.id,
              'method': 'DELETE',
            }).done(function(response) {
                if (response.success) {
                    tree.delete_node(node.id);
                } else {
                }
            });
            e.preventDefault();
        },
        'saveFile': function(e) {
            var form = new FormData($('#library-parameters').closest('form')[0]);
            $.ajax({
                'url': path+'file',
                'type': 'POST',
                'data': form,
                'cache': false,
                'contentType': false,
                'processData': false
            }).done(function(response) {
                var nodes = tree.get_selected();
                tree.deselect_all();
                tree.select_node(nodes);
                functions.closeParams(e);
            });
        },
        'search': function(e) {
            e.preventDefault();
            var val = $('#library [name="library-keywords"]').val().toLowerCase(),
                form = new FormData();
            form.append("keywords",val);
            $.ajax({
                'url': path+'search',
                'type': 'POST',
                'data': form,
                'cache': false,
                'contentType': false,
                'processData': false
            }).done(function(response) {
                tree.deselect_all();
                functions.writeDisplay(role==="public",response);
            });
        }
    };
    $.get(path+'initialize').done(functions.initialize);
    $('#library-search .searchbox').on('click',function(e) {
        e.preventDefault();
        $(e.currentTarget).find('input').focus();
    }).on('keypress', function(e) {
        if (e.which == 13) {
          e.preventDefault();
          $('#library-search-button').trigger('click');
        }
    });
    $('#library-search-button').on('click', functions.search);
    $('#create-folder').on('click',function(e) {
        functions.createNew(e,true);
    });
    $('#upload-file').on('click',function(e) {
        functions.createNew(e,false);
    });
    $('#archive-folder').on('click',functions.archiveFolder);
    $('#view-archive').on('click',function(e) {
        $.get(path+'archived').done(function(response) {
            var folders = functions.mapTree(response.folders);
            tree.destroy();
            tree = $('#library-tree').jstree({
                'core' : {
                    'check_callback': true,
                    'data' : folders,
                    'multiple': false
                }
            }).on('ready.jstree', function(e, data) {
                tree = $('#library-tree').jstree();
            }).on('changed.jstree', function(e, data) {
                var node = data.selected;
                if (node.length > 0) {
                    $.get(path+'folder/'+data.selected[0]).done(function(response) {
                        functions.writeDisplay(role==="public",response.files);
                    });
                }
            });
        });
        e.preventDefault();
    });
    $('[name="is_public"]').on('change', function(e) {
        var target = $(e.target);
        target.parent().toggleClass('private',!target.prop('checked'));
    });
    $('#library-save').on('click',function(e) {
        e.preventDefault();
        if ($('#library-parameters').hasClass('folder')) {
            functions.saveFolder(e);
        } else {
            functions.saveFile(e);
        }
    });
    $('#library-cancel').on('click',functions.closeParams);
    $('#library-display').on('click', '.archive-file', function(e) {
        var target = $(e.target),
            id = target.attr('data-id');
        $.ajax({
            'url': path+'file/'+id,
            'method': 'DELETE'
        }).done(function(response) {
            var item = target.closest('.item');
            console.log(response);
            if (item.siblings().length > 0) {
                item.remove();
            } else {
                functions.writeDisplay(role==="public",[]);
            }
        });
    });
});

