
<!doctype html>
<html>
  <head>
    <meta name="layout" content="admin">
  </head>
  <body>
    <div id="create-role" class="content scaffold-create" role="main">
      <h2><g:message encodeAs="HTML" code="label.createrole" default="Create Role" /></h2>

      <g:hasErrors bean="${role}">
        <ul class="clean alert alert-error">
          <g:eachError bean="${role}" var="error">
          <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message encodeAs="HTML" error="${error}"/></li>
          </g:eachError>
        </ul>
      </g:hasErrors>
      <g:form action="save" class="form form-horizontal validating">
        <fieldset>
          <g:render template="form"/>
        </fieldset>
        <fieldset>
          <div class="form-actions">
            <g:submitButton name="create" class="save" value="${message(code: 'label.create', default: 'Create')}" class="btn btn-success"/>
            <g:link action="list" class="btn"><g:message encodeAs="HTML" code="label.cancel"/></g:link>
          </div>
        </fieldset>
      </g:form>
    </div>
  </body>
</html>
