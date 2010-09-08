package fedreg.core

import org.apache.shiro.SecurityUtils

class OrganizationController {

	def organizationService

	static allowedMethods = [save: "POST", update: "POST"]

	def index = {
		redirect(action: "list", params: params)
	}

	def list = {
		params.max = Math.min(params.max ? params.max.toInteger() : 20, 100)
		[organizationList: Organization.list(params), organizationTotal: Organization.count()]
	}

	def show = {
		if(!params.id) {
			log.warn "Organization ID was not present"
			flash.type="error"
			flash.message = message(code: 'fedreg.controllers.namevalue.missing')
			redirect(action: "list")
			return
		}
		
		def organization = Organization.get(params.id)
		if (!organization) {
			flash.type="error"
			flash.message = message(code: 'fedreg.core.organization.nonexistant')
			redirect(action: "list")
		}
		else {
			def entities = EntityDescriptor.findAllWhere(organization:organization)
			def contacts = Contact.findAllWhere(organization:organization)
			[organization: organization, entities:entities, contacts:contacts]
		}
	}
	
	def create = {
		if(SecurityUtils.subject.isPermitted("organization:create")) {
			def organization = new Organization()
			[organization:organization, organizationTypes: OrganizationType.list()]
		}
		else {
			log.warn("Attempt to create organization by $authenticatedUser was denied, incorrect permission set")
			response.sendError(403)
		}
	}
	
	def save = {
		if(SecurityUtils.subject.isPermitted("organization:create")) {
			def (created, organization, contact) = organizationService.create(params)
		
			if(created)
				redirect (action: "show", id: organization.id)
			else
				render (view:'create', model:[organization:organization, contact:contact])
		}
		else {
			log.warn("Attempt to save organization by $authenticatedUser was denied, incorrect permission set")
			response.sendError(403)
		}
	}
	
	def edit = {
		if(!params.id) {
			log.warn "Organization ID was not present"
			flash.type="error"
			flash.message = message(code: 'fedreg.controllers.namevalue.missing')
			redirect(action: "list")
			return
		}
		
		def organization = Organization.get(params.id)
		if (!organization) {
			flash.type="error"
			flash.message = message(code: 'fedreg.core.organization.nonexistant')
			redirect(action: "list")
			return
		}	
		
		if(SecurityUtils.subject.isPermitted("organization:${organization.id}:update")) {
			[organization: organization, organizationTypes: OrganizationType.list()]	
		}
		else {
			log.warn("Attempt to edit $organization by $authenticatedUser was denied, incorrect permission set")
			response.sendError(403)
		}
	}
	
	def update = {
		if(!params.id) {
			log.warn "Organization ID was not present"
			flash.type="error"
			flash.message = message(code: 'fedreg.controllers.namevalue.missing')
			redirect(action: "list")
			return
		}
		
		def organization_ = Organization.get(params.id)
		if (!organization_) {
			flash.type="error"
			flash.message = message(code: 'fedreg.core.organization.nonexistant')
			redirect(action: "list")
			return
		}
		
		if(SecurityUtils.subject.isPermitted("organization:${organization_.id}:update")) {
			def (updated, organization) = organizationService.update(params)
			if(updated)
				redirect (action: "show", id: organization.id)
			else {
				flash.type="error"
				flash.message = message(code: 'fedreg.core.organization.update.validation.error')
				render (view:'edit', model:[organization:organization, organizationTypes: OrganizationType.list()])
			}
		}
		else {
			log.warn("Attempt to update $organization_ by $authenticatedUser was denied, incorrect permission set")
			response.sendError(403)
		}
	}

}
