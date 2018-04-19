// @ts-nocheck
jQuery(function() {
    var $ = jQuery,
        root = window.location.pathname,
        tree = null,
        role = null,
        diplayname = null,
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
        'bulkDownload': function(e) {
            e.preventDefault();
            var ids = [];
            $('#library-display .frame').children(':not(.archived)').each(function(i,e) { ids.push($(e).data('libraryFileData').LibraryID); });
            if (ids.length < 1) {
                BootstrapDialog.alert({
                    'title': null,
                    'message': "No files have been selected for download."
                });
                return false;
            }
            window.open(path+'bulk?downloads='+ids.join(','));
            return false;
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
            $('#library-parameters [name="parent"]').change()
            $('#library-edit h1').html("Create Library Category");
            params.find('[name="library_access"]').val(["General"]);
            ispub.removeAttr('checked');
            $('#library-edit').addClass('active').siblings().removeClass('active');
        },
        'createNew': function(e,isFolder,nodeId) {
            e.preventDefault();
            var node = functions.getNode(),
                params = $('#library-parameters').toggleClass('folder',isFolder),
                ispub = params.find('[name="is_public"]');
            $('#library-parameters [name="parent"]').change()
            if (!isFolder) {
                if (nodeId == undefined) {
                    if (node) {
                        nodeId = node.id;
                    } else {
                        BootstrapDialog.alert({
                            'title': null,
                            'message': "No category is currently selected."
                        });
                    }
                }

                functions.populateParents(nodeId);
                $('#library-edit h1').html("Upload Library File");
                $('#library-edit').addClass('active').siblings().removeClass('active');
                $('#library-access-container').hide();
            } else if (node) {
                if (nodeId == undefined) nodeId = node.id;
                var options = functions.populateParents(nodeId);
                $(options).find('[value="1"]').remove();
                $('#library-edit h1').html("Create Library Category");
                $('#library-access-container').show();
                ispub.attr('checked',node.data.isPublic);
                $('#library-edit').addClass('active').siblings().removeClass('active');
                $('#library-parameters [name="parent"]').change()
            } else {
                BootstrapDialog.alert({
                    'title': null,
                    'message': "No category is currently selected."
                });
            }
        },
        'editFile': function(e) {
            var data = $(e.target).closest('.item-wrapper').data('library-file-data'),
                params = $('#library-parameters'),
                ispub = params.find('[name="is_public"]');
            displayname = data.DisplayName;
            $('#library-access-container').hide();
            params.find('[name="id_value"]').val(data.LibraryID);
            params.find('[name="upload"]').prev().val(data.DisplayName).removeClass('hide');
            params.find('[name="title"]').val(data.Title);
            params.find('[name="description"]').val(data.Description);

            // ensure the thumnailFileName does not contain the id
            var thumbnailFilename = data.ThumbnailFilename

            // remove the second to last portion if it is an id
            if (/.+\.\d+\.\w+$/.test(thumbnailFilename)) {
                var parts = thumbnailFilename.split('.');
                parts.splice(parts.length - 2, 1);
                thumbnailFilename = parts.join('.');
            }

            params.find('[name="thumbnail"]').prev().val(thumbnailFilename).removeClass('hide');
            functions.createNew(e, false, data.LibraryFolderID);
            $('#library-edit h1').html("Edit Library File");
            ispub.parent().toggleClass('not_public',data.IsPublic != "1");
            ispub.prop('checked',data.IsPublic == "1");
        },
        'editFolder': function(e) {
            var data = functions.getNode();
            if (data) {
                console.log(data);
                $('#library-access-container').show();
                var params = $('#library-parameters'),
                    ispub = params.find('[name="is_public"]');
                functions.createNew(e,true,data.parents[0]==="#"?"1":data.parents[0]);
                params.find('[name="id_value"]').val(data.id);
                params.find('[name="title"]').val(data.text);
                $('#library-parameters [name="parent"]').change()
                params.find('[name="library_access"]').val([data.data.type]);
                $('#library-edit h1').html("Edit Library Category");
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
            e.preventDefault();
            $('#library-display .frame').removeClass('archived');
            var json = tree.get_json();
            functions.updateTree(json,true);
            tree.settings.core.data = json;
            tree.refresh();
        },
        'initialize': function() {
            lGet(path+'initialize').done(function(response) {
                role = response.role;
                var folders = functions.mapTree(response.folders);
                $('#library').addClass(role);
                $('#library-tree').jstree({
                    'core' : {
                        'check_callback': true,
                        'data' : folders,
                        'dblclick_toggle': false,
                        'multiple': false
                    }
                }).on('loaded.jstree', function(e, data) {
                    tree = $('#library-tree').jstree();
                    var searchString = functions.getParameterByName('search'),
                        nodeString = functions.getParameterByName('nodeId'),
                        json = tree.get_json();
                    if (searchString) {
                        $('#library [name="library-keywords"]').val(searchString);
                        functions.search();
                    } else if (nodeString) {
                        tree.select_node(nodeString);
                    } else if (role == 'public') {
                        for (var index = 0; index < json.length; index++) {
                            if (!json[index].state.hidden && json[index].text == "Publications") break;
                        }
                        if (index < json.length) tree.select_node(json[index]);
                    }
                    for (var index = 0; index < json.length; index++) {
                        var node = json[index],
                            count = node.data.unarchivedCount;
                        tree.get_node(node, true).children(':nth-child(2)').after('<span title="'+count+' active document'+(count!==1?'s':'')+' in this category.">'+count+'</span><div class="clearfix"></div>');
                    }
                }).on('refresh.jstree', function() {
                    var json = tree.get_json(),
                        state = (functions.getNode()||{'state':{'hidden':true}}).state.hidden,
                        frame = $('#library-display .frame'),
                        isArchived = frame.hasClass('archived');
                    if (state) {
                        tree.deselect_all();
                    }
                    var getCount;
                    if (isArchived) {
                        for (var index = 0; index < json.length; index++) {
                            var node = json[index],
                                count = node.data.unarchivedCount+node.data.archivedCount;
                            tree.get_node(node, true).children(':nth-child(2)').after('<span title="'+count+' active document'+(count!==1?'s':'')+' in this category.">'+count+'</span><div class="clearfix"></div>');
                        }
                    } else {
                        for (var index = 0; index < json.length; index++) {
                            var node = json[index],
                                count = node.data.unarchivedCount;
                            tree.get_node(node, true).children(':nth-child(2)').after('<span title="'+count+' active document'+(count!==1?'s':'')+' in this category.">'+count+'</span><div class="clearfix"></div>');
                        }
                    }
                    $('#library-display .display-header .document-count').html((isArchived ? frame.children() : frame.children(':not(.archived)')).length);
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
                    if (nodes.length === 0) {
                        if (window.history.state && window.history.state.nodeId) {
                            functions.pushstate({});
                            $('#library-display .display-header').removeClass('search');
                            $('#library-display .frame').empty();
                        }
                    } else {
                        $('#library-display .display-header').addClass('search').find('.search-type').html('Category:');
                        var node = tree.get_node(nodes[0]);
                        if (!window.history.state || (window.history.state.nodeId !== node.id)) {
                            functions.pushstate({'nodeId':node.id});
                        }
                        $('#library-search [name="library-keywords"]').val('');
                        $('#library-display .display-header .search-name').html(node.text);
                        lGet(path+'folder/'+node.id).done(function(response) {
                            functions.writeDisplay(response.files,role==="public");
                        });
                    }
                }).on('dblclick.jstree', function(e, data) {
                    var node = functions.getNode();
                    if (node !== undefined) {
                        if (node.state.opened) {
                            tree.close_all(node);
                        } else {
                            tree.open_all(node);
                        }
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
                        unarchivedCount: parseInt(entry.UnarchivedCount),
                        type: entry.Type,
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
        'populateParents': function(nodeId, disabledNodeIds) {
            if (disabledNodeIds == undefined) {
                disabledNodeIds = []
            }

            var parent = $('#library-parameters [name="parent"]'),
                json = tree.get_json(),
                tab = "&#8193;",
                selected = tree.get_selected(true);
            function popChildren(children,tabCount) {
                var countedTab = "";
                for (var index = 0; index < tabCount; index++) countedTab += tab;
                children.forEach(function(child) {
                    $('<option>')
                        .val(child.id)
                        .prop('selected', child.id == nodeId)
                        .prop('disabled', disabledNodeIds.indexOf(child.id) >= 0)
                        .html(countedTab + child.text)
                        .data('library-access', child.data.type)
                        .appendTo(parent);
                    popChildren(child.children, tabCount + 1);
                })
            };
            parent.append('<option value="1">ROOT</option>');
            popChildren(json,1);
            return parent;
        },
        'pushstate': function(obj) {
            var query = "";
            for (var prop in obj) {
                query += "&"+prop+"="+obj[prop];
            }
            if (query.length > 0) query = "?"+query.substring(1);
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
        'saveFile': function(e) {
            var file = $('#library-parameters [name="upload"]'),
                title = $('#library-parameters [name="title"]').val();
                display_name = $('#library-parameters [name="display_name"]');
                desc = $('#library-parameters [name="description"]').val();
            if ((display_name.hasClass('hide') && (file.val()||"") === "") || (!display_name.hasClass('hide') && (display_name.val()||"") === "") || (title||"") === "" || (desc||"") === "") {
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
                    var id = tree.get_selected();
                    $.jstree.destroy();
                    functions.initialize();
                    tree.select_node(id);

                    // var entry = response.row,
                    //     node = functions.getNode(),
                    //     parent = entry.ParentFolderID;
                    // entry = {
                    //     id: entry.LibraryFolderID,
                    //     parent: tree.get_node(entry.ParentFolderID).id||'#',
                    //     text: entry.Name,
                    //     children: [],
                    //     data: {
                    //         archivedCount: parseInt(entry.ArchivedCount)||0,
                    //         isArchived: entry.ArchivedDate !== null,
                    //         isPublic: entry.IsPublic == "1",
                    //         unarchivedCount: parseInt(entry.UnarchivedCount)||0,
                    //         type: entry.Type
                    //     },
                    //     state: {
                    //         opened: false,
                    //         disabled: false,
                    //         selected: false
                    //     }
                    // };
                    // if (node && node.id === entry.id) {
                    //     node.data.isPublic = entry.data.isPublic;
                    //     node.data.type = entry.data.type;
                    //     if (node.text !== entry.text) tree.rename_node(node,entry.text);
                    //     if (node.parent != entry.parent) tree.move_node(node,entry.parent);
                    // } else {
                    //     tree.deselect_all();
                    //     tree.select_node(tree.create_node(entry.parent,entry,'last'));
                    //     parent = tree.get_node(entry.parent);
                    //     parent.children = parent.children.map(function(entry) { return tree.get_node(entry); }).sort(functions.caselessSort);
                    //     if ($('#library-display .frame').hasClass('archived')) {
                    //         functions.showArchives(e);
                    //     } else {
                    //         functions.hideArchives(e);
                    //     }
                    // }
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
                if (!window.history.state || window.history.state.search != val) {
                    functions.pushstate({'search': val});
                }
                tree.deselect_all();
                $('#library-display .display-header').addClass('search');
                $('#library-display .display-header .search-type').html("Keywords Search:");
                $('#library-display .display-header .search-name').html(val);
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
            e.preventDefault();
            $('#library-display .frame').addClass('archived');
            var json = tree.get_json();
            functions.updateTree(json,false);
            tree.settings.core.data = json;
            tree.refresh();
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
            var frame = $('#library-display .frame').empty(),
                isArchived = frame.hasClass('archived');
            $('#library-display .display-header .document-count').html((isArchived ? files : files.filter(function(entry) {return entry.ArchivedDate === null})).length);
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
                            thumb = root+'/data/library/File-ImagePlaceholder.svg';
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
                                    '<div>'+
                                        '<button class="admin edit-file" title="Edit Document Metadata"><a></a></button>'+
                                        '<button class="admin '+(isArchived?'restore-file':'archive-file')+'" title="'+(isArchived?'Restore Document':'Archive Document')+'"><a></a></button>'+
                                    '</div>'+
                                '</div>'+
                            '</div>'
                        ).children('*:last-child').data('library-file-data',entry);
                    });
                }
            } else {
                frame.removeClass('preview');
            }
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
        e.preventDefault();
        functions.search();
    });
    $('#library-create-folder').on('click',function(e) {
        if (functions.getNode()) {
            functions.createNew(e,true);
        } else {
            functions.createNewRoot(e,true);
        }
    });
    $('#library-create-root-folder').on('click',function(e) {
        functions.createNewRoot(e,true);
    });
    $('#library-edit-folder').on('click',functions.editFolder);
    $('#library-upload-file').on('click',function(e) {

        if (functions.getNode()) {
            functions.createNew(e,false);
        } else {
            BootstrapDialog.alert({
                'title': null,
                'message': 'No category is currently selected. To upload a library file, you must first select a category.',
            });
        }
    });
    $('#library-download-all').on('click',functions.bulkDownload);
    $('#library-archive-folder').on('click',functions.archiveFolder);
    $('#library-show-archives').on('change',function(e) {
        if (this.checked) {
            functions.showArchives(e);
        } else {
            functions.hideArchives(e);
        }
    });
    $('#library-display').on('click', '.edit-file', functions.editFile);
    $('#library-display').on('click', '.archive-file', functions.archiveFile);
    $('#library-display').on('click', '.restore-file', functions.restoreFile);
    $('#library-edit [name="upload"], #library-edit [name="thumbnail"]').on('change', function(e) {
        var filelist = $(this)[0].files;
        if (filelist.length > 0) {
            $(this).prev().val(filelist[0].name);
        } else {
            $(this).prev().val(displayname);
        }
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
    $('#library-parameters [name="parent"]').change(function() {
        $('#library-parameters [name="library_access"]').prop('disabled', this.value != 1)
        var accessType = $(this).find(":selected").data('library-access') || 'General';
        $('#library-parameters [name="library_access_subcategory"]').val(accessType);
        $('#library-parameters [name="library_access"]').val([accessType]);
    });

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
