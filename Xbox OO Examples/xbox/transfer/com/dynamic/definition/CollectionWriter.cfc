<!--- Document Information -----------------------------------------------------

Title:      CollectionWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Writes out the collection/composition aspects of the defition

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/04/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="CollectionWriter" hint="Writes out the collection/composition aspects of the defition" extends="AbstractBaseWriter">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="CollectionWriter" output="false">
	<cfargument name="objectManager" hint="The Object Manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		super.init(objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeManyToOne" hint="Writes the definition for Many to One." access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.object.getManyToOneIterator();
		var manyToOne = 0;

		while(iterator.hasNext())
		{
			manyToOne = iterator.next();

			//get
			arguments.buffer.writeCFFunctionOpen("get" & manyToOne.getName(), "public", "transfer.com.TransferObject");
			arguments.buffer.cfscript(true);

			//lazy loading
			arguments.buffer.writeLazyLoad(manytoone.getName());

			arguments.buffer.writeLine("if(NOT structKeyExists(instance, " & q() & manyToOne.getName() & q() & "))");
			arguments.buffer.writeLine("{");
			arguments.buffer.writeLine(	"throw("& q() &"ManyToOneNotSetException"& q() &","&
										q() & "A ManyToOne TransferObject has not been initialised."& q() &","&
										q() & "In TransferObject '"& arguments.object.getClassName() &"' manytoone '"& manytoone.getLink().getTo() &"' is not set."& q() &");");
			arguments.buffer.writeLine("}");
			arguments.buffer.writeLine("return instance." & manyToOne.getName() & ";");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			//set
			arguments.buffer.writeCFFunctionOpen("set" & manyToOne.getName(), "public", "void");
			arguments.buffer.writeCFArgument("transfer", "transfer.com.TransferObject", true);
			arguments.buffer.cfscript(true);

			arguments.buffer.writeTransferClassCheck("arguments.transfer", manyToOne.getLink().getTo());
			arguments.buffer.writeLine("if(NOT StructKeyExists(instance, " & q() & manyToOne.getName() & q() & ") OR NOT get" & manyToOne.getName() & "().equalsTransfer(arguments.transfer))");
			arguments.buffer.writeLine("{");
			arguments.buffer.writeLine("instance." & manyToOne.getName() & " = arguments.transfer;");
			arguments.buffer.writeSetIsDirty(true);
			arguments.buffer.writeSetIsLoaded(manyToOne.getName(), true);
			arguments.buffer.writeLine("}");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			arguments.buffer.writeCFFunctionOpen("has" & manyToOne.getName(), "public", "boolean");
			arguments.buffer.cfscript(true);
			arguments.buffer.writeLazyLoad(manytoone.getName());
			arguments.buffer.writeLine("return StructKeyExists(instance," & q() & manyToOne.getName() &  q() & ");");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			arguments.buffer.writeCFFunctionOpen("remove" & manyToOne.getName(), "public", "void");
			arguments.buffer.cfscript(true);
			arguments.buffer.writeLine("if(has"& manyToOne.getName() &"())");
			arguments.buffer.writeLine("{");
			arguments.buffer.writeLine("StructDelete(instance," & q() & manyToOne.getName() &  q() & ");");
			arguments.buffer.writeSetIsDirty(true);
			arguments.buffer.writeLine("}");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

		}
	</cfscript>
</cffunction>

<cffunction name="writeManyToMany" hint="Writes the definition for Many to Many files" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.object.getManyToManyIterator();
		var manyToMany = 0;
		var linkObject = 0;

		while(iterator.hasNext())
		{
			manyToMany = iterator.next();
			linkObject = getObjectManager().getObject(manyToMany.getLinkTo().getTo());

			writeCollection(arguments.buffer, manyToMany.getName(), manyToMany.getCollection() ,linkObject);
			writeRemoveAddAndClear(arguments.buffer, arguments.object, manyToMany.getName(), manyToMany.getCollection() ,linkObject, "public");

			if(manytomany.getCollection().getType() eq "array")
			{
				writeSort(arguments.buffer, arguments.object, manytomany.getName(), manytomany.getLinkTo(), manytomany.getCollection());
			}
		}
	</cfscript>
</cffunction>

