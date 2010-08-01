package fedreg.core

class OrganizationController {

	def organizationService

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

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
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'organization.label'), params.id])}"
			redirect(action: "list")
		}
		else {
			def entities = EntityDescriptor.findAllWhere(organization:organization)
			def contacts = Contact.findAllWhere(organization:organization)
			[organization: organization, entities:entities, contacts:contacts]
		}
	}
	
	def create = {
		def organization = new Organization()
		[organization:organization, organizationTypes: OrganizationType.list()]
	}
	
	def save = {
		def (created, organization, contact) = organizationService.create(params)
		
		if(created)
			redirect (action: "show", id: organization.id)
		else
			render (view:'create', model:[organization:organization, contact:contact])
	}

}
