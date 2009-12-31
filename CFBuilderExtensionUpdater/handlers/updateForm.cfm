<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response status="success" type="default">
  <ide handlerfile="#CGI.script_name#?downloadUpdate=true">
     <dialog width="320" height="200">
        <input name="Update Available (v. #remoteVersion#). Download?" Lable="downloadUpdate" type="list">
           <option value="Yes" />
           <option value="No" />
        </input>               
     </dialog>
  </ide>
</response>
</cfoutput>
<cfabort />