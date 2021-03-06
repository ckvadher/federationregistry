package aaf.fr.foundation

/**
 * @author Bradley Beddoes
 */
class PDPDescriptor extends RoleDescriptor {
	static auditable = true
	
	static belongsTo = [entityDescriptor:EntityDescriptor]

	static hasMany = [
		authzServices: AuthzService,
		assertionIDRequestServices: AssertionIDRequestService,
		nameIDFormats: String
	]

	static constraints = {
		assertionIDRequestServices(nullable: true)
		nameIDFormats(nullable: true)
	}
	
	public String toString() {	"pdpdescriptor:[id:$id, displayName: $displayName]" }
	
	public boolean functioning() {
		( !archived && active && approved && entityDescriptor.functioning() )
	}
}