<cffunction name="writeOneToMany" hint="writes the defintion of One to Many files" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.object.getOneToManyIterator();
		var oneToMany = 0;
		var linkObject = 0;

		while(iterator.hasNext())
		{
			oneToMany = iterator.next();
			linkObject = getObjectManager().getObject(oneToMany.getLink().getTo());

			writeCollection(arguments.buffer, oneToMany.getName(), oneToMany.getCollection() ,linkObject);
			writeRemoveAddAndClear(arguments.buffer, arguments.object, oneToMany.getName(), oneToMany.getCollection() ,linkObject, "package");
			if(onetomany.getCollection().getType() eq "array")
			{
				writeSort(arguments.buffer, arguments.object, onetomany.getName(), onetomany.getLink(), onetomany.getCollection(), "public");
			}
		}
	</cfscript>
</cffunction>

<cffunction name="writeExternalOneToMany" hint="write the methods for where this object hook into a one to many" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		//var qObjects = getObjectManager().getClassNameByOne ToManyLinkTo(object.getClassName());
		var parentObject = 0;
		var primaryKey = 0;
		var iterator = arguments.object.getParentOneToManyIterator();
		var parentOneToMany = 0;

		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();

			parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());
			primaryKey = parentObject.getPrimaryKey();

			arguments.buffer.writeCFFunctionOpen("getParent" & parentObject.getObjectName(), "public", "transfer.com.TransferObject");
			arguments.buffer.cfscript(true);
			arguments.buffer.writeLazyLoad("Parent" & parentObject.getObjectName());
			arguments.buffer.writeLine("if(NOT structKeyExists(instance, " & q() & parentObject.getObjectName() & q() & "))");
			arguments.buffer.writeLine("{");
			arguments.buffer.writeLine(	"throw("& q() &"OneToManyParentNotSetException"& q() &","&
										q() & "A OneToMany Parent TransferObject has not been initialised."& q() &","&
										q() & "In TransferObject '"& arguments.object.getClassName() &"' onetomany parent '"& parentObject.getClassName() &"' is not set."& q() &");");
			arguments.buffer.writeLine("}");
			arguments.buffer.writeLine("return instance." & parentObject.getObjectName() & ";");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			//set
			arguments.buffer.writeCFFunctionOpen("setParent" & parentObject.getObjectName(), "public", "void");
			arguments.buffer.writeCFArgument("transfer", "transfer.com.TransferObject", true);
			arguments.buffer.writeCFArgument("loadChildren", "boolean", false, true);
			arguments.buffer.cfscript(true);

				arguments.buffer.writeTransferClassCheck("arguments.transfer", parentObject.getClassName());

				arguments.buffer.writeLine("if(NOT getParent" & parentObject.getObjectName() & "IsLoaded() OR NOT hasParent" & parentObject.getObjectName() & "() OR NOT getParent" & parentObject.getObjectName() & "().equalsTransfer(arguments.transfer))");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("if(getParent" & parentObject.getObjectName() & "IsLoaded() AND hasParent"  & parentObject.getObjectName() & "())");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("removeParent" & parentObject.getObjectName() & "();");
					arguments.buffer.writeLine("}");

					arguments.buffer.writeLine("instance." & parentObject.getObjectName() & " = arguments.transfer;");
					arguments.buffer.writeSetIsLoaded("Parent" & parentObject.getObjectName(), true);
					arguments.buffer.writeSetIsDirty(true);
				arguments.buffer.writeLine("}");
				arguments.buffer.writeLine("else if(NOT getParent" & parentObject.getObjectName() & "().sameTransfer(arguments.transfer))");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("instance." & parentObject.getObjectName() & " = arguments.transfer;");
				arguments.buffer.writeLine("}");

				arguments.buffer.append("if(arguments.loadChildren");
				arguments.buffer.writeLine(" AND NOT getParent" & parentObject.getObjectName() & "().getOriginalTransferObject().get"& parentOneToMany.getName() &"IsLoaded())");
				arguments.buffer.writeLine("{");
				/*
				just grab an iterator (which we always have), so it loads. It's a bit iffy, but I'm happy with it.
				there were just too many issues with trying to boolean resolve so the contains would fire.
				This tells a better story
				*/
				arguments.buffer.writeLine("getParent" & parentObject.getObjectName() & "().get"& parentOneToMany.getName() & "Iterator();");
				arguments.buffer.writeLine("}");

				//this may or may not be here, as it may be lazy loaded
				arguments.buffer.append("if(getParent" & parentObject.getObjectName() & "().getOriginalTransferObject().get"& parentOneToMany.getName() &"IsLoaded()");
				arguments.buffer.writeLine("AND NOT getParent" & parentObject.getObjectName() & "().contains"& parentOneToMany.getName() &"(getThisObject()))");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("getParent" & parentObject.getObjectName() & "().getOriginalTransferObject().add" & parentOneToMany.getName() & "(getThisObject());");
				arguments.buffer.writeLine("}");

			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			//has
			arguments.buffer.writeCFFunctionOpen("hasParent" & parentObject.getObjectName(), "public", "boolean");
			arguments.buffer.cfscript(true);
			arguments.buffer.writeLazyLoad("Parent" & parentObject.getObjectName());
			arguments.buffer.writeLine("return StructKeyExists(instance," & q() & parentObject.getObjectName() &  q() & ");");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();

			//remove
			arguments.buffer.writeCFFunctionOpen("removeParent" & parentObject.getObjectName(), "public", "void");
			arguments.buffer.cfscript(true);
			arguments.buffer.writeLazyLoad("Parent" & parentObject.getObjectName());
			arguments.buffer.writeLine("if(hasParent"& parentObject.getObjectName() &"())");
			arguments.buffer.writeLine("{");
			arguments.buffer.writeLine("getParent" & parentObject.getObjectName() & "().getOriginalTransferObject().remove" & parentOneToMany.getName() & "(getThisObject());");
			arguments.buffer.writeLine("StructDelete(instance," & q() & parentObject.getObjectName() &  q() & ");");
			arguments.buffer.writeSetIsDirty(true);
			arguments.buffer.writeLine("}");
			arguments.buffer.cfscript(false);
			arguments.buffer.writeCFFunctionClose();
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeCollection" hint="Writes the methods for a collection" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="name" hint="The name of the collection" type="string" required="Yes">
	<cfargument name="collection" hint="The Collection of the composite type" type="transfer.com.object.Collection" required="Yes">
	<cfargument name="linkObject" hint="The Object the link points to" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		//getter and setter for the array/struct
		arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "Collection", "private", arguments.collection.getType());
		arguments.buffer.writeCFScriptBlock("return instance." & arguments.name & ";");
		arguments.buffer.writeCFFunctionClose();

		arguments.buffer.writeCFFunctionOpen("set" & arguments.name & "Collection", "private", "void");
		arguments.buffer.writeCFArgument(arguments.name, arguments.collection.getType(), true);
		arguments.buffer.writeCFScriptBlock("instance." & arguments.name & " = arguments." & arguments.name & ";");
		arguments.buffer.writeCFFunctionClose();

		switch(arguments.collection.getType())
		{
			//do array functions
			case "array":

				//get
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name, "public", "transfer.com.TransferObject");
				arguments.buffer.writeCFArgument("index", "numeric", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLazyLoad(arguments.name);
					//have to subtract 1, as 0 indexed off the 'get'
					arguments.buffer.writeline("return get"& arguments.name&"Collection().get(JavaCast("& q() & "int" & q() &", arguments.index - 1));");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//get Array
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "Array", "public", "array");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var array = ArrayNew(1);");
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("array.addAll(get"& arguments.name&"Collection());");
					arguments.buffer.writeLine("return array;");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//iterator
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "Iterator", "public", "any");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeline("return get"& arguments.name&"Array().iterator();");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//contains
				arguments.buffer.writeCFFunctionOpen("contains" & arguments.name, "public", "boolean");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var iterator = 0;");
					arguments.buffer.writeLine("var composite = 0;");
					arguments.buffer.writeLazyLoad(arguments.name);

					arguments.buffer.writeLine("iterator = get"& arguments.name & "Collection().iterator();");

					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLine("while(iterator.hasNext())");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("composite = iterator.next();");
						arguments.buffer.writeLine("if(composite.equalsTransfer(arguments.object))");
						arguments.buffer.writeLine("{");
							arguments.buffer.writeLine("return true;");
						arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("return false;");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//find
				arguments.buffer.writeCFFunctionOpen("find" & arguments.name, "public", "numeric");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var iterator = 0;");
					arguments.buffer.writeLine("var composite = 0;");
					arguments.buffer.writeLine("var counter = 0;");
					arguments.buffer.writeLazyLoad(arguments.name);

					arguments.buffer.writeLine("iterator = get"& arguments.name & "Collection().iterator();");

					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLine("while(iterator.hasNext())");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("composite = iterator.next();");
						arguments.buffer.writeLine("counter = counter + 1;");
						arguments.buffer.writeLine("if(composite.equalsTransfer(arguments.object))");
						arguments.buffer.writeLine("{");
							arguments.buffer.writeLine("return counter;");
						arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("return -1;");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

			break;

			//do struct functions
			case "struct":
				//get
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name, "public", "transfer.com.TransferObject");
				arguments.buffer.writeCFArgument("key", "string", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeline("return StructFind(get" & arguments.name & "Collection(), arguments.key);");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//get Struct
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "Struct", "public", "struct");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var struct = StructNew();");
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("struct.putAll(get" & arguments.name & "Collection());");
					arguments.buffer.writeLine("return struct;");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//iterator
				arguments.buffer.writeCFFunctionOpen("get" & arguments.name & "Iterator", "public", "any");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeline("return get"& arguments.name&"Struct().values().iterator();");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//contains
				arguments.buffer.writeCFFunctionOpen("contains" & arguments.name, "public", "boolean");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var struct = 0;");
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("struct = get" & arguments.name & "Struct();");
					arguments.buffer.writeLine("if(StructKeyExists(struct, arguments.object.get"& arguments.collection.getKey().getProperty() &"()))");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("return struct[arguments.object.get"& arguments.collection.getKey().getProperty() &"()].equalsTransfer(arguments.object);");
					arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("return false;");

					//arguments.buffer.writeLine("return StructKeyExists(get" & arguments.name & "Collection(), );");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

				//find
				arguments.buffer.writeCFFunctionOpen("find" & arguments.name, "public", "string");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLine("if(contains" & arguments.name & "(arguments.object))");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("return arguments.object.get"& arguments.collection.getKey().getProperty() &"();");
					arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("return " & q() & q() & ";");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeCFFunctionClose();

			break;
		}
	</cfscript>
