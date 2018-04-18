/**
 * Contains a library folder's metadata
 * @typedef {Object} LibraryFolder
 * @property {number} libraryfolderid - The folder's internal id
 * @property {number} parentfolderid - The id of the parent folder
 * @property {string} archiveddate - null if the folder is not archived
 * @property {string} name - The folder's name
 * @property {string} type - The folder's access type:
 *   - General
 *   - Finance
 *   - Operations and Contracts
 */

/**
 * Contains a library file's metadata
 * @typedef {Object} LibraryFile
 * @property {number} libraryid - The file's internal id
 * @property {number} libraryfolderid - The folder in which this file is located
 * @property {string} filename - The file's name in the filesystem (should be unique)
 * @property {string} displayname - The displayed filename (used for downloading)
 * @property {string} thumbnailfilename - The file's thumbnail
 * @property {string} title - The file's title
 * @property {string} description - The file's description
 * @property {boolean} ispublic - True if publicly accessible, false otherwise
 * @property {string} archiveddate - null if the file is not archived
 */

/**
 * Contains the current user's library permissions. These properties only affect the UI
 * @typedef LibraryPermissions
 * @property {boolean} manager - If true, the current user is a manager.
 *   Users that have the manager/admin role are able to:
 *     - Create, edit, archive, and restore files/categories
 *     - View archived files/categories
 *
 * @property {boolean} authenticated - If true, the user has been authenticated.
 *   Authenticated users are able to:
 *     - View non-archived, private files and categories
 *     - Download all files in each category (non-recursive batch download)
 *
 * @property {boolean} uploadFiles - If true, the user may upload files
 *   using the 'Create Library File' form.
 */

$(function() {
    /**
     * A reference to the jstree object used to view/select categories (folders)
     * @type Object
     */
    var tree = null;

    /**
     * The list of folders in the left navigation pane
     * @type LibraryFolder[]
     */
    var folders = [];

     /** @type LibraryPermisssions */
    var permissions = window.libraryPermissions || {
        manager: false,
        authenticated: false,
        uploadFiles: false,
    }

    initialize();

    /**
     * Populates the navigation pane with all folders the current
     * user has access to.
     * @returns void
     */
    function initialize() {
        $.get('/library/folders')
            .done(showFolders)
            .fail(handleError)
    }

    /**
     * Creates a jstree from an array of folders.
     *
     * When a folder is selected, the files pane will be
     * populated with its contents.
     *
     * Folders at the root level also show the number of
     * files contained in all subfolders.
     *
     * @param {LibraryFolder[]} folders
     */
    function showFolders(folders) {
        tree = $.jstree(folders);
        getFolderContents(tree.selected_node())
            .done(showFiles)
            .fail(handleError)
    }

    /**
     * Populates the files pane with the specified files
     * @param {LibraryFile[]} files
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
            });
        }

        $('#total-documents').text(files.length.toLocaleString());
        $('#files-pane').empty()

        // for each file, append an entry in the files pane
        files.forEach(function(file) {
            // ListView
            if (useListView) {
                // clone the library list item template
                var item = $('#library-listitem-template')
                    .html()
                    .appendTo('#file-pane');

                // populate the template's title
                item.find('.item-title')
                    .text(file.displayname)
                    .title(file.description)
                    .prop('href', [
                        '/library/file',
                        file.libraryid,
                        file.displayname
                    ].join('/'))

                if (showEditLinks) {
                    // if this item is archived, show a 'Restore' link
                    if (file.archiveddate) {
                        item.find('.archive-item').remove()
                        item.find('.unarchive-item').click(function() {
                            unarchiveFile(file.libraryid).done(initialize);
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
                // clone the library item template
                var item = $('#library-item-template')
                    .html()
                    .appendTo('#files-pane');

                // populate the template's title and description
                item.find('.item-title').text(file.title)
                item.find('.item-description').text(file.description)
                item.find('.item-download-link')
                    // create download link (eg: Download PDF)
                    .text('Download ' + file.displayname
                        .split('.')
                        .pop()
                        .toUpperCase())
                    .prop('href', [
                        '/library/file',
                        file.libraryid,
                        file.displayname
                    ].join('/'));
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