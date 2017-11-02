$(document).ready(function(){
  $('#db_people_map_export').on('click',function(e) {
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
  });
  $('#buttonShowAll').on('click',function(e) {
    e.preventDefault();
    var table = $('table.project-collaborators'),
        showall = table.hasClass('showall');
    table.toggleClass('showall',!showall);
    $(e.target).html('Show '+(showall?'All':'Less'));
  });
});