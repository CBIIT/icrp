jQuery(function() {
    var $ = jQuery,
        root = window.location.pathname,
        tree = null
        role = null;
    root = root.slice(0,root.slice(0,-1).lastIndexOf('/'));
    var path = root + '/library/';
    var functions = {
        'archiveFile': function(e) {
            var target = $(e.target),
                id = target.attr('data-id');
            $.ajax({
                'url': path+'file/'+id,
                'method': 'DELETE'
            }).done(function(response) {
                var item = target.closest('.item');
                if (item.siblings().length > 0) {
                    item.remove();
                } else {
                    functions.writeDisplay([],role==="public");
                }
            });
        },
        'archiveFolder': function(e) {
            var node = functions.getNode();
            $.ajax({
                'url': path+'folder/'+node.id,
                'method': 'DELETE'
            }).done(function(response) {
                tree.delete_node(node.id);
            });
            e.preventDefault();
        },
        'closeParams': function(e) {
            e.preventDefault();
            $('#library-view').addClass('active').siblings().removeClass('active');
            $('#library-edit').find('form')[0].reset();
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
        'getNode': function() {
            var nodes = tree.get_selected(true);
            return nodes.length === 0 ? undefined : nodes[0];
        },
        'initialize': function() {
            $.get(path+'initialize').done(function(response) {
                var folders = functions.mapTree(response.folders);
                $('#library-management').removeClass('hide');
                $('#library-archive-management').addClass('hide');
                role = response.role;
                $('#library').toggleClass('admin',role==="admin");
                if (tree !== null) tree.destroy();
                $('#library-tree').jstree({
                    'core' : {
                        'check_callback': true,
                        'data' : folders,
                        'multiple': false
                    }
                }).on('ready.jstree', function(e, data) {
                    tree = $('#library-tree').jstree();
                    tree.select_node(tree.get_json()[0]);
                }).on('changed.jstree', function(e, data) {
                    var node = data.selected;
                    if (node.length > 0) {
                        $.get(path+'folder/'+data.selected[0]).done(function(response) {
                            functions.writeDisplay(response.files,role==="public");
                        });
                    }
                });
            });
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
                      'isPublic': entry.IsPublic != "0",
                      'isArchived': entry.ArchivedDate !== null
                    }
                }
            });
        },
        'restoreFile': function(e) {
            var node = functions.getNode(),
                parents = node.parents,
                id = $(e.target).attr('data-id');
            parents.unshift(node.id);
            parents.pop();
            $.ajax({
                'url': path+'file/'+id,
                'method': 'PUT'
            }).done(function(response) {
                functions.viewArchive(e, parents);
            });
            e.preventDefault();
        },
        'restoreFolder': function(e) {
            var node = functions.getNode(),
                parents = node.parents;
            parents.unshift(node.id);
            parents.pop();
            $.ajax({
                'url': path+'folder/'+node.id,
                'method': 'PUT'
            }).done(function(response) {
                functions.viewArchive(e, parents);
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
                functions.writeDisplay(response,role==="public");
            });
        },
        'viewArchive': function(e, parents) {
            if (parents === undefined) parents = [];
            $.get(path+'archived/folders').done(function(response) {
                var folders = functions.mapTree(response.folders);
                $('#library-management').addClass('hide');
                $('#library-archive-management').removeClass('hide');
                tree.destroy();
                $('#library-tree').jstree({
                    'core' : {
                        'check_callback': true,
                        'data' : folders,
                        'multiple': false
                    }
                }).on('ready.jstree', function(e, data) {
                    tree = $('#library-tree').jstree();
                    while (parents.length > 0) {
                        var node = tree.get_node(parents.shift());
                        if (node) {
                            tree.select_node(node);
                            break;
                        }
                    }
                    if (tree.get_selected().length === 0) {
                        tree.select_node(tree.get_json()[0]);
                    }
                }).on('changed.jstree', function(e, data) {
                    var nodes = data.selected;
                    if (nodes.length > 0) {
                        var node = data.node;
                        $.get(path+'archived/files/'+node.id).done(function(response) {
                            functions.writeDisplay(response.files,role==="public");
                        });
                        if (node.data.isArchived === true) {
                          $('#library-restore-folder').removeAttr('disabled');
                        } else {
                          $('#library-restore-folder').attr('disabled',true);
                        }
                    }
                });
            });
            e.preventDefault();
        },
        'writeDisplay': function(files,isPublic) {
            var frame = $('#library-display .frame').empty();
            if (files.length > 0) {
                frame.toggleClass('preview',isPublic);
                $.each(files,function(index,entry) {
                    var id = entry.LibraryID,
                        title = entry.Title||entry.Filename,
                        thumb = entry.ThumbnailFilename||"",
                        description = entry.Description||"",
                        file = entry.Filename,
                        isArchived = (entry.ArchivedDate === null);
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
                          '<button class="admin '+(isArchived?'archive-file':'restore-file')+'" data-id="'+id+'"></button>'+
                      '</div>'
                    );
                });
            } else {
                frame.removeClass('preview');
                frame.append('<div class="item"><h4>No Files Found</h4></div>');
            }
        }
    };
    functions.initialize();
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
    $('#library-create-folder').on('click',function(e) {
        functions.createNew(e,true);
    });
    $('#library-upload-file').on('click',function(e) {
        functions.createNew(e,false);
    });
    $('#library-archive-folder').on('click',functions.archiveFolder);
    $('#library-view-archive').on('click',functions.viewArchive);
    $('#library-display').on('click', '.archive-file', functions.archiveFile);
    $('#library-restore-folder').on('click', functions.restoreFolder);
    $('#library-view-display').on('click',function(e) {
      e.preventDefault();
      functions.initialize();
    });
    $('#library-display').on('click', '.restore-file', functions.restoreFile);
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
});

