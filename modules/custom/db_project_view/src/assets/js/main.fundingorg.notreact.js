$(document).ready(function() {
  $('#funding_org_export').on('click',function(e) {
    e.preventDefault();
    $.get({url:'/getFundingOrg'}).done(function(resp) {
      var exportObj = [{
        title: 'Funding Organizations',
        rows: [
          ['Name','Type','Abbreviation','Sponsor Code','Country','Currency','Annualized Funding','Last Import Date','Import Description']
        ]
      }];
      console.log(resp);
      $.merge(exportObj[0].rows,resp.map(function(entry) {
        return [
          entry.Name,
          entry.Type,
          entry.Abbreviation,
          entry.SponsorCode,
          entry.Country,
          entry.Currency,
          entry.IsAnnualized,
          entry.LastImportDate,
          entry.LastImportDesc
        ];
      }));
      console.log(exportObj);
      $.ajax({
        url: '/map/getExcelExport/',
        method: 'POST',
        data: JSON.stringify(exportObj)
      }).done(function(resp) {
        window.location = '/'+resp;
      });
    });
  });
});