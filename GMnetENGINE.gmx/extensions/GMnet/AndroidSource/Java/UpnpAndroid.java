package ${YYAndroidPackageName};

import android.util.Log;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.String;
import java.lang.Integer;

import net.sbbi.upnp.impls.InternetGatewayDevice;

import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;


public class UpnpAndroid
{

	private static final int EVENT_OTHER_SOCIAL = 70;
	private InternetGatewayDevice[] internetGatewayDevices;

	public void ReturnAsync(double arg0, double arg1)
	{			
		int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
		RunnerJNILib.DsMapAddString( dsMapIndex, "type", "finished" );
		RunnerJNILib.DsMapAddDouble( dsMapIndex, "argument0", arg0);
		RunnerJNILib.DsMapAddDouble( dsMapIndex, "argument1", arg1);
		RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);		
	}

    	public double AddTwoNumbers(double arg0, double arg1)
	{
        	double value = arg0 + arg1;
        	Log.i("yoyo", arg0 + "+" + arg1 + " = " + value);

        	return value;
    	}


    	public String BuildAString(String arg0, String arg1)
	{
        	String myString = arg0 + " " + arg1;
        	Log.i("yoyo", myString);

        	return myString;
    	}


    	public String HowManyObjects(double arg0, double arg1, String arg2)
	{
        	double value = arg0 + arg1;
        	Log.i("yoyo", arg0 + "+" + arg1 + " = " + value);

		String myString = String.valueOf(value) + " " + arg2;
		Log.i("yoyo", myString);

        	return myString;
    	}

	public void Upnp_add(final double port, final String internalIP) throws Exception
	{
		final int portInteger = (int)port;
		Thread one = new Thread()
		{
    			public void run() 
			{
        			try 
				{
            				Upnp_add_thread(portInteger,internalIP);
        			} 
				catch(Exception e) 
				{
            				Log.i("yoyo", "Cant start upnp thread");
        			}
    			}  
		};

		one.start();
	}

	public void Upnp_remove(final double port) throws Exception
	{
		final int portInteger = (int)port;
		
		Upnp_remove_thread(portInteger);

		//Thread one = new Thread()
		//{
    		//	public void run() 
		//	{
        	//		try 
		//		{
            	//			Upnp_remove_thread(portInteger);
        	//		} 
		//		catch(Exception e) 
		//		{
            	//			Log.i("yoyo", "Cant start upnp thread");
        	//		}
    		//	}  
		//};

		//one.start();
	}

    	public void Upnp_add_thread(int portInteger, String internalIP) throws Exception
	{
        	String myString = String.valueOf(portInteger);
        	Log.i("yoyo", "Try to forward port: " + myString + " on NAT to " + internalIP);

    		try
		{
        		/** Upnp devices - router search*/
        		if (internetGatewayDevices == null)
			{
            			internetGatewayDevices = InternetGatewayDevice.getDevices(5000);
        		}

			if(internetGatewayDevices != null)
			{	
            			for (InternetGatewayDevice addIGD : internetGatewayDevices) 
				{
                			/** Open port for TCP protocol and also for UDP protocol
                 			*  Both protocols must be open - this is a MUST*/
                			addIGD.addPortMapping("GameMakerStudio", "", portInteger, portInteger, internalIP, 0, "TCP");
                			addIGD.addPortMapping("GameMakerStudio", "", portInteger, portInteger, internalIP, 0, "UDP");
            			}	
				
				Log.i("yoyo", "Upnp_add success");

				int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString( dsMapIndex, "type", "finished" );
				RunnerJNILib.DsMapAddDouble( dsMapIndex, "alldone", 1);
				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);	
			}
			else
			{		
				Log.i("yoyo", "Upnp_add no NAT found");
			}
        		//return arg0;
    		} 
		catch(Exception e)
		{
			Log.i("yoyo", "Upnp_add fail");
        		//return -1;
    		}
    	}

    	public void Upnp_remove_thread(int portInteger) throws Exception
	{
        	String myString = String.valueOf(portInteger);
        	Log.i("yoyo", "Try to remove forward port: " + myString + " on NAT");

    		try
		{
        		/** Upnp devices - router search*/
        		if (internetGatewayDevices == null)
			{
            			internetGatewayDevices = InternetGatewayDevice.getDevices(5000);
        		}

			if(internetGatewayDevices != null)
			{	
            			for (InternetGatewayDevice addIGD : internetGatewayDevices) 
				{
                			/** Open port for TCP protocol and also for UDP protocol
                 			*  Both protocols must be open - this is a MUST*/
					addIGD.deletePortMapping("", portInteger, "TCP");
					addIGD.deletePortMapping("", portInteger, "UDP");
            			}	
				
				Log.i("yoyo", "Upnp_remove success");

				int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString( dsMapIndex, "type", "finished" );
				RunnerJNILib.DsMapAddDouble( dsMapIndex, "alldone", 1);
				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);	
			}
			else
			{		
				Log.i("yoyo", "Upnp_remove no NAT found");
			}
        		//return arg0;
    		} 
		catch(Exception e)
		{
			Log.i("yoyo", "Upnp_remove fail");
        		//return -1;
    		}
    	}

} // End of class

