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
                id = target.closest('.item-wrapper').data('library-file-data').LibraryID;
            target.attr('disabled',true);
            ancestors.unshift(node.id);
            ancestors.pop();
            lAjax({
                'url': path+'file/'+id,
                'method': 'DELETE'
            }).done(function(response) {
                target.addClass('restore-file').removeClass('archive-file').closest('.item-wrapper').addClass('archived');
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
            if (!isFolder) {
                if (nodeId == undefined) {
                    if (node) {
                        nodeId = node.id;
                    } else {
                        BootstrapDialog.alert({
                            'title': null,
                            'message': "No folder is currently selected."
                        });
                    }
                }
                functions.populateParents(nodeId);
                $('#library-edit h1').html("Create Library File");
                $('#library-edit').addClass('active').siblings().removeClass('active');
            } else if (node) {
                if (nodeId == undefined) nodeId = node.id;
                functions.populateParents(nodeId);
                $('#library-edit h1').html("Create Library Folder");
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
            var data = $(e.target).closest('.item-wrapper').data('library-file-data'),
                params = $('#library-parameters'),
                ispub = params.find('[name="is_public"]');
            params.find('[name="id_value"]').val(data.LibraryID);
            params.find('[name="upload"]').addClass('hide').prev().val(data.DisplayName).removeClass('hide');
            params.find('[name="title"]').val(data.Title);
            params.find('[name="description"]').val(data.Description);
            params.find('[name="thumbnail"]').addClass('hide').prev().html(data.ThumbnailFilename).removeClass('hide');
            functions.createNew(e, false, data.LibraryFolderID);
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
        'getParameterByName': function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
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
                    var searchString = functions.getParameterByName('search'),
                        nodeString = functions.getParameterByName('nodeId');
                    if (searchString) {
                        $('#library [name="library-keywords"]').val(searchString);
                        functions.search();
                    } else if (nodeString) {
                        tree.select_node(nodeString);
                    } else {
                        var json = tree.get_json();
                        for (var index = 0; index < json.length; index++) {
                            if (!json[index].state.hidden && (role !== "public" || json[index].text == "Publications")) break;
                        }
                        if (index < json.length) tree.select_node(json[index]);
                    }
                }).on('refresh.jstree', function() {
                    var node = functions.getNode();
                    if (node === undefined || node.state.hidden) {
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
                    if (nodes.length > 0) {
                        if (!window.history.state || (window.history.state.nodeId !== nodes[0])) {
                            functions.pushstate({'nodeId':nodes[0]});
                        }
                        $('#library-search [name="library-keywords"]').val('');
                        lGet(path+'folder/'+nodes[0]).done(function(response) {
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
        'pushstate': function(obj) {
            var query = "";
            for (var prop in obj) {
                query += "&"+prop+"="+obj[prop];
            }
            query = "?"+query.substring(1);
            window.history.pushState(obj,window.title,[window.location.protocol, '//',window.location.host,window.location.pathname,query].join(''));
        },
        'restoreFile': function(e) {
            var node = functions.getNode(),
                ancestors = node.parents,
                target = $(e.target),
                id = target.closest('.item-wrapper').data('library-file-data').LibraryID;
            target.attr('disabled',true);
            ancestors.unshift(node.id);
            ancestors.pop();
            lAjax({
                'url': path+'file/'+id,
                'method': 'PUT'
            }).done(function(response) {
                target.removeClass('restore-file').addClass('archive-file').closest('.item-wrapper').removeClass('archived');
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
                display_name = $('#library-parameters [name="display_name"]');
                desc = $('#library-parameters [name="description"]').val();
            if ((!file.hasClass('hide') && (file.val()||"") === "") || (!display_name.hasClass('hide') && (display_name.val()||"") === "") || (title||"") === "" || (desc||"") === "") {
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
                      tree.select_node(tree.create_node(entry.parent,entry,'last'));
                      parent = tree.get_node(entry.parent);
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
        'search': function() {
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
                        var id = entry.LibraryID,
                            title = entry.Title||entry.DisplayName,
                            thumb = entry.ThumbnailFilename||"",
                            description = entry.Description||"",
                            file = entry.DisplayName,
                            isArchived = (entry.ArchivedDate !== null);
                        if (thumb === "") {
                            thumb = root+'/sites/default/files/library/File-ImagePlaceholder.svg';
                        } else {
                            thumb = path+'file/thumb/'+thumb;
                        }
                        frame.append(
                          '<div class="item-wrapper'+(isArchived?' archived':'')+'">'+
                              '<div class="item">'+
                                  '<h5>'+title+'</h5>'+
                                  '<img src="'+thumb+'"/>'+
                                  '<p>'+description+'</p>'+
                                  '<div><a href="'+path+'file/'+id+'/'+file+'" target="_blank">Download '+file.substr(file.lastIndexOf('.')+1).toUpperCase()+'</a></div>'+
                              '</div>'+
                          '</div>'
                        );
                    });
                } else {
                    frame.removeClass('preview');
                    $.each(files,function(index,entry) {
                        var id = entry.LibraryID,
                            file = entry.DisplayName,
                            isArchived = (entry.ArchivedDate !== null),
                            isPublic = (entry.IsPublic == "1");
                        frame.append(
                          '<div class="item-wrapper'+(isArchived?' archived':'')+(isPublic?' public-doc':'')+'">'+
                              '<div class="item">'+
                                  '<div title="'+(isPublic?'Public Document':'Non-Public Document')+'"></div>'+
                                  '<div><a href="'+path+'file/'+id+'/'+file+'" target="_blank">'+file+'</a></div>'+
                                  '<button class="admin edit-file" title="Edit File"></button>'+
                                  '<button class="admin '+(isArchived?'restore-file':'archive-file')+'" title="'+(isArchived?'Restore File':'Archive File')+'"></button>'+
                              '</div>'+
                          '</div>'
                        ).children('*:last-child').data('library-file-data',entry);
                    });
                }
            } else {
                frame.removeClass('preview');
            }
            frame.append('<div class="item-wrapper"><div class="item">No Files Found</div></div>');
        }
    };
    functions.initialize();
    $('#library-search .searchbar [name="library-keywords"]').on('keypress', function(e) {
        if (e.which == 13) {
          e.preventDefault();
          $('#library-search-button').trigger('click');
        }
    });
    $('#library-search-button').on('click', function(e) {
        var val = $('#library [name="library-keywords"]').val();
        e.preventDefault();
        functions.search();
        functions.pushstate({'search': val});
    });
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
    $('#library-save').on('click',function(e) {
        e.preventDefault();
        if ($('#library-parameters').hasClass('folder')) {
            functions.saveFolder(e);
        } else {
            functions.saveFile(e);
        }
    });
    $('#library-cancel').on('click',functions.closeParams);
    window.onpopstate = function(e) {
        if (e.state) {
            if (e.state.search) {
                $('#library [name="library-keywords"]').val(e.state.search);
                functions.search();
                return;
            } else if (e.state.nodeId) {
                tree.deselect_all();
                tree.select_node(e.state.nodeId);
            }
        }
        tree.refresh();
    }
});