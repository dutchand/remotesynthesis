<!--- Document Information -----------------------------------------------------

Title:      Utilityity.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Utilityity class for general static methods

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		21/04/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="Utility" hint="Utility class for general static methods">

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="Utility" output="false">
	<cfreturn this>
</cffunction>

<!---
/**
 * Implementation of Hoare's Quicksort algorithm for sorting arrays of arbitrary items.
 * Slight mods by RCamden (added var for comparison)
 *
 * @param arrayToCompare 	 The array to be sorted.
 * @param sorter 	 The comparison UDF.
 * @return Returns a sorted array.
 * @author James Sleeman (james@innovativemedia.co.nz)
 * @version 1, March 12, 2002
 */
 --->
<cffunction name="quickSort" hint="Implementation of quicksort" access="public" returntype="array" output="false">
	<cfargument name="arrayToCompare" hint="The array to compare" type="array" required="Yes">
	<cfargument name="sorter" hint="UDF for comparing items" type="any" required="Yes">
	<cfscript>
		var lesserArray  = ArrayNew(1);
		var greaterArray = ArrayNew(1);
		var pivotArray   = ArrayNew(1);
		var examine      = 2;
		var comparison = 0;

		pivotArray[1]    = arrayToCompare[1];

		if (arrayLen(arrayToCompare) LT 2) {
			return arrayToCompare;
		}

		while(examine LTE arrayLen(arrayToCompare)){
			comparison = arguments.sorter(arrayToCompare[examine], pivotArray[1]);
			switch(comparison) {
				case "-1": {
					arrayAppend(lesserArray, arrayToCompare[examine]);
					break;
				}
				case "0": {
					arrayAppend(pivotArray, arrayToCompare[examine]);
					break;
				}
				case "1": {
					arrayAppend(greaterArray, arrayToCompare[examine]);
					break;
				}
			}
			examine = examine + 1;
		}

		if (arrayLen(lesserArray)) {
			lesserArray  = quickSort(lesserArray, arguments.sorter);
		} else {
			lesserArray = arrayNew(1);
		}

		if (arrayLen(greaterArray)) {
			greaterArray = quickSort(greaterArray, arguments.sorter);
		} else {
			greaterArray = arrayNew(1);
		}

		examine = 1;
		while(examine LTE arrayLen(pivotArray)){
			arrayAppend(lesserArray, pivotArray[examine]);
			examine = examine + 1;
		};

		examine = 1;
		while(examine LTE arrayLen(greaterArray)){
			arrayAppend(lesserArray, greaterArray[examine]);
			examine = examine + 1;
		};

		return lesserArray;
	</cfscript>
</cffunction>

<cffunction name="createGUID" hint="Returns a MS GUID, that is performant for indexing as per http://www.informit.com/articles/article.asp?p=25862" access="public" returntype="string" output="false">
	<cfscript>
		var long = createObject("Java", "java.lang.Long");
		var GUID = DateFormat(Now(), "yymmdd") & Timeformat(Now(), "HHmmsslll");
		var stringBuffer = createObject("Java", "java.lang.StringBuffer").init();
		var counter = 1;
		var h = "-";

		GUID = long.toHexString(long.parseLong(JavaCast("string", GUID)));

		for(; counter lte 20; counter = counter + 1)
		{
			stringBuffer.append(FormatBaseN(randRange(0, 15), 16));
		}

		stringBuffer.append(GUID);

		stringBuffer.insert(JavaCast("int", 8), h);
		stringBuffer.insert(JavaCast("int", 13), h);
		stringBuffer.insert(JavaCast("int", 18), h);
		stringBuffer.insert(JavaCast("int", 23), h);

		//return
		return UCase(stringBuffer.toString());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>