<script type="text/javascript">
	var certificateValidationEndpoint = "${createLink(controller:'coreUtilities', action:'validateCertificate')}";
	var newCertificateValid = false;
	
	$(function() {
		$('#hostname').alphanumeric({nocaps:true, ichars:';'});
		
		$('form').validate({
				ignore: ":disabled",
				rules: {
					'hostname': {
						required: function() {
							return ($("#entity\\.identifier").val() == "");
						}
					}
				},
				keyup: false
		});
		$('form').formwizard({ 
		 	formPluginEnabled: false,
		 	validationEnabled: true,
		 	focusFirstInput : true,
			disableUIStyles: true
		});
		jQuery.validator.addMethod("validcert", function(value, element, params) { 
			validateCertificate();
			return newCertificateValid == true; 
		}, jQuery.format("PEM data invalid"));
		
		$('#cert').rules("add", {
		     required: true,
		     validcert: true
		});
		
		$('#samladvancedmode').hide();
		
		$('#hostname').bind('blur',  function() {
			if($(this).val().length > 0) {
				$(this).val($(this).val().toLowerCase());
				
				$('#entity\\.identifier').val($(this).val() + '/shibboleth');
				$('#sp\\.acs\\.post\\.uri').val($(this).val() + '/Shibboleth.sso/SAML2/POST');
				$('#sp\\.acs\\.artifact\\.uri').val($(this).val() + '/Shibboleth.sso/SAML2/Artifact');
			
				$('#sp\\.slo\\.artifact\\.uri').val($(this).val() + '/Shibboleth.sso/SLO/Artifact');
				$('#sp\\.slo\\.redirect\\.uri').val($(this).val() + '/Shibboleth.sso/SLO/Redirect');
				$('#sp\\.slo\\.soap\\.uri').val($(this).val() + '/Shibboleth.sso/SLO/SOAP');
				$('#sp\\.slo\\.post\\.uri').val($(this).val() + '/Shibboleth.sso/SLO/POST');
				$('#sp\\.drs\\.uri').val($(this).val() + '/Shibboleth.sso/DS');
				$('#sp\\.mnid\\.artifact\\.uri').val($(this).val() + '/Shibboleth.sso/NIM/Artifact');
				$('#sp\\.mnid\\.redirect\\.uri').val($(this).val() + '/Shibboleth.sso/NIM/Redirect');
				$('#sp\\.mnid\\.soap\\.uri').val($(this).val() + '/Shibboleth.sso/NIM/SOAP');
				$('#sp\\.mnid\\.post\\.uri').val($(this).val() + '/Shibboleth.sso/NIM/POST');
			}
		});
	});
	
	function validateCertificate() {
		$('#newcertificatedata').removeClass('error');
		fedreg.keyDescriptor_verify($('#entity\\.identifier').val());
		if(!newCertificateValid) {
			$('#newcertificatedata').addClass('error');
		}
	}
	
</script>

<g:hasErrors>
    <div class="warning">
       <g:message code="fedreg.templates.serviceprovider.create.errors" />
    </div>
</g:hasErrors>

