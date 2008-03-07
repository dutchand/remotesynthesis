<cfcomponent displayname="FTP Services">
	<cffunction name="init" access="public" output="false" returntype="ftpService">
		<cfargument name="server" type="string" required="false" default="" />
		<cfargument name="username" type="string" required="false" default="" />
		<cfargument name="password" type="string" required="false" default="" />
		
		<cfset variables.connection = structNew() />
		<cfset variables.connectionIsOpen = false />
		<cfset setServer(arguments.server) />
		<cfset setUsername(arguments.username) />
		<cfset setPassword(arguments.password) />
		<cfset open() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setServer" access="public" output="false" returntype="void">
		<cfargument name="server" type="string" required="true" />
		
		<cfset variables.server = arguments.server />
	</cffunction>
	<cffunction name="getServer" access="public" output="false" returntype="string">
		<cfreturn variables.server />
	</cffunction>
	
	<cffunction name="setUsername" access="public" output="false" returntype="void">
		<cfargument name="username" type="string" required="true" />
		
		<cfset variables.username = arguments.username />
	</cffunction>
	<cffunction name="getUsername" access="public" output="false" returntype="string">
		<cfreturn variables.username />
	</cffunction>
	
	<cffunction name="setPassword" access="public" output="false" returntype="void">
		<cfargument name="password" type="string" required="true" />
		
		<cfset variables.password = arguments.password />
	</cffunction>
	<cffunction name="getPassword" access="public" output="false" returntype="string">
		<cfreturn variables.password />
	</cffunction>
	
	<cffunction name="isConnectionOpen" access="public" output="false" returntype="boolean">
		<cfreturn variables.connectionIsOpen />
	</cffunction>
	
	<cffunction name="open" access="public" output="false" returntype="boolean">
		<cfset var success = false />
		<cfset var ftp = "" />

		<cfif len(getServer()) and len(getUsername()) and len(getPassword())>
			<cfftp action="open" server="#getServer()#" username="#getUsername()#" password="#getPassword()#" connection="variables.connection" result="ftp" />
			<cfset success = ftp.succeeded />
			<cfif success>
				<cfset variables.connectionIsOpen = true />
			</cfif>
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="close" access="public" output="false" returntype="boolean">
		<cfset var success = false />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="close" connection="variables.connection" result="ftp" />
			<cfset success = ftp.succeeded />
			<cfif success>
				<cfset variables.connectionIsOpen = false />
			</cfif>
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="listDir" access="public" output="false" returntype="query">
		<cfargument name="directory" type="string" required="false" default="#getCurrentDir()#" />
		<cfset var qryReturn = "" />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="listDir" connection="variables.connection" name="qryReturn" directory="#arguments.directory#" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn qryReturn />
	</cffunction>
	
	<cffunction name="getCurrentDir" access="public" output="false" returntype="string">
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="getCurrentDir" connection="variables.connection" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn ftp.returnValue />
	</cffunction>
	
	<cffunction name="getCurrentURL" access="public" output="false" returntype="string">
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="getCurrentURL" connection="variables.connection" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn ftp.returnValue />
	</cffunction>
	
	<cffunction name="existsDir" access="public" output="false" returntype="boolean">
		<cfargument name="directory" type="string" required="true" />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="existsDir" connection="variables.connection" directory="#arguments.directory#" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn ftp.returnValue />
	</cffunction>
	
	<cffunction name="existsFile" access="public" output="false" returntype="boolean">
		<cfargument name="remoteFile" type="string" required="true" />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="existsFile" connection="variables.connection" remoteFile="#arguments.remoteFile#" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn ftp.returnValue />
	</cffunction>
	
	<cffunction name="changedir" access="public" output="false" returntype="boolean">
		<cfargument name="directory" type="string" required="true" />
		<cfset var success = false />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="changedir" connection="variables.connection" directory="#arguments.directory#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="createDir" access="public" output="false" returntype="boolean">
		<cfargument name="directory" type="string" required="true" />
		<cfset var success = false />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="createDir" connection="variables.connection" directory="#arguments.directory#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="removeDir" access="public" output="false" returntype="boolean">
		<cfargument name="directory" type="string" required="true" />
		<cfset var success = false />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="removeDir" connection="variables.connection" directory="#arguments.directory#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="putFile" access="public" output="false" returntype="boolean">
		<cfargument name="localFile" type="string" required="true" />
		<cfargument name="remoteFile" type="string" required="false" default="" />
		<cfset var success = false />
		<cfset var ftp = "" />
		
		<!--- make sure that the local file exists by first testing fully qualified path and then relative --->
		<cfif not fileExists(arguments.localFile)>
			<cfset arguments.localFile = expandPath(arguments.localFile) />
			<cfif not fileExists(arguments.localFile)>
				<cfthrow errorcode="com.ftpService" detail="The specified file to upload does not exist." />
			</cfif>
		</cfif>
		
		<!--- remote file name defaults to same as local file name --->
		<cfif not len(arguments.remoteFile)>
			<cfset arguments.remoteFile = getFileFromPath(arguments.localFile) />
		</cfif>

		<cfif isConnectionOpen()>
			<cfftp action="putFile" connection="variables.connection" localFile="#arguments.localFile#" remoteFile="#arguments.remoteFile#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="getFile" access="public" output="false" returntype="boolean">
		<cfargument name="remoteFile" type="string" required="true" />
		<cfargument name="localFile" type="string" required="false" default="" />
		<cfset var success = false />
		<cfset var ftp = "" />
		
		<!--- make sure the file we intend to get actually exists in the current dir --->
		<cfif not existsFile(arguments.remoteFile)>
			<cfthrow errorcode="com.ftpService" detail="The specified remote file does not exist in the current directory." />
		</cfif>
		
		<!--- local file name defaults to same as remote file name in same directory as component --->
		<cfif not len(arguments.localFile)>
			<cfset arguments.localFile = expandPath("./") & getFileFromPath(arguments.remoteFile) />
		</cfif>
		
		<!--- make sure that the local file directory exists by first testing fully qualified path and then relative --->
		<cfif not directoryExists(getDirectoryFromPath(arguments.localFile))>
			<cfset arguments.localFile = expandPath(arguments.localFile) />
			<cfif not directoryExists(getDirectoryFromPath(arguments.localFile))>
				<cfthrow errorcode="com.ftpService" detail="The specified directory to place local file does not exist." />
			</cfif>
		</cfif>

		<cfif isConnectionOpen()>
			<cfftp action="getFile" connection="variables.connection" localFile="#arguments.localFile#" remoteFile="#arguments.remoteFile#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="remove" access="public" output="false" returntype="boolean">
		<cfargument name="remotePath" type="string" required="true" />
		<cfset var success = false />
		<cfset var ftp = "" />

		<!--- now check if the directory or file actually exist within the current dir --->
		<cfif not exists(arguments.remotePath)>
			<cfthrow errorcode="com.ftpService" detail="The specified remote directory or file does not exist in the current directory." />
		</cfif>

		<cfif isConnectionOpen()>
			<cfftp action="remove" connection="variables.connection" item="#arguments.remotePath#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="remotePath" type="string" required="true" />
		<cfset var ftp = "" />

		<cfif isConnectionOpen()>
			<cfftp action="exists" connection="variables.connection" item="#arguments.remotePath#" result="ftp" />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn ftp.returnValue />
	</cffunction>
	
	<cffunction name="rename" access="public" output="false" returntype="boolean">
		<cfargument name="existing" type="string" required="true" />
		<cfargument name="new" type="string" required="true" />
		<cfset var success = false />
		<cfset var ftp = "" />
		
		<!--- make sure the existing file or directory we intend to rename actually exists in the current dir --->
		<cfif not existsFile(arguments.existing) and not existsDir(arguments.existing)>
			<cfthrow errorcode="com.ftpService" detail="The specified remote file or directory does not exist in the current directory." />
		</cfif>

		<cfif isConnectionOpen()>
			<cfftp action="rename" connection="variables.connection" existing="#arguments.existing#" new="#arguments.new#" result="ftp" />
			<cfset success = ftp.succeeded />
		<cfelse>
			<cfthrow errorcode="com.ftpService" detail="An existing connection must be open before you can run this function" />
		</cfif>
		<cfreturn success />
	</cffunction>
	
</cfcomponent>