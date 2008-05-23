<!--- Document Information -----------------------------------------------------

Title:      LazyLoadWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Writes the code for lazy loading functionality

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/07/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="LazysWriter" hint="Writes the code for lazy loading functionality" extends="AbstractBaseWriter">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="LazyLoadWriter" output="false">
	<cfargument name="objectManager" hint="The Object Manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		super.init(objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeLazyLoad" hint="Writes the lazy load functions" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.object.getManyToManyIterator();
		//var qExternalOneToMany = getObjectManager().getClass NameByOneToManyLinkTo(arguments.object.getClassName());

		var manytomany = 0;
		var onetomany = 0;
		var manytoone = 0;
		var parentOneToMany = 0;
		var parentObject = 0;

		while(iterator.hasNext())
		{
			manytomany = iterator.next();
			writeIsLoaded(arguments.buffer, manytomany.getName());
			writeLoadManyToMany(arguments.buffer, arguments.object, manytomany);
		}

		iterator = arguments.object.getOneToManyIterator();
		while(iterator.hasNext())
		{
			onetomany = iterator.next();
			writeIsLoaded(arguments.buffer, onetomany.getName());
			writeLoadOneToMany(arguments.buffer, arguments.object, onetomany);
		}

		iterator = arguments.object.getManyToOneIterator();

		while(iterator.hasNext())
		{
			manytoone = iterator.next();
			writeIsLoaded(arguments.buffer, manytoone.getName());
			writeLoadManytoOne(arguments.buffer, arguments.object, manytoone);
		}

		iterator = arguments.object.getParentOneToManyIterator();

		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();

			parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

			writeIsLoaded(arguments.buffer, "Parent" & parentObject.getObjectName());
			writeLoadExternalOnetoMany(arguments.buffer, arguments.object, parentObject.getObjectName(), parentObject.getClassName());
		}
	</cfscript>
<!---	<cfloop query="qExternalOneToMany">
		<cfscript>
			parentObject = getObjectManager().getObject(className);

			writeIsLoaded(arguments.buffer, "Parent" & parentObject.getObjectName());
			writeLoadExternalOnetoMany(arguments.buffer, arguments.object, parentObject.getObjectName(), className);
		</cfscript>
	</cfloop> --->
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeLoadManyToOne" hint="Writes the lazy load functions" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manytoone" hint="The one to many object" type="transfer.com.object.manytoone" required="Yes">
	<cfscript>
		writeLoad(arguments.buffer, arguments.object, arguments.manytoone.getName(), "loadManyToOne");
	</cfscript>
</cffunction>

<cffunction name="writeLoadOneToMany" hint="Writes the lazy load functions" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="onetomany" hint="The one to many object" type="transfer.com.object.onetomany" required="Yes">
	<cfscript>
		writeLoad(arguments.buffer, arguments.object, arguments.onetomany.getName(), "loadOneToMany");
	</cfscript>
</cffunction>

<cffunction name="writeLoadManyToMany" hint="Writes the lazy load functions" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manytomany" hint="The one to many object" type="transfer.com.object.manytomany" required="Yes">
	<cfscript>
		writeLoad(arguments.buffer, arguments.object, arguments.manytomany.getName(), "loadManyToMany");
	</cfscript>
</cffunction>

<cffunction name="writeLoadExternalOnetoMany" hint="writes the lazy load function for external one to may" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="name" hint="The name of the external collection" type="string" required="Yes">
	<cfargument name="className" hint="The className of the external collection" type="string" required="Yes">
	<cfscript>
		writeLoad(arguments.buffer, arguments.object, "Parent" & arguments.name, "loadParentOneToMany");
	</cfscript>
</cffunction>

<cffunction name="writeLoad" hint="Generic load() function writer" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="name" hint="The name of the compostion" type="string" required="Yes">
	<cfargument name="loadMethod" hint="The method to call to load from Transfer.cfc" type="string" required="Yes">
	<cfscript>
		//tell transfer.
		arguments.buffer.writeCFFunctionOpen("load" & arguments.name, "private", "void");

			arguments.buffer.writeDoubleCheckLockOpen("NOT get" & arguments.name & "isLoaded()",
							"transfer.load." & arguments.object.getClassName() & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
			arguments.buffer.cfscript(true);

				arguments.buffer.writeLine("getTransfer().#arguments.loadMethod#(getThisObject(), "& q()& arguments.name & q()&");");

			arguments.buffer.cfscript(false);
			arguments.buffer.writeDoubleCheckLockClose();

		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeIsLoaded" hint="Writes the set of get/set IsLoaded Methods" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="name" hint="The name of the collection" type="string" required="Yes">

	<cfscript>
		arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "isLoaded", "package", "boolean");
		arguments.buffer.cfscript("true");
		arguments.buffer.writeLine("if(NOT StructKeyExists(getLoaded(), " & q() & arguments.name & q() &"))");
		arguments.buffer.writeLine("{");
		arguments.buffer.writeLine("set" & arguments.name & "isLoaded(false);");
		arguments.buffer.writeLine("}");
		arguments.buffer.writeline("return StructFind(getLoaded(), " & q() & arguments.name & q() &");");
		arguments.buffer.cfscript("false");
		arguments.buffer.writeCFFunctionClose();


		arguments.buffer.writeCFFunctionOpen("set" & arguments.name & "isLoaded", "private" ,"void");
		arguments.buffer.writeCFArgument("loaded", "boolean", true);
		arguments.buffer.cfScript(true);
		arguments.buffer.writeLine("StructInsert(getLoaded(), " & q() & arguments.name & q() &", arguments.loaded, true);");
		arguments.buffer.cfScript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

</cfcomponent>