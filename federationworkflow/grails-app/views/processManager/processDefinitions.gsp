<html>
<head>
<title>Process Manager | Processes</title>
<meta name="layout" content="${grailsApplication.config.workflowEngine.layout.administration}" />
</head>

<body>

<table style="width: 1000px; border: 0;">
<tr>
<td>
<h1>Process Definitions</h1><br>
<a href="${createLink(action: 'newProcess')}">Create new process</a>
<p>&nbsp;</p>
<table>
<tr>
    <g:sortableColumn property="process" title="Process" style="width: 230px;" params="${params}"/>
    <g:sortableColumn property="process" title="Description" params="${params}"/>
    <g:sortableColumn property="version" title="Version" style="width: 30px; text-align:center" params="${params}"/>
    <th style="width: 90px; text-align:center; color: #333; font-size: 10px; text-decoration: none;">Current Instance</th>
    <g:sortableColumn property="lastUpdated" title="Last Updated" style="width: 150px; text-align:center" params="${params}"/>
    
</tr>

<g:if test="${processes}">
<g:set var="isOddNumber" value="${true}" />
<g:each var="process" in="${processes}">
<g:if test="${isOddNumber}">
<tr class="odd">
<g:set var="isOddNumber" value="${false}" />
</g:if>
<g:else>
<tr class="even">
<g:set var="isOddNumber" value="${true}" />
</g:else>

    <td><a href="${createLink(action: 'processDefinition', id: process.id)}">${process.name}</a></td>

    <g:if test="${process.description}">    
    <td>${process.description}</td>
    </g:if>
    <g:else>
    <td>Nil.</td>
    </g:else>
    <td style="text-align: center;">${process.processVersion}</td>
    <td style="text-align: center;">${process.instances.size()}</td>
    <td style="text-align: center;"><g:formatDate format="EEE dd/MMM/yyyy, h:mm:ssa" date="${process.lastUpdated}"/></td>

</tr>
</g:each>
</g:if>

<g:else>
<tr>
    <td colspan="7"><b>Nil.</b></td>
</tr>
</g:else>

</table>

</td>
</tr>
</table>
