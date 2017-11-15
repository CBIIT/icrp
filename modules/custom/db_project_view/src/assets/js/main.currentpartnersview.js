$(document).ready(function() {
  $('#current_partners_export').on('click',function(e) {
    e.preventDefault();
    var exportObj = [{
      title: 'Current Partners',
      rows: [
        ['Partner Name','Sponsor Code','Country','Join Date','Mission']
      ]
    }];
    $.merge(exportObj[0].rows,current_partners_data.map(function(entry) {
      return [
        entry.name,
        entry.sponsor_code,
        entry.country,
        entry.join_date,
        entry.description
      ];
    }));
    $.ajax({
      url: '/map/getExcelExport/ICRPPartner',
      method: 'POST',
      data: JSON.stringify(exportObj)
    }).done(function(resp) {
      window.location = '/'+resp;
    });
  });
});