</cffunction>

<cffunction name="writeRemoveAddAndClear" hint="Writes the remove function" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="name" hint="The name of the collection" type="string" required="Yes">
	<cfargument name="collection" hint="The Collection of the composite type" type="transfer.com.object.Collection" required="Yes">
	<cfargument name="linkObject" hint="The Object the link points to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="scope" hint="Private, or public?" type="string" required="Yes">

	<cfscript>
		switch(arguments.collection.getType())
		{
			case "array":
				//add
				arguments.buffer.writeCFFunctionOpen("add" & arguments.name, arguments.scope, "void");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("ArrayAppend(get" & arguments.name & "Collection(), arguments.object);");

					//only do if scope is public
					if(scope eq "public")
					{
						arguments.buffer.writeSetIsDirty(true);
					}

				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();
				arguments.buffer.writeCFFunctionClose();

				//remove
				arguments.buffer.writeCFFunctionOpen("remove" & arguments.name, arguments.scope, "void");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("var iterator = 0;");
					arguments.buffer.writeLine("var composite = 0;");
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
				arguments.buffer.cfscript(false);

				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("iterator = get"& arguments.name & "Collection().iterator();");
					arguments.buffer.writeLine("while(iterator.hasNext())");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("composite = iterator.next();");
						arguments.buffer.writeLine("if(composite.equalsTransfer(arguments.object))");
						arguments.buffer.writeLine("{");
							arguments.buffer.writeLine("iterator.remove();");

							//only do if scope is public
							if(scope eq "public")
							{
								arguments.buffer.writeSetIsDirty(true);
							}

							arguments.buffer.writeLine("return;");
						arguments.buffer.writeLine("}");
					arguments.buffer.writeLine("}");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();

				arguments.buffer.writeCFFunctionClose();

				//clear
				arguments.buffer.writeCFFunctionOpen("clear" & arguments.name, arguments.scope, "void");

				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeLine("ArrayClear(get" & arguments.name & "Collection());");
					//only do if scope is public
					if(scope eq "public")
					{
						arguments.buffer.writeSetIsDirty(true);
						arguments.buffer.writeSetIsLoaded(arguments.name, true);
					}
				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();
				arguments.buffer.writeCFFunctionClose();
			break;

			case "struct":
				//add
				arguments.buffer.writeCFFunctionOpen("add" & arguments.name, arguments.scope, "void");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);

				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLazyLoad(arguments.name);
					arguments.buffer.writeLine("StructInsert(get" & arguments.name & "Collection(), arguments.object.get" & arguments.collection.getKey().getProperty() &"(), arguments.object, true);");
					//only do if scope is public
					if(scope eq "public")
					{
						arguments.buffer.writeSetIsDirty(true);
					}
				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();
				arguments.buffer.writeCFFunctionClose();

				//remove
				arguments.buffer.writeCFFunctionOpen("remove" & arguments.name, arguments.scope, "void");
				arguments.buffer.writeCFArgument("object", "transfer.com.TransferObject", true);
				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeTransferClassCheck("arguments.object", arguments.linkObject.getClassName());
					arguments.buffer.writeLine("if(contains" & arguments.name & "(arguments.object))");
					arguments.buffer.writeLine("{");
						arguments.buffer.writeLine("structDelete(get"& arguments.name & "Collection(), arguments.object.get"& arguments.collection.getKey().getProperty() &"());");
						//only do if scope is public
						if(scope eq "public")
						{
							arguments.buffer.writeSetIsDirty(true);
						}
					arguments.buffer.writeLine("}");
				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();
				arguments.buffer.writeCFFunctionClose();

				//clear
				arguments.buffer.writeCFFunctionOpen("clear" & arguments.name, arguments.scope, "void");
				arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
				arguments.buffer.cfscript(true);
					arguments.buffer.writeline("StructClear(get" & arguments.name & "Collection());");
					//only do if scope is public
					if(scope eq "public")
					{
						arguments.buffer.writeSetIsDirty(true);
						arguments.buffer.writeSetIsLoaded(arguments.name, true);
					}
				arguments.buffer.cfscript(false);
				arguments.buffer.writeNamedLockClose();
				arguments.buffer.writeCFFunctionClose();
			break;
		}
	</cfscript>
