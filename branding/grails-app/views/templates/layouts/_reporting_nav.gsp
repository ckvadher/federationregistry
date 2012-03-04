<g:render template='/templates/frtopnavigation'/>

<ul class="level2">
  <n:hasPermission target="federation:reporting">
    <li class="${controllerName == 'federationReports' ? 'active':''}"><g:link controller="federationReports" action="summary"><g:message code="fedreg.navigation.federationreports"/></g:link></li>
    <li class="${controllerName == 'idPReports' ? 'directactive':''}"><g:link controller="idPReports" action="view"><g:message code="fedreg.navigation.idpreports"/></g:link></li>
    <li class="${controllerName == 'spReports' ? 'directactive':''}"><g:link controller="spReports" action="view"><g:message code="fedreg.navigation.spreports"/></g:link></li>
  </n:hasPermission>
  <li class="${controllerName in ['IdentityProviderAttributeCompliance', 'attributeRelease', 'certifyingAuthorityUsage'] ? 'active':''}"><g:link controller="IdentityProviderAttributeCompliance" action="summary"><g:message code="fedreg.navigation.compliance"/></g:link></li>
</ul>

<g:if test="${controllerName in ['IdentityProviderAttributeCompliance', 'attributeRelease', 'certifyingAuthorityUsage']}" >
  <ul class="level3a">
    <li class="${controllerName == 'IdentityProviderAttributeCompliance' ? 'active':''}">
      <g:link controller="IdentityProviderAttributeCompliance" action="summary"><g:message code="label.attributesummary" /></g:link>
    </li>
    <li class="${controllerName == 'attributeRelease' ? 'active':''}">
      <g:link controller="attributeRelease" action="index"><g:message code="label.attributerelease" /></g:link>
    </li>
    <li class="${controllerName == 'certifyingAuthorityUsage' ? 'active':''}">
      <g:link controller="certifyingAuthorityUsage" action="index"><g:message code="label.cautilization" /></g:link>
    </li>
  </ul> 
</g:if>

<g:if test="${controllerName in ['federationReports']}" >
  <ul class="level3a">
    <li class="${controllerName == 'federationReports' && actionName == 'summary' ? 'active':''}">
      <g:link controller="federationReports" action="summary"><g:message code="fedreg.navigation.reporting.summary" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'registrations' ? 'active':''}">
      <g:link controller="federationReports" action="registrations"><g:message code="fedreg.navigation.reporting.registrations" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'growth' ? 'active':''}">
      <g:link controller="federationReports" action="growth"><g:message code="fedreg.navigation.reporting.growth" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'sessions' ? 'active':''}">
      <g:link controller="federationReports" action="sessions"><g:message code="fedreg.navigation.reporting.sessions" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'idputilization' ? 'active':''}">
      <g:link controller="federationReports" action="idputilization"><g:message code="fedreg.navigation.reporting.idputilization" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'serviceutilization' ? 'active':''}">
      <g:link controller="federationReports" action="serviceutilization"><g:message code="fedreg.navigation.reporting.serviceutilization" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'demand' ? 'active':''}">
      <g:link controller="federationReports" action="demand"><g:message code="fedreg.navigation.reporting.demand" /></g:link>
    </li>
    <li class="${controllerName == 'federationReports' && actionName == 'dsutilization' ? 'active':''}">
      <g:link controller="federationReports" action="dsutilization"><g:message code="fedreg.navigation.reporting.dsutilization" /></g:link>
    </li>
  </ul> 
</g:if>