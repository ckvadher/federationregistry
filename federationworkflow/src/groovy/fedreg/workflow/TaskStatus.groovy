package fedreg.workflow

public enum TaskStatus {
	PENDING,
	INITIATING,
	APPROVALREQUIRED,
	APPROVALFAILURE,
	APPROVALGRANTED,
	APPROVALREJECTED,
	INPROGRESS,
	COMPLETED,
	CANCELLED
}
