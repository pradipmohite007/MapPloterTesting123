public with sharing class JSONGoogleGeoResponse 
{
	////////////////////////////////////
	// Properies
	////////////////////////////////////

	public List<Results> results;
        public String status;

	////////////////////////////////////
	// Constructor
	////////////////////////////////////
	public JSONGoogleGeoResponse() 
	{
		
	}

	////////////////////////////////////
	// Inner Classes
	////////////////////////////////////
	public class Address_components 
	{
		public String long_name;
		public String short_name;
		public List<String> types;
	}

	public class Northeast 
	{
		public Double lat;
		public Double lng;
	}

	public class Bounds 
	{
		public Northeast northeast;
		public Northeast southwest;
	}

	public class Geometry 
	{
		public Bounds bounds;
		public Northeast location;
		public String location_type;
		public Bounds viewport;
	}

	public class Results 
	{
		public List<Address_components> address_components;
		public String formatted_address;
		public Geometry geometry;
		public List<String> types;
	}

	////////////////////////////////////
	// Static Methods
	////////////////////////////////////
	
	public static JSONGoogleGeoResponse parse(String json) 
	{
		return (JSONGoogleGeoResponse) System.JSON.deserialize(json, JSONGoogleGeoResponse.class);
	}
	
	////////////////////////////////////
	// Public Methods
	////////////////////////////////////

	////////////////////////////////////
	// Private Methods
	////////////////////////////////////
}