<cfcomponent name="TransferInserter" hint="TransferInserter for PostGresSQL" extends="transfer.com.sql.TransferInserter">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="TransferInserter" output="false">
	<cfargument name="datasource" hint="The datasource BO" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="utility" hint="The utility class" type="transfer.com.util.Utility" required="Yes">
	<cfargument name="nullable" hint="The nullable class" type="transfer.com.sql.Nullable" required="Yes">
	<cfargument name="transaction" hint="handles transactions" type="transfer.com.sql.Transaction" required="Yes">
	<cfscript>
		super.init(arguments.datasource,arguments.objectManager, arguments.utility, arguments.nullable, arguments.transaction);

		return this;
	</cfscript>
</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="sqlBeforeInsert" hint="Selects the ID using select nextval()" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The object that is being inserted" type="transfer.com.object.Object" required="Yes">
	<cfreturn "select nextval('" & arguments.object.getSequence() & "') as id">
</cffunction>

</cfcomponent>