</cffunction>

<cffunction name="writeSort" hint="writes the sorting functions for a composite object collection" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="name" hint="The name of the collection" type="string" required="Yes">
	<cfargument name="linkTo" hint="The type of object the collection is made of" type="transfer.com.object.Link" required="Yes">
	<cfargument name="collection" hint="The collection that is being written" type="transfer.com.object.Collection" required="Yes">
	<cfargument name="scope" hint="public, or private" type="string" required="No" default="public">
	<cfscript>
		var sortProperty = 0;
		var order = "asc";
		var linkObject = getObjectManager().getObject(arguments.linkTo.getTo());

		if(arguments.collection.hasOrder())
		{
			sortProperty = linkObject.getPropertyByName(arguments.collection.getOrder().getProperty());
			order = arguments.collection.getOrder().getOrder();
		}
		else
		{
			sortProperty = linkObject.getPrimaryKey();
		}

		//sort function
		arguments.buffer.writeCFFunctionOpen("sort" & arguments.name, arguments.scope, "void");

		arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.name & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");
		arguments.buffer.cfscript(true);
		arguments.buffer.writeLine("if(NOT " & collection.getType() &"isEmpty(get"&arguments.name&"Collection()))");
		arguments.buffer.writeLine("{");
			arguments.buffer.writeline("set"&arguments.name&"Collection(getUtility().quickSort(get"& arguments.name &"Collection(), "& arguments.name &"Comparator));");
		arguments.buffer.writeLine("}");
		arguments.buffer.cfscript(false);
		arguments.buffer.writeNamedLockClose();

		arguments.buffer.writeCFFunctionClose();

		arguments.buffer.writeCFFunctionOpen(arguments.name & "Comparator", "private", "numeric");
		arguments.buffer.writeCFArgument("object1", "transfer.com.TransferObject", true);
		arguments.buffer.writeCFArgument("object2", "transfer.com.TransferObject", true);
		arguments.buffer.cfscript(true);
		arguments.buffer.writeLine("if(arguments.object1.get"& sortProperty.getName() &"() lt arguments.object2.get"& sortProperty.getName() &"())");
		arguments.buffer.writeLine("{");
		if(order eq "asc")
		{
			arguments.buffer.writeLine("return -1;");
		}
		else
		{
			arguments.buffer.writeLine("return 1;");
		}

		arguments.buffer.writeLine("}");
		arguments.buffer.writeLine("else if(arguments.object1.get"& sortProperty.getName() &"() gt arguments.object2.get"& sortProperty.getName() &"())");
		arguments.buffer.writeLine("{");
		if(order eq "asc")
		{
			arguments.buffer.writeLine("return 1;");
		}
		else
		{
			arguments.buffer.writeLine("return -1;");
		}
		arguments.buffer.writeLine("}");
		arguments.buffer.writeLine("return 0;");
		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

</cfcomponent>