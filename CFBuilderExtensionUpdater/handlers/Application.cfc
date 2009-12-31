component  output="false" extends="BaseApplication"
{
	this.name = "sampleApp";
	
	public boolean function onApplicationStart() output="false"
	{
		super.onApplicationStart();
		
		return true;
	}
	
	public void function onRequest(
		required string targetPage) output="true"
	{
		super.onRequest(arguments.targetPage);
	}
}