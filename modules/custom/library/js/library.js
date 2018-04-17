$(function() {

    /**
     * A reference to the jstree object used to view/select categories (folders)
     */
    var tree = null;

    /**
     * The list of folders in the left navigation pane.
     */
    var folders = [];

    /**
     * manager:
     *   If true, the current user is a manager. Users that have the
     *   manager/admin role are able to
     *     - Create, edit, archive, and restore files/categories
     *     - View archived files/categories
     *
     * authenticated:
     *   If true, the user has been authenticated. Authenticated users
     *   are able to:
     *     - View non-archived, private files and categories
     *     - Download all files in each category (non-recursive batch download)
     *
     * uploadFiles:
     *   If true, the user may upload files using the 'Create Library
     *   File' form.
     *
     * NOTE: although these values can be manually changed, they only
     * affect which controls are visible to the user
     */

    var permissions = window.libraryPermissions || {
        viewPrivateFiles: false,
        uploadFiles: false,
        archiveFiles: false,
    }

    initialize();

    /**
     * Populates the navigation pane with all folders the current
     * user has access to.
     */
    function initialize() {
        $.get('/library/folders')
            .done(buildTree)
            .fail(handleError)
    }

    /**
     * Creates a custom jstree from an array of folders
     * When a folder is selected, the files pane will be
     * populated with its contents.
     *
     * Folders at the root level also show the
     *
     * @param {array<LibraryFolder>} folders
     */
    function buildTree(folders) {
        tree = $.jstree(folders);
        getFolderContents(tree.selected_node())
            .done(showFiles)
            .fail(handleError)
    }

    /**
     * Populates
     * @param {array<LibraryFile>} files
     */
    function showFiles(files) {
        // authenticated users will ses a ListView
        // instead of a Thumbnail/TileView
        var useListView = permissions.authenticated;

        // only managers may edit library files
        var showEditLinks = permissions.manager;

        // check if we should show archives
        var showArchives = permissions.manager &&
            $('#show-archives').prop('checked');

        if (!showArchives) {
            // only allow files that have no archived date
            files = files.filter(function(file) {
                return file.archiveddate == null;
            })
        }

        $('#total-documents').text(files.length.toLocaleString());

        // ensure the files pane has the proper class
        // and make sure it is cleared
        $('#files-pane')
            .toggleClass('list-view', useListView)
            .empty()

        // for each file, append an entry in the files pane
        files.forEach(function(file) {
            // ListView
            if (useListView) {
                var item = $('#library-listitem-template > div')
                    .clone()
                    .appendTo('#file-pane');

                item.find('.item-title')
                    .prop('href', ['/library/file', file.id, file.title].join('/'))
                    .text(file.title)

                if (showEditLinks) {
                    // if this item is archived, show a 'Restore' link
                    if (file.archiveddate) {
                        item.find('.archive-item').remove()
                        item.find('.unarchive-item').click(function() {
                            unarchiveFile(file.id).done(initialize);
                        })

                    // otherwise, show an 'Archive' link
                    } else {
                        item.find('.unarchive-item').remove();
                        item.find('.archive-item').click(function() {
                            archiveFile(file.id).done(initialize);
                        })
                    }
                }
            // Thumbnail/TileView
            } else {
                var item = $('#library-item-template > div')
                    .clone()
                    .appendTo('#files-pane');

                item.find('.item-title').text(file.title)
                item.find('.item-description').text(file.description)
                item.find('a.item-download-link')
                    .prop('href', ['/library/file', file.id, file.title].join('/'))
                    .text('Download ' + file.title.split('.').pop().toUpperCase());
            }
        });
    }

    function newFile(parameters) {
        return $.post('/library/file/', parameters)
    }

    function updateFile(parameters) {
        return $.post('/library/file/update/' + folderId, parameters)
    }

    function getFolderContents(folderId) {
        return $.post('/library/folder/contents/' + folderId)
    }

    function archiveFolder(folderId) {
        return $.post('/library/folder/archive/' + folderId);
    }

    function unarchiveFolder(folderId) {
        return $.post('/library/folder/unarchive/' + folderId);
    }

    function archiveFile(fileId) {
        return $.post('/library/file/archive/' + fileId);
    }

    function unarchiveFile(fileId) {
        return $.post('/library/file/unarchive/' + fileId);
    }

    $('#library-search').submit(function(e) {
        e.preventDefault();
        $.get('/library/search/', $('#keywords').val())
            .done(showFiles);
    });

    $('#new-folder').click(function() {
        var form = $('#library-form-template > form').clone();


        form.submit(function() {
            $.post('/library/folder/', form)
                .done(initialize);
        });
    })

    $('#new-subfolder').click(function() {
        var form = $('#library-form-template > form').clone();

        form.submit(function() {
            $.post('/library/folder/', form)
                .done(initialize);
        })
    })

    $('#update-folder').click(function() {
        var form = $('#library-form-template > form').clone();
        form.submit(function() {
            $.post('/library/folder/update', form)
                .done(initialize);
        });
    });

    $('#new-file').click(function() {
        var form = $('#library-form-template > form').clone();
        form.submit(function() {
            $.post('/library/file/', form)
                .done(initialize);
        });
    });

    $('#update-file').click(function() {
        var form = $('#library-form-template > form').clone();
        form.submit(function() {


            $.post('/library/file/update', form)
                .done(initialize);
        });
    });

    $('#show-archives').change(function() {
        if ($(this).prop('checked')) {
            buildTree(folders);
        } else {
            buildTree(folders.filter(function(folder) {
                return folder.archiveddate != null
            }));
        }
    });
})