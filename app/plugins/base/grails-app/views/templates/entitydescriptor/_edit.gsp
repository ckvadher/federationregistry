<div id="editor-entitydescriptor" class="revealable">

  <g:form action="update" id="${entity.id}" method="PUT" class="form-horizontal validating">
    <fieldset>

      <div class="control-group">
        <label class="control-label" for="entity.status"><g:message encodeAs="HTML" code="label.status" /></label>
        <div class="controls">
          <input type="radio" name="entity.active" value="true"  ${entity.active ? 'checked' : ''}/>
          <g:message encodeAs="HTML" code="label.active"/>
        
          <input type="radio" name="entity.active" alue="false" ${entity.active ? '' : 'checked'}/>
          <g:message encodeAs="HTML" code="label.inactive"/>
          <fr:tooltip code='help.fr.entity.status' />
        </div>
      </div>
    
      <div class="control-group">
        <label class="control-label" for="entity.identifier"><g:message encodeAs="HTML" code="label.entitydescriptor" /></label>
        <div class="controls">
          <g:textField name="entity.identifier" value="${entity.entityID}" class="required span4"/>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label" for="entity.extensions"><g:message encodeAs="HTML" code="label.extensions" /></label>
        <div class="controls">
          <g:textArea name="entity.extensions" value="${entity.extensions}" class="span4"/>
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="edit-entitydescriptor btn btn-success"><g:message encodeAs="HTML" code="label.save"/></button>
        <a class="cancel-edit-entitydescriptor btn"><g:message encodeAs="HTML" code="label.cancel"/></a>
      </div>

    </fieldset>
  </g:form>

</div>

<div id="editor-entitydescriptor-migrateorg" class="revealable">

  <p class="alert alert-info"><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.overview.migrateorganization" /></p>

  <g:form action="migrate" id="${entity.id}" method="PUT" class="form-horizontal validating">
    <fieldset>
      <div class="control-group">
        <label><g:message encodeAs="HTML" code="label.currentorganisation"/></label>
        <div class="controls">
          <g:link controller="organization" action="show" id="${entity.organization?.id}">${fieldValue(bean: entity, field: "organization.displayName")}</g:link>
        </div>
      </div>

      <div class="control-group">
        <label><g:message encodeAs="HTML" code="label.neworganisation"/></label>
        <div class="controls">
          <g:select name="newOrgId" from="${organizations.sort{it.displayName}}" optionKey="id" optionValue="displayName" />
        </div>
      </div>



      <div class="form-actions">
        <button type="submit" class="edit-entitydescriptor btn btn-success"><g:message encodeAs="HTML" code="label.save"/></button>
        <a class="cancel-entitydescriptor-migrateorg btn"><g:message encodeAs="HTML" code="label.cancel"/></a>
      </div>

    </fieldset>
  </g:form>

</div>

<div id="archive-entitydescriptor-modal" class="modal hide fade">
  <div class="modal-header">
    <a class="close close-modal">&times;</a>
    <h3><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.archive.confirm.title"/></h3>
  </div>
  <div class="modal-body">
    <p><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.archive.confirm.descriptive"/></p>
  </div>
  <div class="modal-footer">
    <a class="btn close-modal"><g:message encodeAs="HTML" code="label.cancel" /></a>

    <g:form controller="entityDescriptor" action="archive" id="${entity.id}" style="padding: 0px;">
      <input name="_method" type="hidden" value="put" />
      <button type="submit" class="btn btn-warning"><g:message encodeAs="HTML" code="label.archive" /></a>
    </g:form>
  </div>
</div>

<div id="unarchive-entitydescriptor-modal" class="modal hide fade">
  <div class="modal-header">
    <a class="close close-modal">&times;</a>
    <h3><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.unarchive.confirm.title"/></h3>
  </div>
  <div class="modal-body">
    <p><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.unarchive.confirm.descriptive"/></p>
  </div>
  <div class="modal-footer">
    <a class="btn close-modal"><g:message encodeAs="HTML" code="label.cancel" /></a>

    <g:form controller="entityDescriptor" action="unarchive" id="${entity.id}" style="padding: 0px;">
      <input name="_method" type="hidden" value="put" />
      <button type="submit" class="btn btn-warning"><g:message encodeAs="HTML" code="label.unarchive" /></a>
    </g:form>
  </div>
</div>

<div id="delete-entitydescriptor-modal" class="modal hide fade">
  <div class="modal-header">
    <a class="close close-modal">&times;</a>
    <h3><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.delete.confirm.title"/></h3>
  </div>
  <div class="modal-body">
    <p><g:message encodeAs="HTML" code="templates.fr.entitydescriptor.delete.confirm.descriptive"/></p>
  </div>
  <div class="modal-footer">
    <a class="btn close-modal"><g:message encodeAs="HTML" code="label.cancel" /></a>
    <g:form controller="entityDescriptor" action="delete" id="${entity.id}" style="padding: 0px;">
      <input name="_method" type="hidden" value="delete" />
      <button type="submit" class="btn btn-danger"><g:message encodeAs="HTML" code="label.delete" /></a>
    </g:form>
  </div>
</div>
