jQuery(function() {
    var $ = jQuery,
        root = window.location.pathname,
        tree = null;
    root = root.slice(0,root.slice(0,-1).lastIndexOf('/'));
    var path = root + '/library/';
    var functions = {
        'writeDisplay': function(isPublic,files) {
            var frame = $('#library-display .frame').empty();
            if (files.length > 0) {
                frame.toggleClass('preview',isPublic);
                $.each(files,function(index,entry) {
                    var title = entry.Title||entry.Filename,
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
                      '</div>'
                    );
                });
            } else {
                frame.removeClass('preview');
                frame.append('<div class="item"><h4>No Files Found</h4></div>');
            }
        },
        'mapTree': function(entry) {
            return {
                id: entry.LibraryFolderID,
                parent: entry.ParentFolderID == "0" ? "#" : entry.ParentFolderID,
                text: entry.Name,
                state: {
                    opened: false,
                    disabled: false,
                    selected: false
                },
                data: {
                  'isPublic': entry.IsPublic != "0"
                }
            };
        },
        'initialize': function(response) {
            var folders = response.folders.map(functions.mapTree);
            folders[0].state.selected = true;
            $('#library-tree').jstree({
                'core' : {
                    'check_callback': true,
                    'data' : folders,
                    'multiple': false
                }
            }).on('changed.jstree', function(e, data) {
                var node = data.selected;
                if (node.length > 0) {
                    $.get(path+'folder/'+data.selected[0]).done(function(response) {
                        functions.writeDisplay(response.isPublic,response.files);
                    });
                }
                tree = $('#library-tree').jstree();
            });
        },
        'createNew': function(e,isFolder) {
            e.preventDefault();
            var node = functions.getNode()||{'id':0,'data':{'isPublic':0}},
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
        }
    };
    $.get(path+'initialize').done(functions.initialize);
    $('#library-search .searchbox').on('click',function(e) {
        $(e.currentTarget).find('input').focus();
    });
    $('#create-folder').on('click',function(e) {
        functions.createNew(e,true);
    });
    $('#upload-file').on('click',function(e) {
        functions.createNew(e,false);
    });
    $('#archive-folder').on('click',function(e) {
        functions.archiveFolder(e);
    });
    $('#view-archive').on('click',function(e) {
        e.preventDefault();
    });
    $('[name="is_public"]').on('change', function(e) {
        var target = $(e.target);
        target.parent().toggleClass('private',!target.prop('checked'));
    });
    $('#library-save').on('click',function(e) {1
        e.preventDefault();
        if ($('#library-parameters').hasClass('folder')) {
            functions.saveFolder(e);
        } else {
            var form = new FormData($('#library-parameters').closest('form')[0]);
            $.ajax({
                'url': path+'file',
                'type': 'POST',
                'data': form,
                'cache': false,
                'contentType': false,
                'processData': false
            }).done(function(response) {
                console.log(response);
                var nodes = tree.get_selected();
                tree.deselect_all();
                tree.select_node(nodes);
                functions.closeParams(e);
            });
        }
    });
    $('#library-cancel').on('click',functions.closeParams);
});

