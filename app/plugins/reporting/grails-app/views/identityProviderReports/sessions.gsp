<html>
  <head>
    <meta name="layout" content="reporting" />
  </head>
  <body>
    <div class="centered">
      <form id="detailed-idpsessions-report-parameters" class="form-inline report-parameters well validating">
        <label for="idpID"><g:message encodeAs="HTML" code="label.identityprovider"/></label>
        <g:select name="idpID" from="${idpList}" optionKey="id" optionValue="displayName" class="span3"/>

        <label for="startDate"><g:message encodeAs="HTML" code="label.startdate"/></label>
        <input name="startDate" placeholder="Start Date (YYYY-MM-DD)" class="datepicker required span2" type="text"/>

        <label for="endDate"><g:message encodeAs="HTML" code="label.enddate"/></label>
        <input name="endDate" placeholder="End Date (YYYY-MM-DD)" class="datepicker required span2" type="text"/>

        <a class="request-detailed-idpsessions-report btn"><g:message encodeAs="HTML" code="label.generate"/></a>
        <a class="export-detailed-idpsessions-report export-button btn btn-info hidden" rel="tooltip" title="${g.message(encodeAs:"HTML", code:'label.exportexcel')}"><i class="icon-edit icon-white"></i></a>
      </form>
    </div>

    <div class="row">
      <div class="span11">
        <div class="span11 spinner centered"><r:img dir="images" file="spinner.gif"/></div>
        <div id="detailedidpsessionschart"></div>
      </div>
    </div>

    <r:script>
      var detailedidpsessionsEndpoint = "${createLink(controller:'identityProviderReports', action:'reportsessions')}"

      $(document).ready(function() {
        fr.setup_date_range();
        $('.request-detailed-idpsessions-report').click();
      });
    </r:script>
  </body>
</html>