<g:form action="${saveAction}">
	<g:hiddenField name="active" value="true"/>
	<g:hiddenField name="aa.create" value="true"/>
	<g:if test="${!requiresContactDetails}">
		<g:hiddenField name="contact.id" value="${fr.contactID()}"/>
	</g:if>
	<g:hiddenField name="contact.type" value="administrative" />
	
	<div class="step" id="overview">
		<h3><g:message code="fedreg.templates.serviceprovider.create.overview.heading" /></h3>
		<g:message code="fedreg.templates.serviceprovider.create.overview.details" />
	</div>
	
	<g:if test="${requiresContactDetails}">
		<div class="step" id="contact">
			<h3><g:message code="fedreg.templates.serviceprovider.create.contact.heading" /></h3>
			<p>
				<g:message code="fedreg.templates.serviceprovider.create.contact.details" />
			</p>
			<g:hasErrors bean="${contact}">
				<div class="error"><g:renderErrors bean="${contact}"as="list"/></div>
			</g:hasErrors>
			<table>
				<tr>
					<td>
						<label for="contact.givenName"><g:message code="label.givenname" /></label>
					</td>
					<td>
						<g:textField name="contact.givenName"  size="50" class="required" value="${contact?.givenName}"/>
					</td>
				</tr>
				<tr>
					<td>
						<label for="contact.surname"><g:message code="label.surname" /></label>
					</td>
					<td>
						<g:textField name="contact.surname"  size="50" class="required" value="${contact?.surname}"/>
					</td>
				</tr>
				<tr>
					<td>
						<label for="contact.email"><g:message code="label.email" /></label>
					</td>
					<td>
						<g:textField name="contact.email"  size="50" class="required email" value="${contact?.email?.uri}"/>
					</td>
				</tr>
			</table>
		</div>
	</g:if>
	
	<div class="step" id="basic">
		<h3><g:message code="fedreg.templates.serviceprovider.create.basicinformation.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.basicinformation.details" />
		</p>
		<table>
			<tr>
				<td>
					<label for="organization.id"><g:message code="label.organization" /></label>
				</td>
				<td>
					<g:select name="organization.id" from="${organizationList.sort{it.displayName}}" optionKey="id" optionValue="displayName" value="${organization?.id}"/>
				</td>
			</tr>
			<tr>
				<td>
					<label for="sp.displayName"><g:message code="label.displayname" /></label>
				</td>
				<td>
					<g:textField name="sp.displayName"  size="50" class="required" value="${serviceProvider?.displayName}"/>
					<fr:tooltip code='fedreg.help.serviceprovider.displayname' />
				</td>
			</tr>
			<tr>
				<td>
					<label for="sp.description"><g:message code="label.description" /></label>
				</td>
				<td>
					<g:textArea name="sp.description"  class="required" rows="8" cols="36" value="${serviceProvider?.description}"/>
					<fr:tooltip code='fedreg.help.serviceprovider.description' />
				</td>
			</tr>
			<tr>
				<td>
					<label for="sp.servicedescription.connecturl"><g:message code="label.serviceurl" /></label>
				</td>
				<td>
					<g:textField name="sp.servicedescription.connecturl" size="50" class="required url" value="${servicedescription?.connecturl}"/>
					<fr:tooltip code='fedreg.help.serviceprovider.connecturl' />
				</td>
			</tr>
			<tr>
				<td>
					<label for="sp.servicedescription.logourl"><g:message code="label.servicelogourl" /></label>
				</td>
				<td>
					<g:textField name="sp.servicedescription.logourl" size="50" class="url" value="${servicedescription?.logourl}"/>
					<fr:tooltip code='fedreg.help.serviceprovider.logourl' />
				</td>
			</tr>
		</table>
	</div>

	<div class="step" id="saml">
		<h3><g:message code="fedreg.templates.serviceprovider.create.saml.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.saml.details" />
		</p>
		<div id="samlbasicmode">
			<h4><g:message code="fedreg.templates.serviceprovider.create.saml.shibboleth.heading" /></h4>
			<p><g:message code="fedreg.templates.serviceprovider.create.saml.shibboleth.descriptive" /></p>
			<table>
				<tr>
					<td/>
					<td><a href="#" onClick="$('#samlbasicmode').hide(); $('#samladvancedmode').fadeIn();"><g:message code="fedreg.templates.identityprovider.create.saml.shibboleth.switch.advanced" /></a></td>
				</tr>
				<tr>
					<td>
						<label for="hostname"><g:message code="label.host" /></label>
					</td>
					<td>
						<g:hasErrors bean="${entityDescriptor}">
							<div class="error"><g:renderErrors bean="${entityDescriptor}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="hostname" size="50" class="url"  value="${hostname}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.hostname' />
					</td>
				</tr>
			</table>
		</div>
		
		<div id="samladvancedmode">
			<h4><g:message code="fedreg.templates.serviceprovider.create.saml.advanced.heading" /></h4>
			<p><g:message code="fedreg.templates.serviceprovider.create.saml.advanced.descriptive" /></p>
			<table>
				<tr>
					<td/>
					<td><a href="#" onClick="$('#samladvancedmode').hide(); $('#samlbasicmode').fadeIn();"><g:message code="fedreg.templates.serviceprovider.create.saml.advanced.switch.shibboleth" /></a></td>
				</tr>
				<tr>
					<td>
						<label for="entity.identifier"><g:message code="label.entitydescriptor" /></label>
					</td>
					<td>
						<g:hasErrors bean="${entityDescriptor}">
							<div class="error"><g:renderErrors bean="${entityDescriptor}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="entity.identifier" size="75" class="required url"  value="${entityDescriptor?.entityID}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.entitydescriptor' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.acs.post.uri"><g:message code="label.acspostendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-POST</pre>
					</td>
					<td>
						<g:hasErrors bean="${httpPostACS}">
							<div class="error"><g:renderErrors bean="${httpPostACS}"as="list"/></div>
						</g:hasErrors>
						<g:hiddenField name="sp.acs.post.isdefault" value="true" />
						<g:textField name="sp.acs.post.uri" size="75" class="required url"  value="${httpPostACS?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.acspost' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.acs.artifact.uri"><g:message code="label.acsartifactendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-Artifact</pre>
					</td>
					<td>
						<g:hasErrors bean="${soapArtifactACS}">
							<div class="error"><g:renderErrors bean="${soapArtifactACS}"as="list"/></div>
						</g:hasErrors>
						<g:hiddenField name="sp.acs.artifact.isdefault" value="false" />
						<g:textField name="sp.acs.artifact.uri" size="75" class="required url" value="${soapArtifactACS?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.acsartifcate' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.slo.artifact.uri"><g:message code="label.sloartifactendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-Artifact</pre>
					</td>
					<td>
						<g:hasErrors bean="${sloArtifact}">
							<div class="error"><g:renderErrors bean="${sloArtifact}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.slo.artifact.uri" size="75" class="url" value="${sloArtifact?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.sloartifact' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.slo.redirect.uri"><g:message code="label.sloredirectendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-Redirect</pre>
					</td>
					<td>
						<g:hasErrors bean="${sloRedirect}">
							<div class="error"><g:renderErrors bean="${sloRedirect}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.slo.redirect.uri" size="75" class="url" value="${sloRedirect?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.sloredriect' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.slo.soap.uri"><g:message code="label.slosoapendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:SOAP</pre>
					</td>
					<td>
						<g:hasErrors bean="${sloSOAP}">
							<div class="error"><g:renderErrors bean="${sloSOAP}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.slo.soap.uri" size="75" class="url" value="${sloSOAP?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.slosoap' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.slo.post.uri"><g:message code="label.slopostendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-POST</pre>
					</td>
					<td>
						<g:hasErrors bean="${sloPost}">
							<div class="error"><g:renderErrors bean="${sloPost}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.slo.post.uri" size="75" class="url"  value="${sloPost?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.slopost' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.drs.uri"><g:message code="label.drsendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:profiles:SSO:idp-discovery-protocol</pre>
					</td>
					<td>
						<g:hasErrors bean="${discoveryResponseService}">
							<div class="error"><g:renderErrors bean="${discoveryResponseService}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.drs.uri" size="75" class="url" value="${discoveryResponseService?.location?.uri}"/>
						<g:hiddenField name="sp.drs.isdefault" value="true" />
						<fr:tooltip code='fedreg.help.serviceprovider.disco' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.mnid.artifact.uri"><g:message code="label.mnidartifactendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-Artifact</pre>
					</td>
					<td>
						<g:hasErrors bean="${mnidArtifact}">
							<div class="error"><g:renderErrors bean="${mnidArtifact}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.mnid.artifact.uri" size="75" class="url" value="${mnidArtifact?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.mnidaritfact' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.mnid.redirect.uri"><g:message code="label.mnidredirectendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-Redirect</pre>
					</td>
					<td>
						<g:hasErrors bean="${mnidRedirect}">
							<div class="error"><g:renderErrors bean="${mnidRedirect}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.mnid.redirect.uri" size="75" class="url" value="${mnidRedirect?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.mnidredirect' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.mnid.soap.uri"><g:message code="label.mnidsoapendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:SOAP</pre>
					</td>
					<td>
						<g:hasErrors bean="${mnidSOAP}">
							<div class="error"><g:renderErrors bean="${mnidSOAP}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.mnid.soap.uri" size="75" class="url" value="${mnidSOAP?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.mnidsoap' />
					</td>
				</tr>
				<tr>
					<td>
						<label for="sp.mnid.post.uri"><g:message code="label.mnidpostendpoint" /></label>
						<pre><g:message code="label.binding" />: SAML:2.0:bindings:HTTP-POST</pre>
					</td>
					<td>
						<g:hasErrors bean="${mnidPost}">
							<div class="error"><g:renderErrors bean="${mnidPost}"as="list"/></div>
						</g:hasErrors>
						<g:textField name="sp.mnid.post.uri" size="75" class="url" value="${mnidPost?.location?.uri}"/>
						<fr:tooltip code='fedreg.help.serviceprovider.mnidpost' />
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="step" id="crypto">
		<h3><g:message code="fedreg.templates.serviceprovider.create.crypto.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.crypto.details" />
		</p>
		<table>
			<tr>
				<td>
					<label for="newcertificatedata"><g:message code="label.certificate" /></label>
				</td>
				<td>
					<div id="newcertificatedetails">
					</div>
					<g:hiddenField name="sp.crypto.sig" value="${true}" />
					<g:hiddenField name="sp.crypto.enc" value="${true}" />
					<g:textArea name="cert" id="cert" rows="25" cols="60" value="${certificate}"/>
					<fr:tooltip code='fedreg.help.serviceprovider.certificate' />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="step" id="attributesupport">
		<h3><g:message code="fedreg.templates.serviceprovider.create.attributesupport.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.attributesupport.details" />
		</p>
		<table>
			<tbody>
				<tr>
					<th><g:message code="label.name" /></th>
					<th><g:message code="label.category" /></th>
					<th><g:message code="label.description" /></th>
					<th><g:message code="label.requested" /></th>
					<th><g:message code="label.required" /> <fr:tooltip code='fedreg.help.serviceprovider.attribute.isrequired' /></th>
					<th><g:message code="label.reasonrequested" /></th>
				</tr>
				<g:each in="${attributeList}" var="attr" status="i">
					<g:if test="${!attr.specificationRequired}">
						<g:set var="ra" value="${supportedAttributes.find {it.base == attr}}" />
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td>
								${fieldValue(bean: attr, field: "friendlyName")}<br>
								<pre>OID: ${fieldValue(bean: attr, field: "oid")}</pre>
							</td>
							<td>
								${fieldValue(bean: attr, field: "category.name")}
							</td>
							<td style="width: 300px;">
								${fieldValue(bean: attr, field: "description")}
							</td>
							<td>
								<g:checkBox name="sp.attributes.${attr.id}.requested" id="sp.attributes.${attr.id}.requested" onClick="\$('#spattributes${attr.id}reasoning').toggleClass('required');" checked="${ra}"/>
							</td>
							<td>
								<g:checkBox name="sp.attributes.${attr.id}.required" checked="${ra?.isRequired}"/>
							</td>
							<td>
								<input name="sp.attributes.${attr.id}.reasoning" id="spattributes${attr.id}reasoning" size="40" value="${ra?.reasoning}" class="tip" title="${g.message(code:'fedreg.help.serviceprovider.attribute.reason')}"/>
								<fr:tooltip code='fedreg.help.serviceprovider.attribute.reason' />
							</td>
						</tr>
					</g:if>
				</g:each>
			</tbody>
		</table>
	</div>
	
	<div class="step" id="specifiedattributesupport">
		<h3><g:message code="fedreg.templates.serviceprovider.create.specifiedattributesupport.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.specifiedattributesupport.details" />
		</p>
		<table>
			<tbody>
				<tr>
					<th><g:message code="label.name" /></th>
					<th><g:message code="label.description" /></th>
					<th><g:message code="label.requested" /></th>
					<th><g:message code="label.required" /></th>
					<th><g:message code="label.reasonrequested" /></th>
				</tr>
				<g:each in="${attributeList.sort{it.friendlyName}}" var="attr" status="i">
					<g:if test="${attr.specificationRequired}">
						<g:set var="ra" value="${supportedAttributes.find {it.base == attr}}" />
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td>
								${fieldValue(bean: attr, field: "friendlyName")}<br>
								<pre>OID: ${fieldValue(bean: attr, field: "oid")}</pre>
							</td>
							<td  style="width: 300px;">
								${fieldValue(bean: attr, field: "description")}
							</td>
							<td>
								<g:checkBox name="sp.attributes.${attr.id}.requested" onClick="\$('#spattributes${attr.id}reasoning').toggleClass('required'); \$('#spattributes${attr.id}requestedvalues1').toggleClass('required');" checked="${ra}"/>
							</td>
							<td>
								<g:checkBox name="sp.attributes.${attr.id}.required" checked="${ra?.isRequired}"/>
							</td>
							<td>
								<g:textField name="sp.attributes.${attr.id}.reasoning" id="spattributes${attr.id}reasoning" size="40" value="${ra?.reasoning}" class="tip" title="${g.message(code:'fedreg.help.serviceprovider.attribute.reason')}"/>
								<fr:tooltip code='fedreg.help.serviceprovider.attribute.reason' />
							</td>
						</tr>
						<tr>
							<td>
							<td colspan="4">
								<table>
									<tbody>
										<tr>
											<th>
												<g:message code="label.requestedvalues" />
											</th>
											<td colspan="4">
												<g:each in="${1..10}" var="v">
													<g:textField name="sp.attributes.${attr.id}.requestedvalues.${v}" id="spattributes${attr.id}requestedvalues${v}" size="40" />
													<fr:tooltip code='fedreg.help.serviceprovider.attribute.specvalue' /><br>
												</g:each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</g:if>
				</g:each>
			</tbody>
		</table>
	</div>
	
	<div class="step" id="nameidformatsupport">
		<h3><g:message code="fedreg.templates.serviceprovider.create.nameidformatsupport.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.nameidformatsupport.details" />
		</p>
		<p>
			<strong><g:message code="fedreg.templates.serviceprovider.create.nameidformatsupport.details.highlight" /></strong>
		</p>
		<table>
			<tr>
				<th><g:message code="label.name" /></th>
				<th><g:message code="label.description" /></th>
				<th><g:message code="label.supported" /></th>
			</tr>
			<g:each in="${nameIDFormatList.sort{it.uri}}" var="nameidformat" status="i">
			<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
				<td>
					${fieldValue(bean: nameidformat, field: "uri")}
				</td>
				<td>
					${fieldValue(bean: nameidformat, field: "description")}
				</td>
				<td>
					<g:checkBox name="sp.nameidformats.${nameidformat.id}"  checked="${nameidformat.uri == 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient' || supportedNameIDFormats?.contains(nameidformat)}"/>
				</td>
			</tr>
			</g:each>
		</table>
	</div>
	
	<div class="step submit_step" id="creationsummary">
		<h3><g:message code="fedreg.templates.serviceprovider.create.summary.heading" /></h3>
		<p>
			<g:message code="fedreg.templates.serviceprovider.create.summary.details" />
		</p>
	</div>

	<nav>
		<input id="back" value="${g.message(code:'label.back')}" type="reset" /> 
		<input id="next" value="${g.message(code:'label.next')}" type="submit" />
	</nav>

</g:form>