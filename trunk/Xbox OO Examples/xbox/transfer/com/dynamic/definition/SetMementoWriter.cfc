<!--- Document Information -----------------------------------------------------

Title:      GetMementoWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Writes the setMemento part of the Defintion

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/04/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="SetMementoWriter" hint="Writes the memento part of the Defintion" extends="AbstractBaseWriter">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="SetMementoWriter" output="false">
	<cfargument name="objectManager" hint="The Object Manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		super.init(objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeSetMemento" hint="Writes the setMemento function" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var primaryKey = arguments.object.getPrimaryKey();
		var manytoone = 0;
		var onetomany = 0;
		var manytomany = 0;
		var linkObject = 0;
		var parentOneToMany = 0;
		var parentObject = 0;

		arguments.buffer.writeCFFunctionOpen("setMemento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "struct", true);
		arguments.buffer.cfscript(true);

		//default var item for general usage
		arguments.buffer.writeLine("var composite = 0;");

		//id - this may be from a clone, or a data sync
		arguments.buffer.writeLine("if(NOT getIsPersisted())");
		arguments.buffer.writeLine("{");
			writePropertySet(arguments.buffer, primaryKey);
		arguments.buffer.writeLine("}");

		arguments.buffer.writeLine("setPropertyMemento(arguments.memento);");

		//do many to one
		iterator = arguments.object.getManyToOneIterator();
		while(iterator.hasNext())
		{
			manytoone = iterator.next();
			arguments.buffer.writeSetIsLoaded(manytoone.getName(), false);
			if(NOT manytoone.getIsLazy())
			{
				//check if the key exists first
				arguments.buffer.writeLine("if(StructKeyExists(arguments.memento, "& q() & manytoone.getName() & q() &"))");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = arguments.memento." & manytoone.getName() & ";");
				arguments.buffer.writeLine("}");
				arguments.buffer.writeLine("else");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = StructNew();");
				arguments.buffer.writeLine("}");

				arguments.buffer.writeLine("set" & manytoone.getName() & "Memento(composite);");

			}
		}

		//do many to many
		iterator = arguments.object.getManyToManyIterator();
		while(iterator.hasNext())
		{
			manytomany = iterator.next();
			arguments.buffer.writeSetIsLoaded(manytomany.getName(), false);

			if(NOT manytomany.getIsLazy())
			{
				arguments.buffer.writeLine("if(structKeyExists(arguments.memento, " & q() & manytomany.getName() & q() & "))");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = arguments.memento." & manytomany.getName() & ";");
				arguments.buffer.writeLine("}");
				arguments.buffer.writeLine("else");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = ArrayNew(1);");
				arguments.buffer.writeLine("}");

				arguments.buffer.writeLine("set" & manytomany.getName() & "Memento(composite);");
			}
		}

		/** external one to many links **/
		iterator = arguments.object.getParentOneToManyIterator();
		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();
			parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

			arguments.buffer.writeSetIsLoaded("Parent" & parentObject.getObjectName(), false);
			arguments.buffer.writeLine("setParent" & parentObject.getObjectName() & "Memento(memento, false);");
		}

		//do one to many
		iterator = arguments.object.getOneToManyIterator();
		while(iterator.hasNext())
		{
			onetomany = iterator.next();
			arguments.buffer.writeSetIsLoaded(onetomany.getName(), false);

			if(NOT onetomany.getIsLazy())
			{
				arguments.buffer.writeLine("if(structKeyExists(arguments.memento, " & q() & onetomany.getName() & q() & "))");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = arguments.memento." & onetomany.getName() & ";");
				arguments.buffer.writeLine("}");
				arguments.buffer.writeLine("else");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = ArrayNew(1);");
				arguments.buffer.writeLine("}");

				arguments.buffer.writeLine("set" & onetomany.getName() & "Memento(composite);");
			}
		}

		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();

		//property memento
		writePropertyMemento(arguments.buffer, arguments.object);

		/* external one to many links */
		iterator = arguments.object.getParentOneToManyIterator();
		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();

			parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

			writeExternalOneToManyMemento(arguments.buffer, parentObject);
		}

		//do many to one
		iterator = arguments.object.getManyToOneIterator();
		while(iterator.hasNext())
		{
			manytoone = iterator.next();
			writeManyToOneMemento(arguments.buffer, manytoone);
		}

		//do many to many
		iterator = arguments.object.getManyToManyIterator();
		while(iterator.hasNext())
		{
			manytomany = iterator.next();
			writeManyToManyMemento(arguments.buffer, arguments.object, manytomany);
		}

		//do one to many
		iterator = arguments.object.getOneToManyIterator();
		while(iterator.hasNext())
		{
			onetomany = iterator.next();
			writeOneToManyMemento(arguments.buffer, arguments.object, onetomany);
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writePropertyMemento" hint="Writes the memento for just properties" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="The object that is the parent" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.object.getPropertyIterator();
		var property = 0;

		arguments.buffer.writeCFFunctionOpen("setPropertyMemento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "struct", true);
		arguments.buffer.cfscript(true);

		//properties
		while(iterator.hasNext())
		{
			property = iterator.next();
			writePropertySet(arguments.buffer, property);
		}

		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeMementoCollection" hint="write the memento part for a Collection" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="name" hint="The name of the collection" type="string" required="Yes">
	<cfargument name="object" hint="The object that is the parent" type="transfer.com.object.Object" required="Yes">
	<cfargument name="collection" hint="The collection to base the memento on" type="transfer.com.object.collection" required="Yes">
	<cfargument name="linkObject" hint="The Object the link points to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manytomany" hint="This is a manytomany collection" type="boolean" required="no" default="true">

	<cfscript>
		//collection could be empty, so check
		arguments.buffer.writeLine("len = ArrayLen(arguments.memento);");
		//arguments.buffer.writeLine("clear" & arguments.name & "();");
		arguments.buffer.writeLine("for(counter = 1; counter lte len; counter = counter + 1)");
		arguments.buffer.writeLine("{");

			arguments.buffer.writeLine("composite = arguments.memento[counter];");

			//set the parent on the way through. Only used for onetomany, but could be useful for other things (?)
			arguments.buffer.writeLine("composite.parent"& arguments.object.getObjectName() &"_transferObject = getThisObject();");
			arguments.buffer.writeLine("item = getComposite("& q() & arguments.linkObject.getClassName()& q() &", composite, "& q() & arguments.linkObject.getPrimaryKey().getName() & q() &");");

			//add to the collection, depending on if its a struct of a array
			if(arguments.collection.getType() eq "array")
			{
				arguments.buffer.writeLine("arrayAppend(collection, item);");
			}
			else
			{
				arguments.buffer.writeLine("StructInsert(collection, item.get" & arguments.collection.getKey().getProperty() &"(), item, true);");
			}

		arguments.buffer.writeLine("}");

		arguments.buffer.writeLine("set" & arguments.name & "Collection(collection);");

		/*
			if one to many, loop back over the collection and
			ensure the parents are set.  For a clone sync, this shouldn't
			actually cause any change, as the children should already be set.
			(Unless they aren't saved, in which case, there is nothing I can do anyway)
		*/
		if(NOT arguments.manytomany)
		{
			arguments.buffer.writeLine("iterator = get" & arguments.name & "Iterator();");
			arguments.buffer.writeLine("while(iterator.hasNext())");
			arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("item = iterator.next();");

				arguments.buffer.writeLine("isDirty = item.getIsDirty();");

				arguments.buffer.writeLine("item.setParent" & arguments.object.getObjectName() & "(getThisObject(), false);");

				//if it's not dirty, it could be, so let's double check
				arguments.buffer.writeLine("if(NOT isDirty)");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsDirty(composite.transfer_isDirty);");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsPersisted(composite.transfer_isPersisted);");
				arguments.buffer.writeLine("}");

			arguments.buffer.writeLine("}");
		}

		/*
			if(arguments.manytomany)
			{
				arguments.buffer.writeLine("add" & arguments.name & "(item);");
			}
			else
			{
				arguments.buffer.writeLine("isDirty = item.getIsDirty();");

				arguments.buffer.writeLine("item.setParent" & arguments.object.getObjectName() & "(getThisObject());");

				//if it's not dirty, it could be, so let's double check
				arguments.buffer.writeLine("if(NOT isDirty)");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsDirty(composite.transfer_isDirty);");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsPersisted(composite.transfer_isPersisted);");
				arguments.buffer.writeLine("}");
				/*
				** removed and replaced with above line
				arguments.buffer.writeLine("if(item.getIsClone())");
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsDirty(composite.transfer_isDirty);");
					arguments.buffer.writeLine("item.getOriginalTransferObject().setIsPersisted(composite.transfer_isPersisted);");
				arguments.buffer.writeLine("}");
				* /
			}
		*/
	</cfscript>
</cffunction>

<cffunction name="writeManyToOneMemento" hint="writes the one to many memento setter" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="manytoone" hint="The one to many object" type="transfer.com.object.manytoone" required="Yes">
	<cfscript>
		var composite = getObjectManager().getObject(arguments.manytoone.getLink().getTo());

		arguments.buffer.writeCFFunctionOpen("set" & arguments.manytoone.getName() & "Memento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "struct", true);
		arguments.buffer.cfscript(true);
		arguments.buffer.writeLine("var composite = 0;");

		arguments.buffer.writeSetIsLoaded(arguments.manytoone.getName(), true);

		arguments.buffer.writeLine("if(StructIsEmpty(arguments.memento))");
		arguments.buffer.writeLine("{");
		arguments.buffer.writeLine("remove" & arguments.manytoone.getName() & "();");
		arguments.buffer.writeLine("}");
		arguments.buffer.writeLine("else");
		arguments.buffer.writeLine("{");
		arguments.buffer.writeLine("composite = getComposite("& q() & composite.getClassName() & q() &", arguments.memento, " & q() & composite.getPrimaryKey().getName() & q() & ");");
		arguments.buffer.writeLine("set" & arguments.manytoone.getName() & "(composite);");
		arguments.buffer.writeLine("}");
		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeNewCollection" hint="writes a new collection as a var based on the type of the collection" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="collection" hint="The collection to base the new collection on" type="transfer.com.object.collection" required="Yes">
	<cfscript>
		arguments.buffer.append("var collection = ");
		if(arguments.collection.getType() eq "array")
		{
			arguments.buffer.writeLine("ArrayNew(1);");
		}
		else
		{
			arguments.buffer.writeLine("StructNew();");
		}
		arguments.buffer.writeLine("var counter = 0;");
		arguments.buffer.writeLine("var len = 0;");
		arguments.buffer.writeLine("var item = 0;");
		arguments.buffer.writeLine("var composite = 0;");
	</cfscript>
</cffunction>

<cffunction name="writeOneToManyMemento" hint="writes the one to many memento setter" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="The parent object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="onetomany" hint="The onetomany object" type="transfer.com.object.onetomany" required="Yes">
	<cfscript>
		var composite = getObjectManager().getObject(arguments.onetomany.getLink().getTo());

		arguments.buffer.writeCFFunctionOpen("set" & arguments.onetomany.getName() & "Memento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "array", true);
		arguments.buffer.cfscript(true);
		arguments.buffer.writeLine("var isDirty = false;");
		arguments.buffer.writeLine("var iterator = 0;");
		writeNewCollection(arguments.buffer, arguments.onetomany.getCollection());

		arguments.buffer.cfscript(false);

		arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.onetomany.getName() & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");

		arguments.buffer.cfscript(true);

		arguments.buffer.writeSetIsLoaded(arguments.onetomany.getName(), true);

		writeMementoCollection(arguments.buffer,
								arguments.onetomany.getName(),
								arguments.object,
								arguments.onetomany.getCollection(),
								composite,
								false);

		arguments.buffer.cfscript(false);

		arguments.buffer.writeNamedLockClose();

		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeManyToManyMemento" hint="writes the one to many memento setter" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="The parent object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manytomany" hint="The onetomany object" type="transfer.com.object.manytomany" required="Yes">
	<cfscript>
		var composite = getObjectManager().getObject(arguments.manytomany.getLinkTo().getTo());

		arguments.buffer.writeCFFunctionOpen("set" & arguments.manytomany.getName() & "Memento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "array", true);
		arguments.buffer.cfscript(true);
		writeNewCollection(arguments.buffer, arguments.manytomany.getCollection());
		arguments.buffer.cfscript(false);

		arguments.buffer.writeNamedLockOpen("transfer." & arguments.object.getClassName() & "." & arguments.manytomany.getName() & ".##get" & arguments.object.getPrimaryKey().getName() & "()##");

		arguments.buffer.cfscript(true);
		arguments.buffer.writeSetIsLoaded(arguments.manytomany.getName(), true);

		writeMementoCollection(arguments.buffer,
								arguments.manytomany.getName(),
								arguments.object,
								arguments.manytomany.getCollection(),
								composite);

		arguments.buffer.cfscript(false);

		arguments.buffer.writeNamedLockClose();

		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>


<cffunction name="writeExternalOneToManyMemento" hint="Writes the memento for external manytoones" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="parentObject" hint="The parent object" type="transfer.com.object.Object" required="Yes">
	<cfscript>

		arguments.buffer.writeCFFunctionOpen("setParent" & arguments.parentObject.getObjectName() & "Memento", "public", "void");
		arguments.buffer.writeCFArgument("memento", "struct", true);
		arguments.buffer.writeCFArgument("retrieveParent", "boolean", false, true);
		arguments.buffer.cfscript(true);

		/*
		check for the parent in the memento, if it's there,
		don't try and get it, as it will cause an infinite loop
		*/
		arguments.buffer.writeLine("if(StructKeyExists(arguments.memento, " & q() & "parent" & arguments.parentObject.getObjectName() & "_transferObject"& q() & "))");
		arguments.buffer.writeLine("{");
			arguments.buffer.writeSetIsLoaded("Parent" & arguments.parentObject.getObjectName(), true);
		arguments.buffer.writeLine("}");
		arguments.buffer.writeLine("else if(arguments.retrieveParent)");
		arguments.buffer.writeLine("{");

			arguments.buffer.append("if(StructKeyExists(arguments.memento, ");
				arguments.buffer.append(q() & "parent"& arguments.parentObject.getObjectName() &"_"& arguments.parentObject.getPrimaryKey().getName() & q());
				arguments.buffer.writeLine("))");
			arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("composite = getTransfer().get("& q() & arguments.parentObject.getClassName() & q() &", arguments.memento.parent"& arguments.parentObject.getObjectName() &"_"& arguments.parentObject.getPrimaryKey().getName() & ");");
				//if it's persisted, but I don't have a parent set (i.e. lazy load situation), then set it

				arguments.buffer.writeLine("if(getIsClone() AND composite.getIsPersisted())"); //if not persistent, don't bother cloning it
				arguments.buffer.writeLine("{");
					arguments.buffer.writeLine("composite = composite.clone();");
				arguments.buffer.writeLine("}");

				arguments.buffer.writeSetIsLoaded("Parent" & arguments.parentObject.getObjectName(), true);
				arguments.buffer.writeLine("if(composite.getIsPersisted())");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("setParent" & arguments.parentObject.getObjectName() & "(composite, false);");
				arguments.buffer.writeLine("}");
				arguments.buffer.writeLine("else");
				arguments.buffer.writeLine("{");
				arguments.buffer.writeLine("removeParent" & arguments.parentObject.getObjectName() & "();");
				arguments.buffer.writeLine("}");

			arguments.buffer.writeLine("}");
			arguments.buffer.writeLine("else");
			arguments.buffer.writeLine("{");
				arguments.buffer.writeSetIsLoaded("Parent" & arguments.parentObject.getObjectName(), true);
				arguments.buffer.writeLine("removeParent" & arguments.parentObject.getObjectName() & "();");
			arguments.buffer.writeLine("}");

		arguments.buffer.writeLine("}");

		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>

</cffunction>

<cffunction name="writePropertySet" hint="Writes the property set for memento with the correct parsing of values" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="property" hint="The property to be written for" type="transfer.com.object.property" required="Yes">

	<cfscript>
		arguments.buffer.append("set" & arguments.property.getName() & "(");
		arguments.buffer.append("arguments.memento." & arguments.property.getName());
		arguments.buffer.writeLine(");");
	</cfscript>
</cffunction>

</cfcomponent>