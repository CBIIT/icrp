jQuery(function() {
    var $ = jQuery,
        root = window.location.pathname,
        tree = null,
        role = null,
        failFunction = function(xhr,status) {
            BootstrapDialog.alert({
                'title': null,
                'message': "An error occurred: "+status+"\n"+
                           "If the problem persists, please alert the administrators."
            });
        },
        lAjax = function(obj) { return $.ajax(obj).fail(failFunction); },
        lGet = function(path) { return $.get(path).fail(failFunction); };
    root = root.slice(0,root.slice(0,-1).lastIndexOf('/'));
    var path = root + '/library/';
    var functions = {
        'archiveFile': function(e) {
            var node = functions.getNode(),
                ancestors = node.parents,
                target = $(e.target),
                id = target.parent().data('library-file-data').LibraryID;
            target.attr('disabled',true);
            ancestors.unshift(node.id);
            ancestors.pop();
            lAjax({
                'url': path+'file/'+id,
                'method': 'DELETE'
            }).done(function(response) {
                target.addClass('restore-file').removeClass('archive-file').closest('.item').addClass('archived');
                while (ancestors.length > 0) {
                    var ancestor = tree.get_node(ancestors.shift());
                    ancestor.data.archivedCount += 1;
                    ancestor.data.unarchivedCount -= 1;
                }
                if ($('#library-display .frame').hasClass('archived')) {
                    functions.showArchives(e);
                } else {
                    functions.hideArchives(e);
                }
                target.removeAttr('disabled');
            });
        },
        'archiveFolder': function(e) {
            var node = functions.getNode(),
                archiveChildren = function(children) {
                  $.each(children,function(index,child) {
                      child = tree.get_node(child);
                      child.data.isArchived = true;
                      child.data.archivedCount += child.data.unarchivedCount;
                      child.data.unarchivedCount = 0;
                      archiveChildren(child.children);
                  });
                };
            lAjax({
                'url': path+'folder/'+node.id,
                'method': 'DELETE'
            }).done(function(response) {
                node.data.isArchived = true;
                node.data.archivedCount += node.data.unarchivedCount;
                node.data.unarchivedCount = 0;
                archiveChildren(node.children);
                if ($('#library-display .frame').hasClass('archived')) {
                    functions.showArchives(e);
                } else {
                    functions.hideArchives(e);
                }
            });
            e.preventDefault();
        },
        'caselessSort': function(a, b) {
            return a.text.toLowerCase() > b.text.toLowerCase() ? 1 : a.text.toLowerCase() < b.text.toLowerCase() ? -1 : 0
        },
        'closeParams': function(e) {
            var params = $('#library-parameters');
            params.find('[name="parent"]').empty();
            params.find('[name="upload"]').removeClass('hide').prev().empty().addClass('hide');
            params.find('[name="thumbnail"]').removeClass('hide').prev().empty().addClass('hide');
            e.preventDefault();
            $('#library-view').addClass('active').siblings().removeClass('active');
            $('#library-edit').find('form')[0].reset();
        },
        'createNewRoot': function(e) {
            e.preventDefault();
            var params = $('#library-parameters').addClass('folder'),
                ispub = params.find('[name="is_public"]');
            functions.populateParents(1);
            $('#library-edit h1').html("Create Library Folder");
            ispub.removeAttr('checked');
            $('#library-edit').addClass('active').siblings().removeClass('active');
        },
        'createNew': function(e,isFolder,nodeId) {
            e.preventDefault();
            var node = functions.getNode(),
                params = $('#library-parameters').toggleClass('folder',isFolder),
                ispub = params.find('[name="is_public"]');
            if (node) {
                if (nodeId == undefined) nodeId = node.id;
                functions.populateParents(nodeId);
                if (isFolder) {
                    $('#library-edit h1').html("Create Library Folder");
                } else {
                    $('#library-edit h1').html("Create Library File");
                }
                ispub.attr('checked',node.data.isPublic);
                $('#library-edit').addClass('active').siblings().removeClass('active');
            } else {
                BootstrapDialog.alert({
                    'title': null,
                    'message': "No folder is currently selected."
                });
            }
        },
        'editFile': function(e) {
            var target = $(e.target).parent(),
                data = target.data('library-file-data'),
                params = $('#library-parameters'),
                ispub = params.find('[name="is_public"]');
            params.find('[name="id_value"]').val(data.LibraryID);
            params.find('[name="upload"]').addClass('hide').prev().html(data.Filename).removeClass('hide');
            params.find('[name="title"]').val(data.Title);
            params.find('[name="description"]').val(data.Description);
            params.find('[name="thumbnail"]').addClass('hide').prev().html(data.ThumbnailFilename).removeClass('hide');
            functions.createNew(e, false);
            $('#library-edit h1').html("Edit Library File");
            ispub.parent().toggleClass('not_public',data.IsPublic != "1");
            ispub.prop('checked',data.IsPublic == "1");
        },
        'editFolder': function(e) {
            var data = functions.getNode();
            if (data) {
                var params = $('#library-parameters'),
                    ispub = params.find('[name="is_public"]');
                functions.createNew(e,true,data.parents[0]==="#"?"1":data.parents[0]);
                params.find('[name="id_value"]').val(data.id);
                params.find('[name="title"]').val(data.text);
                $('#library-edit h1').html("Edit Library Folder");
                ispub.parent().toggleClass('not_public',!data.data.isPublic);
                ispub.prop('checked',data.data.isPublic);
            }
        },
        'getNode': function() {
            var nodes = tree.get_selected(true);
            return nodes.length === 0 ? undefined : nodes[0];
        },
        'hideArchives': function(e) {
            // $('#library-restore-folder').addClass('hide');
            $('#library-display .frame').removeClass('archived');
            var backing = tree.get_json();
            functions.updateTree(backing,true);
            tree.settings.core.data = backing;
            tree.refresh();
            e.preventDefault();
        },
        'initialize': function() {
            lGet(path+'initialize').done(function(response) {
                role = response.role;
                var folders = functions.mapTree(response.folders);
                //$('#library-management').removeClass('hide');
                //$('#library-archive-management').addClass('hide');
                $('#library').addClass(role);
                $('#library-tree').jstree({
                    'core' : {
                        'check_callback': true,
                        'data' : folders,
                        'multiple': false
                    }
                }).on('ready.jstree', function(e, data) {
                    tree = $('#library-tree').jstree();
                    var json = tree.get_json();
                    for (var index = 0; index < json.length; index++) {
                        if (!json[index].state.hidden && (role !== "public" || json[index].text == "Publications")) break;
                    }
                    if (index < json.length) tree.select_node(json[index]);
                }).on('refresh.jstree', function() {
                    if (functions.getNode().state.hidden) {
                        tree.deselect_all();
                        var json = tree.get_json();
                        for (var index = 0; index < json.length; index++) {
                            if (!json[index].state.hidden) break;
                        }
                        tree.select_node(tree.get_json()[index]);
                    }
                }).on('rename_node.jstree',function(e, data) {
                  var node = functions.getNode(),
                      parent = tree.get_node(node.parents[0]);
                  parent.children = parent.children.map(function(entry) { return tree.get_node(entry); }).sort(functions.caselessSort);
                  if ($('#library-display .frame').hasClass('archived')) {
                      functions.showArchives(e);
                  } else {
                      functions.hideArchives(e);
                  }
                }).on('move_node.jstree',function(e, data) {
                  var node = functions.getNode(),
                      parent = tree.get_node(node.parents[0]);
                  parent.children = parent.children.map(function(entry) { return tree.get_node(entry); }).sort(functions.caselessSort);
                  if ($('#library-display .frame').hasClass('archived')) {
                      functions.showArchives(e);
                  } else {
                      functions.hideArchives(e);
                  }
                }).on('changed.jstree', function(e, data) {
                    var nodes = data.selected;
                    $('#library-search [name="library-keywords"]').val('');
                    if (nodes.length > 0) {
                        lGet(path+'folder/'+data.selected[0]).done(function(response) {
                            functions.writeDisplay(response.files,role==="public");
                        });
                    }
                });
            });
        },
        'mapTree': function(tree) {
          var map = {},
              treeBase = [];
          $.each(tree,function(index,entry) {
            var entry = {
              id: entry.LibraryFolderID,
              parent: entry.ParentFolderID,
              text: entry.Name,
              children: [],
              data: {
                archivedCount: parseInt(entry.ArchivedCount),
                isArchived: entry.ArchivedDate !== null,
                isPublic: entry.IsPublic == "1",
                unarchivedCount: parseInt(entry.UnarchivedCount)
              },
              state: {
                disabled: false,
                hidden: false,
                opened: false,
                selected: false
              }
            };
            map[entry.id] = entry;
          });
          for (var prop in map) {
            var entry = map[prop],
                parent = entry.parent;
            delete entry.parent;
            if (map[parent]) {
              map[parent].children.push(entry);
            } else {
              treeBase.push(entry);
            }
          }
          functions.setupTree(treeBase.sort(functions.caselessSort));
          functions.updateTree(treeBase, true);
          return treeBase;
        },
        'populateParents': function(nodeId) {
            var parent = $('#library-parameters [name="parent"]'),
                json = tree.get_json(),
                tab = "&#8193;",
                popChildren = function(children,tabCount) {
                    var countedTab = "";
                    for (var index = 0; index < tabCount; index++) countedTab += tab;
                    for (var index = 0; index < children.length; index++) {
                        parent.append('<option value="'+children[index].id+'"'+(children[index].id==nodeId?' SELECTED':'')+'>'+countedTab+children[index].text+'</option>');
                        popChildren(children[index].children,tabCount+1);
                    }
                };
            parent.append('<option value="1">ROOT</option>');
            popChildren(json,1);
        },
        'restoreFile': function(e) {
            var node = functions.getNode(),
                ancestors = node.parents,
                target = $(e.target),
                id = target.parent().data('library-file-data').LibraryID;
            target.attr('disabled',true);
            ancestors.unshift(node.id);
            ancestors.pop();
            lAjax({
                'url': path+'file/'+id,
                'method': 'PUT'
            }).done(function(response) {
                target.removeClass('restore-file').addClass('archive-file').closest('.item').removeClass('archived');
                while (ancestors.length > 0) {
                    var ancestor = tree.get_node(ancestors.shift());
                    ancestor.data.isArchived = false;
                    ancestor.data.archivedCount -= 1;
                    ancestor.data.unarchivedCount += 1;
                }
                functions.showArchives(e);
                target.removeAttr('disabled');
            });
            e.preventDefault();
        },
        'restoreFolder': function(e) {
            var node = functions.getNode(),
                ancestors = node.parents;
            ancestors.unshift(node.id);
            ancestors.pop();
            lAjax({
                'url': path+'folder/'+node.id,
                'method': 'PUT'
            }).done(function(response) {
                while (ancestors.length > 0) {
                    var ancestor = tree.get_node(ancestors.shift());
                    ancestor.data.isArchived = false;
                }
                functions.showArchives(e);
            });
            e.preventDefault();
        },
        'saveFile': function(e) {
            var file = $('#library-parameters [name="upload"]'),
                title = $('#library-parameters [name="title"]').val();
                desc = $('#library-parameters [name="description"]').val();
            if ((!file.hasClass('hide') && (file.val()||"") === "") || (title||"") === "" || (desc||"") === "") {
                BootstrapDialog.alert({
                  'title': null,
                  'message': "Missing required parameters."
                });
            } else {
                $(e.target).attr('disabled');
                var form = new FormData($('#library-parameters').closest('form')[0]);
                lAjax({
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
                    $(e.target).removeAttr('disabled');
                });
            }
        },
        'saveFolder': function(e) {
            var title = $('#library-parameters [name="title"]').val();
            if ((title||"") === "") {
                BootstrapDialog.alert({
                  'title': null,
                  'message': "Missing required parameters."
                });
            } else {
                $(e.target).attr('disabled');
                var form = new FormData($('#library-parameters').closest('form')[0]);
                lAjax({
                    'url': path+'folder',
                    'type': 'POST',
                    'data': form,
                    'cache': false,
                    'contentType': false,
                    'processData': false
                }).done(function(response) {
                  var entry = response.row,
                      node = functions.getNode(),
                      parent = entry.ParentFolderID;
                  entry = {
                      id: entry.LibraryFolderID,
                      parent: tree.get_node(entry.ParentFolderID).id||'#',
                      text: entry.Name,
                      children: [],
                      data: {
                          archivedCount: parseInt(entry.ArchivedCount),
                          isArchived: entry.ArchivedDate !== null,
                          isPublic: entry.IsPublic == "1",
                          unarchivedCount: parseInt(entry.UnarchivedCount)
                      },
                      state: {
                          opened: false,
                          disabled: false,
                          selected: false
                      }
                  };
                  if (node && node.id === entry.id) {
                      node.data.isPublic = entry.data.isPublic;
                      if (node.text !== entry.text) tree.rename_node(node,entry.text);
                      if (node.parent != entry.parent) tree.move_node(node,entry.parent);
                  } else {
                      tree.deselect_all();
                      tree.select_node(tree.create_node(parent,entry,'last'));
                      parent = tree.get_node(parent);
                      parent.children = parent.children.map(function(entry) { return tree.get_node(entry); }).sort(functions.caselessSort);
                      if ($('#library-display .frame').hasClass('archived')) {
                          functions.showArchives(e);
                      } else {
                          functions.hideArchives(e);
                      }
                  }
                  functions.closeParams(e);
                  $(e.target).removeAttr('disabled');
                });
            }
        },
        'search': function(e) {
            e.preventDefault();
            var val = $('#library [name="library-keywords"]').val().toLowerCase(),
                form = new FormData();
            form.append("keywords",val);
            lAjax({
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
        'setupTree': function(children) {
            var archivedCount = 0,
                unarchivedCount = 0;
            $.each(children, function(index, entry) {
              entry.children = entry.children.sort(functions.caselessSort);
              var results = functions.setupTree(entry.children);
              entry.data.archivedCount += results.archivedCount;
              entry.data.unarchivedCount += results.unarchivedCount;
              archivedCount += entry.data.archivedCount;
              unarchivedCount += entry.data.unarchivedCount;
            });
            return {
              'archivedCount': archivedCount,
              'unarchivedCount': unarchivedCount
            };
        },
        'showArchives': function(e) {
            $('#library-display .frame').addClass('archived');
            var backing = tree.get_json();
            functions.updateTree(backing,false);
            tree.settings.core.data = backing;
            tree.refresh();
            e.preventDefault();
        },
        'updateTree': function(children, hideArchives) {
            if (role==="admin" || role==="partner") return;
            if (hideArchives === undefined) hideArchives = false;
            $.each(children, function(index, entry) {
              entry.state.hidden = hideArchives && (entry.data.unarchivedCount === 0 || entry.data.isArchived);
              functions.updateTree(entry.children, hideArchives);
            });
        },
        'writeDisplay': function(files,isPublic) {
            var frame = $('#library-display .frame').empty();
            if (files.length > 0) {
                if (isPublic) {
                    frame.addClass('preview');
                    $.each(files,function(index,entry) {
                        var title = entry.Title||entry.Filename,
                            thumb = entry.ThumbnailFilename||"",
                            description = entry.Description||"",
                            file = entry.Filename,
                            isArchived = (entry.ArchivedDate !== null);
                        if (thumb === "") {
                            thumb = root+'/sites/default/files/library/File-ImagePlaceholder.svg';
                        } else {
                            thumb = path+'file/thumb/'+thumb;
                        }
                        frame.append(
                          '<div class="item'+(isArchived?' archived':'')+'">'+
                              '<h5>'+title+'</h5>'+
                              '<img src="'+thumb+'"/>'+
                              '<p>'+description+'</p>'+
                              '<div><a href="'+path+'file/'+file+'">Download '+file.substr(file.lastIndexOf('.')+1).toUpperCase()+'</a></div>'+
                          '</div>'
                        );
                    });
                } else {
                    frame.removeClass('preview');
                    $.each(files,function(index,entry) {
                        var file = entry.Filename,
                            isArchived = (entry.ArchivedDate !== null);
                        frame.append(
                          '<div class="item'+(isArchived?' archived':'')+'">'+
                              '<div><a href="'+path+'file/'+file+'">'+file+'</a></div>'+
                              '<button class="admin edit-file""></button>'+
                              '<button class="admin '+(isArchived?'restore-file':'archive-file')+'""></button>'+
                          '</div>'
                        ).children('*:last-child').data('library-file-data',entry);
                    });
                }
            } else {
                frame.removeClass('preview');
            }
            frame.append('<div class="item">No Files Found</div>');
        }
    };
    functions.initialize();
    $('#library-search .searchbar [name="library-keywords"]').on('keypress', function(e) {
        if (e.which == 13) {
          e.preventDefault();
          $('#library-search-button').trigger('click');
        }
    });
    $('#library-search-button').on('click', functions.search);
    $('#library-create-folder').on('click',function(e) {
        functions.createNew(e,true);
    });
    $('#library-create-root-folder').on('click',function(e) {
        functions.createNewRoot(e,true);
    });
    $('#library-edit-folder').on('click',functions.editFolder);
    $('#library-upload-file').on('click',function(e) {
        functions.createNew(e,false);
    });
    $('#library-archive-folder').on('click',functions.archiveFolder);
    $('#library-show-archives').on('change',function(e) {
        if (this.checked) {
            functions.showArchives(e);
        } else {
            functions.hideArchives(e);
        }
    });
    //$('#library-restore-folder').on('click', functions.restoreFolder);
    $('#library-display').on('click', '.edit-file', functions.editFile);
    $('#library-display').on('click', '.archive-file', functions.archiveFile);
    $('#library-display').on('click', '.restore-file', functions.restoreFile);
    $('[name="is_public"]').on('change', function(e) {
        var target = $(e.target);
        target.parent().toggleClass('not_public',!target.prop('checked'));
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

