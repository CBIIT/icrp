$(document).ready(function(){

  $('table').DataTable({
    pagingType: 'simple_numbers',
    lengthMenu: [
        25, 50, 100, 250
    ],
    order: [],
    dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
        + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'li><'mv-5'p>>"
        + "<'d-flex align-items-center flex-wrap'C>"
        + "><'table-responsive't>",
    autoWidth: false,
    language: {
        lengthMenu: 'Display _MENU_',
        info: '<label style="margin-left: 5px">of _TOTAL_ people</label>',
        infoFiltered: '',
        infoEmpty: '',
    },
    customDom: function(settings) {
        return $('<button>')
          .addClass('btn btn-default btn-sm')
          .text('Export')
          .prepend($('<i>')
            .css('margin-right', '5px')
            .addClass('fa fa-download'))
          .click(exportRecords)
    },
  })

  function exportRecords(e) {
    e.preventDefault();
    var exportObj = [{
      title: 'Search Criteria',
      rows: [
        ['Search Criteria:','Award Code'],
        ['Award Code:',db_people_map.funding_details[0].alt_award_code]
      ]
    }, {
      title: 'Data',
      rows: [
        ['Name','Type','ORC_ID','Institution','Region','Location']
      ]
    }];
    $.merge(exportObj[1].rows,db_people_map.funding_details.map(function(entry) {
      return [
        entry.pi_name,
        entry.is_pi?'Principal Investigator':'Collaborator',
        entry.pi_orcid,
        entry.institution,
        entry.region,
        [entry.city, entry.state, entry.country].filter(e => e && e.length).join(', ')
      ];
    }));
    $.ajax({
      url: '/map/getExcelExport/',
      method: 'POST',
      data: JSON.stringify(exportObj)
    }).done(function(resp) {
      window.location = '/'+resp;
    });
  }


});