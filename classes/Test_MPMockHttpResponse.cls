@istest
public with sharing class Test_MPMockHttpResponse
{
    // Return JSON mock string for geocode api callout.
    public static Boolean flag;
    public static testmethod string getGeoCodeJSONBody()
    {
     
            string resposeString = '{'
                    +' \"results\" : ['
                                        +'{'
                     +'\"address_components\" : [ ],'
                     +'\"formatted_address\" : \"1590 North High Street, South Campus Gateway, Columbus, OH 43201, USA\",'
                     +'\"geometry\" : {'
                        +'\"location\" : {'
                          +' \"lat\" : 39.9944403,'
                           +'\"lng\" : -83.00661319999999'
                        +'},'
                        +'\"location_type\" : \"ROOFTOP\",'
                        +'\"viewport\" : {'
                          +' \"northeast\" : {'
                           +'   \"lat\" : 39.9957892802915,'
                            +'  \"lng\" : -83.00526421970848'
                          +' },'
                          +' \"southwest\" : {'
                          +'    \"lat\" : 39.9930913197085,'
                          +'    \"lng\" : -83.0079621802915'
                              +' }'
                            +'}'
                            +' },'
                            +' \"partial_match\" : true,'
                            +' \"types\" : [ \"street_address\" ]'
                          +'}'
                       +'],'
                       +'\"status\" : \"OK\"'
                +'}';
        system.assertEquals(resposeString.length(),484);
        return resposeString;
      
    }

    public static testmethod string getGeoCodeJSONBodyWithWrongKey()
    {
     
            string resposeString = '{'
              +'\"error_message" : "The provided API key is invalid.",'
              +'\"results" : [],'
              +'\"status" : "REQUEST_DENIED"'
                      +'}';
        system.assertEquals(resposeString.length(),97);
        return resposeString;
      
    }
    
    // Return JSON mock string for World weather api callout.
    public static testmethod string getWeatherJSONBody()
    {
        String resposeString = '{\"data\":{\"current_condition\":[{\"cloudcover\":\"60\",\"FeelsLikeC\":\"-1\",\"FeelsLikeF\":\"30\",\"humidity\":\"93\",\"observation_time\":\"06:21 AM\",\"precipMM\":\"0.0\",\"pressure\":\"1022\",\"temp_C\":\"-1\",'
        + '\"temp_F\":\"30\",\"visibility\":\"1\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"winddir16Point\":\"N\",\"winddirDegree\":\"0\",\"windspeedKmph\":\"0\",\"windspeedMiles\":\"0\"}],'
        +'\"request\":[{\"query\":\"Bentonville, United States Of America\",\"type\":\"City\"}],\"weather\":[{\"astronomy\":[{\"moonrise\":\"07:59 AM\",\"moonset\":\"07:16 PM\",\"sunrise\":\"07:26 AM\",\"sunset\":\"05:32 PM\"}],\"date\":\"2015-01-21\",\"hourly\":[{\"chanceoffog\":\"0\",\"chanceoffrost\":\"15\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",'
        +'\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"15\",\"DewPointC\":\"0\",\"DewPointF\":\"32\",\"FeelsLikeC\":\"-1\",\"FeelsLikeF\":\"31\",\"HeatIndexC\":\"1\",\"HeatIndexF\":\"34\",\"humidity\":\"94\",\"precipMM\":\"0.0\",\"pressure\":\"1022\",\"tempC\":\"1\",\"tempF\":\"34\",\"time\":\"100\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-1\",\"WindChillF\":\"31\",\"winddir16Point\":\"WNW\",\"winddirDegree\":\"282\",\"WindGustKmph\":\"10\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"15\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"95\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"16\",\"DewPointC\":\"0\",\"DewPointF\":\"32\",\"FeelsLikeC\":\"-1\",\"FeelsLikeF\":\"31\",\"HeatIndexC\":\"1\",\"HeatIndexF\":\"34\",\"humidity\":\"94\",\"precipMM\":\"0.0\",\"pressure\":\"1023\",\"tempC\":\"1\",\"tempF\":\"34\",\"time\":\"400\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-1\",\"WindChillF\":\"31\",\"winddir16Point\":\"W\",\"winddirDegree\":\"275\",\"WindGustKmph\":\"12\",\"WindGustMiles\":\"8\",\"windspeedKmph\":\"6\",\"windspeedMiles\":\"4\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"11\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"33\",\"DewPointC\":\"1\",\"DewPointF\":\"34\",\"FeelsLikeC\":\"-1\",\"FeelsLikeF\":\"31\",\"HeatIndexC\":\"2\",\"HeatIndexF\":\"35\",\"humidity\":\"95\",\"precipMM\":\"0.0\",\"pressure\":\"1023\",\"tempC\":\"2\",\"tempF\":\"35\",\"time\":\"700\",\"visibility\":\"2\",\"weatherCode\":\"143\",\"weatherDesc\":[{\"value\":\"Mist\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0006_mist.png\"}],\"WindChillC\":\"-1\",\"WindChillF\":\"31\",\"winddir16Point\":\"WNW\",\"winddirDegree\":\"283\",\"WindGustKmph\":\"14\",\"WindGustMiles\":\"9\",\"windspeedKmph\":\"7\",\"windspeedMiles\":\"4\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"93\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"15\",\"DewPointC\":\"2\",\"DewPointF\":\"36\",\"FeelsLikeC\":\"4\",\"FeelsLikeF\":\"38\",\"HeatIndexC\":\"5\",\"HeatIndexF\":\"40\",\"humidity\":\"84\",\"precipMM\":\"0.0\",\"pressure\":\"1025\",\"tempC\":\"5\",\"tempF\":\"40\",\"time\":\"1000\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Sunny\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0001_sunny.png\"}],\"WindChillC\":\"4\",\"WindChillF\":\"38\",\"winddir16Point\":\"NNW\",\"winddirDegree\":\"328\",\"WindGustKmph\":\"6\",\"WindGustMiles\":\"4\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"0\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"87\",\"DewPointC\":\"-1\",\"DewPointF\":\"31\",\"FeelsLikeC\":\"7\",\"FeelsLikeF\":\"45\",\"HeatIndexC\":\"11\",\"HeatIndexF\":\"52\",\"humidity\":\"72\",\"precipMM\":\"0.0\",\"pressure\":\"1025\",\"tempC\":\"7\",\"tempF\":\"45\",\"time\":\"1900\",\"visibility\":\"10\",\"weatherCode\":\"119\",\"weatherDesc\":[{\"value\":\"Cloudy\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png\"}],\"WindChillC\":\"7\",\"WindChillF\":\"45\",\"winddir16Point\":\"N\",\"winddirDegree\":\"358\",\"WindGustKmph\":\"14\",\"WindGustMiles\":\"9\",\"windspeedKmph\":\"6\",\"windspeedMiles\":\"4\"}],\"maxtempC\":\"12\",\"maxtempF\":\"53\",\"mintempC\":\"2\",\"mintempF\":\"36\",\"uvIndex\":\"3\"},{\"astronomy\":[{\"moonrise\":\"08:42 AM\",\"moonset\":\"08:26 PM\",\"sunrise\":\"07:25 AM\",\"sunset\":\"05:33 PM\"}],\"date\":\"2015-01-22\",\"hourly\":[{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"38\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"0\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"84\",\"DewPointC\":\"-2\",\"DewPointF\":\"29\",\"FeelsLikeC\":\"1\",\"FeelsLikeF\":\"34\",\"HeatIndexC\":\"2\",\"HeatIndexF\":\"36\",\"humidity\":\"74\",\"precipMM\":\"0.1\",\"pressure\":\"1029\",\"tempC\":\"2\",\"tempF\":\"36\",\"time\":\"100\",\"visibility\":\"10\",\"weatherCode\":\"176\",\"weatherDesc\":[{\"value\":\"Patchy rain nearby\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0025_light_rain_showers_night.png\"}],\"WindChillC\":\"1\",\"WindChillF\":\"34\",\"winddir16Point\":\"NNE\",\"winddirDegree\":\"31\",\"WindGustKmph\":\"10\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"10\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"45\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"0\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"82\",\"DewPointC\":\"-2\",\"DewPointF\":\"29\",\"FeelsLikeC\":\"1\",\"FeelsLikeF\":\"33\",\"HeatIndexC\":\"2\",\"HeatIndexF\":\"36\",\"humidity\":\"76\",\"precipMM\":\"0.2\",\"pressure\":\"1030\",\"tempC\":\"2\",\"tempF\":\"36\",\"time\":\"400\",\"visibility\":\"9\",\"weatherCode\":\"317\",\"weatherDesc\":[{\"value\":\"Light sleet\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0037_cloudy_with_sleet_night.png\"}],\"WindChillC\":\"1\",\"WindChillF\":\"33\",\"winddir16Point\":\"NNE\",\"winddirDegree\":\"31\",\"WindGustKmph\":\"9\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"11\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"7\",\"chanceofrain\":\"21\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"20\",\"chanceofsunshine\":\"1\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"89\",\"DewPointC\":\"-2\",\"DewPointF\":\"29\",\"FeelsLikeC\":\"-1\",\"FeelsLikeF\":\"31\",\"HeatIndexC\":\"1\",\"HeatIndexF\":\"34\",\"humidity\":\"80\",\"precipMM\":\"0.1\",\"pressure\":\"1030\",\"tempC\":\"1\",\"tempF\":\"34\",\"time\":\"700\",\"visibility\":\"10\",\"weatherCode\":\"176\",\"weatherDesc\":[{\"value\":\"Patchy rain nearby\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0025_light_rain_showers_night.png\"}],\"WindChillC\":\"-1\",\"WindChillF\":\"31\",\"winddir16Point\":\"NE\",\"winddirDegree\":\"46\",\"WindGustKmph\":\"11\",\"WindGustMiles\":\"7\",\"windspeedKmph\":\"6\",\"windspeedMiles\":\"4\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"49\",\"DewPointC\":\"-2\",\"DewPointF\":\"29\",\"FeelsLikeC\":\"0\",\"FeelsLikeF\":\"32\",\"HeatIndexC\":\"3\",\"HeatIndexF\":\"37\",\"humidity\":\"74\",\"precipMM\":\"0.0\",\"pressure\":\"1033\",\"tempC\":\"3\",\"tempF\":\"37\",\"time\":\"1000\",\"visibility\":\"10\",\"weatherCode\":\"116\",\"weatherDesc\":[{\"value\":\"Partly Cloudy\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png\"}],\"WindChillC\":\"0\",\"WindChillF\":\"32\",\"winddir16Point\":\"NE\",\"winddirDegree\":\"42\",\"WindGustKmph\":\"9\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"44\",\"DewPointC\":\"-3\",\"DewPointF\":\"28\",\"FeelsLikeC\":\"4\",\"FeelsLikeF\":\"39\",\"HeatIndexC\":\"6\",\"HeatIndexF\":\"43\",\"humidity\":\"54\",\"precipMM\":\"0.0\",\"pressure\":\"1032\",\"tempC\":\"6\",\"tempF\":\"43\",\"time\":\"1300\",\"visibility\":\"10\",\"weatherCode\":\"116\",\"weatherDesc\":[{\"value\":\"Partly Cloudy\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png\"}],\"WindChillC\":\"4\",\"WindChillF\":\"39\",\"winddir16Point\":\"NNE\",\"winddirDegree\":\"16\",\"WindGustKmph\":\"12\",\"WindGustMiles\":\"7\",\"windspeedKmph\":\"10\",\"windspeedMiles\":\"6\"}],\"maxtempC\":\"7\",\"maxtempF\":\"45\",\"mintempC\":\"-2\",\"mintempF\":\"28\",\"uvIndex\":\"2\"},{\"astronomy\":[{\"moonrise\":\"09:24 AM\",\"moonset\":\"09:36 PM\",\"sunrise\":\"07:25 AM\",\"sunset\":\"05:34 PM\"}],\"date\":\"2015-01-23\",\"hourly\":[{\"chanceoffog\":\"0\",\"chanceoffrost\":\"71\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"18\",\"DewPointC\":\"-4\",\"DewPointF\":\"25\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"25\",\"HeatIndexC\":\"-2\",\"HeatIndexF\":\"28\",\"humidity\":\"85\",\"precipMM\":\"0.0\",\"pressure\":\"1031\",\"tempC\":\"-2\",\"tempF\":\"28\",\"time\":\"100\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"25\",\"winddir16Point\":\"NE\",\"winddirDegree\":\"41\",\"WindGustKmph\":\"11\",\"WindGustMiles\":\"7\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"1\",\"chanceoffrost\":\"84\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"62\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"7\",\"DewPointC\":\"-4\",\"DewPointF\":\"25\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"25\",\"HeatIndexC\":\"-2\",\"HeatIndexF\":\"28\",\"humidity\":\"89\",\"precipMM\":\"0.0\",\"pressure\":\"1030\",\"tempC\":\"-2\",\"tempF\":\"28\",\"time\":\"400\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"25\",\"winddir16Point\":\"ENE\",\"winddirDegree\":\"66\",\"WindGustKmph\":\"10\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"5\",\"windspeedMiles\":\"3\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"99\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"25\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"6\",\"DewPointC\":\"-4\",\"DewPointF\":\"25\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"26\",\"HeatIndexC\":\"-3\",\"HeatIndexF\":\"27\",\"humidity\":\"92\",\"precipMM\":\"0.0\",\"pressure\":\"1029\",\"tempC\":\"-3\",\"tempF\":\"27\",\"time\":\"700\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"26\",\"winddir16Point\":\"E\",\"winddirDegree\":\"98\",\"WindGustKmph\":\"7\",\"WindGustMiles\":\"4\",\"windspeedKmph\":\"3\",\"windspeedMiles\":\"2\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"6\",\"DewPointC\":\"-3\",\"DewPointF\":\"27\",\"FeelsLikeC\":\"3\",\"FeelsLikeF\":\"38\",\"HeatIndexC\":\"3\",\"HeatIndexF\":\"38\",\"humidity\":\"64\",\"precipMM\":\"0.0\",\"pressure\":\"1029\",\"tempC\":\"3\",\"tempF\":\"38\",\"time\":\"1000\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Sunny\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0001_sunny.png\"}],\"WindChillC\":\"3\",\"WindChillF\":\"38\",\"winddir16Point\":\"S\",\"winddirDegree\":\"189\",\"WindGustKmph\":\"2\",\"WindGustMiles\":\"1\",\"windspeedKmph\":\"2\",\"windspeedMiles\":\"1\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"3\",\"DewPointC\":\"-5\",\"DewPointF\":\"23\",\"FeelsLikeC\":\"8\",\"FeelsLikeF\":\"47\",\"HeatIndexC\":\"9\",\"HeatIndexF\":\"48\",\"humidity\":\"37\",\"precipMM\":\"0.0\",\"pressure\":\"1022\",\"tempC\":\"9\",\"tempF\":\"48\",\"time\":\"1600\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Sunny\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0001_sunny.png\"}],\"WindChillC\":\"8\",\"WindChillF\":\"47\",\"winddir16Point\":\"WNW\",\"winddirDegree\":\"282\",\"WindGustKmph\":\"8\",\"WindGustMiles\":\"5\",\"windspeedKmph\":\"7\",\"windspeedMiles\":\"4\"}],\"maxtempC\":\"9\",\"maxtempF\":\"48\",\"mintempC\":\"-1\",\"mintempF\":\"30\",\"uvIndex\":\"2\"},{\"astronomy\":[{\"moonrise\":\"10:02 AM\",\"moonset\":\"10:44 PM\",\"sunrise\":\"07:24 AM\",\"sunset\":\"05:35 PM\"}],\"date\":\"2015-01-24\",\"hourly\":[{\"chanceoffog\":\"0\",\"chanceoffrost\":\"92\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"2\",\"DewPointC\":\"-6\",\"DewPointF\":\"22\",\"FeelsLikeC\":\"-3\",\"FeelsLikeF\":\"26\",\"HeatIndexC\":\"-1\",\"HeatIndexF\":\"31\",\"humidity\":\"68\",\"precipMM\":\"0.0\",\"pressure\":\"1022\",\"tempC\":\"-1\",\"tempF\":\"31\",\"time\":\"100\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-3\",\"WindChillF\":\"26\",\"winddir16Point\":\"SW\",\"winddirDegree\":\"234\",\"WindGustKmph\":\"17\",\"WindGustMiles\":\"11\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"75\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"70\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"2\",\"DewPointC\":\"-4\",\"DewPointF\":\"24\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"25\",\"HeatIndexC\":\"-1\",\"HeatIndexF\":\"30\",\"humidity\":\"79\",\"precipMM\":\"0.0\",\"pressure\":\"1021\",\"tempC\":\"-1\",\"tempF\":\"30\",\"time\":\"400\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"25\",\"winddir16Point\":\"WSW\",\"winddirDegree\":\"240\",\"WindGustKmph\":\"17\",\"WindGustMiles\":\"11\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"20\",\"chanceoffrost\":\"93\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"96\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"1\",\"DewPointC\":\"-1\",\"DewPointF\":\"30\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"26\",\"HeatIndexC\":\"-1\",\"HeatIndexF\":\"31\",\"humidity\":\"97\",\"precipMM\":\"0.0\",\"pressure\":\"1021\",\"tempC\":\"-1\",\"tempF\":\"31\",\"time\":\"700\",\"visibility\":\"2\",\"weatherCode\":\"143\",\"weatherDesc\":[{\"value\":\"Mist\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0006_mist.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"26\",\"winddir16Point\":\"WSW\",\"winddirDegree\":\"251\",\"WindGustKmph\":\"15\",\"WindGustMiles\":\"10\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"68\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"30\",\"DewPointC\":\"0\",\"DewPointF\":\"32\",\"FeelsLikeC\":\"0\",\"FeelsLikeF\":\"32\",\"HeatIndexC\":\"2\",\"HeatIndexF\":\"36\",\"humidity\":\"84\",\"precipMM\":\"0.0\",\"pressure\":\"1022\",\"tempC\":\"2\",\"tempF\":\"36\",\"time\":\"1000\",\"visibility\":\"10\",\"weatherCode\":\"116\",\"weatherDesc\":[{\"value\":\"Partly Cloudy\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png\"}],\"WindChillC\":\"0\",\"WindChillF\":\"32\",\"winddir16Point\":\"WNW\",\"winddirDegree\":\"286\",\"WindGustKmph\":\"9\",\"WindGustMiles\":\"6\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"}],\"maxtempC\":\"11\",\"maxtempF\":\"51\",\"mintempC\":\"3\",\"mintempF\":\"37\",\"uvIndex\":\"-999\"},{\"astronomy\":[{\"moonrise\":\"10:41 AM\",\"moonset\":\"11:50 PM\",\"sunrise\":\"07:23 AM\",\"sunset\":\"05:36 PM\"}],\"date\":\"2015-01-25\",\"hourly\":[{\"chanceoffog\":\"0\",\"chanceoffrost\":\"52\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"3\",\"DewPointC\":\"-3\",\"DewPointF\":\"26\",\"FeelsLikeC\":\"-3\",\"FeelsLikeF\":\"28\",\"HeatIndexC\":\"-3\",\"HeatIndexF\":\"28\",\"humidity\":\"94\",\"precipMM\":\"0.0\",\"pressure\":\"1020\",\"tempC\":\"-3\",\"tempF\":\"28\",\"time\":\"100\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-3\",\"WindChillF\":\"28\",\"winddir16Point\":\"SW\",\"winddirDegree\":\"216\",\"WindGustKmph\":\"6\",\"WindGustMiles\":\"4\",\"windspeedKmph\":\"3\",\"windspeedMiles\":\"2\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"36\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"0\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"61\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"2\",\"DewPointC\":\"-2\",\"DewPointF\":\"28\",\"FeelsLikeC\":\"-3\",\"FeelsLikeF\":\"26\",\"HeatIndexC\":\"0\",\"HeatIndexF\":\"31\",\"humidity\":\"87\",\"precipMM\":\"0.0\",\"pressure\":\"1018\",\"tempC\":\"0\",\"tempF\":\"31\",\"time\":\"400\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-3\",\"WindChillF\":\"26\",\"winddir16Point\":\"SSW\",\"winddirDegree\":\"209\",\"WindGustKmph\":\"16\",\"WindGustMiles\":\"10\",\"windspeedKmph\":\"8\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"34\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"4\",\"chanceofrain\":\"0\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"94\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"7\",\"DewPointC\":\"-2\",\"DewPointF\":\"29\",\"FeelsLikeC\":\"-4\",\"FeelsLikeF\":\"26\",\"HeatIndexC\":\"-1\",\"HeatIndexF\":\"31\",\"humidity\":\"90\",\"precipMM\":\"0.0\",\"pressure\":\"1016\",\"tempC\":\"-1\",\"tempF\":\"31\",\"time\":\"700\",\"visibility\":\"10\",\"weatherCode\":\"113\",\"weatherDesc\":[{\"value\":\"Clear\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png\"}],\"WindChillC\":\"-4\",\"WindChillF\":\"26\",\"winddir16Point\":\"SW\",\"winddirDegree\":\"216\",\"WindGustKmph\":\"18\",\"WindGustMiles\":\"11\",\"windspeedKmph\":\"9\",\"windspeedMiles\":\"5\"},{\"chanceoffog\":\"0\",\"chanceoffrost\":\"0\",\"chanceofhightemp\":\"0\",\"chanceofovercast\":\"7\",\"chanceofrain\":\"2\",\"chanceofremdry\":\"0\",\"chanceofsnow\":\"0\",\"chanceofsunshine\":\"100\",\"chanceofthunder\":\"0\",\"chanceofwindy\":\"0\",\"cloudcover\":\"97\",\"DewPointC\":\"0\",\"DewPointF\":\"32\",\"FeelsLikeC\":\"1\",\"FeelsLikeF\":\"35\",\"HeatIndexC\":\"5\",\"HeatIndexF\":\"40\",\"humidity\":\"72\",\"precipMM\":\"0.0\",\"pressure\":\"1015\",\"tempC\":\"5\",\"tempF\":\"40\",\"time\":\"1000\",\"visibility\":\"10\",\"weatherCode\":\"122\",\"weatherDesc\":[{\"value\":\"Overcast\"}],\"weatherIconUrl\":[{\"value\":\"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png\"}],\"WindChillC\":\"1\",\"WindChillF\":\"35\",\"winddir16Point\":\"SW\",\"winddirDegree\":\"223\",\"WindGustKmph\":\"18\",\"WindGustMiles\":\"11\",\"windspeedKmph\":\"15\",\"windspeedMiles\":\"9\"}],\"maxtempC\":\"13\",\"maxtempF\":\"55\",\"mintempC\":\"3\",\"mintempF\":\"38\",\"uvIndex\":\"-999\"}]}}';
        system.assertEquals(resposeString.length(),19579);
        return resposeString;
    }

  //return response string for validation of valid address for Cdyne callout
  /*public static testmethod string getGeoCodeJSONBodyOfCdyneCall()
  {
    String response = '<PavResponse xmlns="pav3.cdyne.com" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><CensusInfo><CMSA/><CensusBlockNumber/><CensusTractNumber/><FIPS/><MA/><MSA/><PMSA/></CensusInfo><CityName>ANNANDALE</CityName><Country>USA</Country><County>HUNTERDON</County><CountyNum>19</CountyNum><FinanceNumber>330210</FinanceNumber><FirmOrRecipient/><GeoLocationInfo><AreaCode>908</AreaCode><AvgLatitude>40.622795</AvgLatitude><AvgLongitude>-74.886322</AvgLongitude><FromLatitude>40.561001</FromLatitude><FromLongitude>-74.934525</FromLongitude><HasDaylightSavings>true</HasDaylightSavings><TimeZone>EST </TimeZone><ToLatitude>40.690880</ToLatitude><ToLongitude>-74.845642</ToLongitude></GeoLocationInfo><IntelligentMailBarcodeKey>XWKNKDm52OdZzCTL2K9brg==</IntelligentMailBarcodeKey><LegislativeInfo><CongressionalDistrictNumber>07</CongressionalDistrictNumber><StateLegislativeLower/><StateLegislativeUpper/></LegislativeInfo><MailingIndustryInfo i:nil="true"/><MultipleMatches i:nil="true"/><PMBDesignator/><PMBNumber/><PostDirectional/><PostnetBarcode>f088011639103f</PostnetBarcode><PreDirectional/><PreferredCityName>ANNANDALE</PreferredCityName><Primary>10</Primary><PrimaryDeliveryLine>10 ROXITICUS CT</PrimaryDeliveryLine><PrimaryEO>B</PrimaryEO><PrimaryHigh>99</PrimaryHigh><PrimaryLow>1</PrimaryLow><ResidentialDeliveryIndicator i:nil="true"/><ReturnCode>100</ReturnCode><Secondary/><SecondaryAbbreviation/><SecondaryDeliveryLine/><SecondaryEO/><SecondaryHigh/><SecondaryLow/><StateAbbreviation>NJ</StateAbbreviation><StreetName>ROXITICUS</StreetName><Suffix>CT</Suffix><Urbanization/><ZipCode>08801-1639</ZipCode></PavResponse>';
    return response;
  }*/

  //return response string for validation of valid address for Cdyne callout
  public static testmethod string getGeoCodeJSONBodyOfMapQuest()
  {
    String response = '{'+
    '\"info\":{'+
    '\"statuscode\":0,'+
    '\"copyright\":{'+
    '\"text\":\"\\u00A9 2015 MapQuest, Inc.\",'+
    '\"imageUrl\":\"http://api.mqcdn.com/res/mqlogo.gif\",'+
    '\"imageAltText\":\"\\u00A9 2015 MapQuest, Inc.\"'+
    '},'+
    '\"messages\":['+
    ']'+
    '},'+
    '\"options\":{'+
    '\"maxResults\":-1,'+
    '\"thumbMaps\":true,'+
    '\"ignoreLatLngInput\":false'+
    '},'+
    '\"results\":['+
    '{'+
    '\"providedLocation\":{'+
    '\"location\":\"Kalyani,Nagar,India\"'+
    '},'+
    '\"locations\":['+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Henry County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"TN\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283496253\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":36.332557,'+
    '\"lng\":-88.258097'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":36.332557,'+
    '\"lng\":-88.258097'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-1,36.332557,-88.258097,0,0,|¢er=36.332557,-88.258097&zoom=12&rand=-999589114\"'+
    '},'+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Stone County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"MS\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283486711\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":30.817134,'+
    '\"lng\":-89.11116'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":30.817134,'+
    '\"lng\":-89.11116'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-2,30.817134,-89.11116,0,0,|¢er=30.817134,-89.11116&zoom=12&rand=-190055589\"'+
    '},'+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Ellis County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"TX\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283417432\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":32.525138,'+
    '\"lng\":-96.616103'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":32.525138,'+
    '\"lng\":-96.616103'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-3,32.525138,-96.616103,0,0,|¢er=32.525138,-96.616103&zoom=12&rand=-1087421438\"'+
    '}'+
    ']'+
    '}'+
    ']'+
    '}'+
    '{'+
    '\"info\":{'+
    '\"statuscode\":0,'+
    '\"copyright\":{'+
    '\"text\":\"© 2015 MapQuest, Inc.\",'+
    '\"imageUrl\":\"http://api.mqcdn.com/res/mqlogo.gif\",'+
    '\"imageAltText\":\"© 2015 MapQuest, Inc.\"'+
    '},'+
    '\"messages\":{'+
    '}'+
    '},'+
    '\"options\":{'+
    '\"maxResults\":-1,'+
    '\"thumbMaps\":true,'+
    '\"ignoreLatLngInput\":false'+
    '},'+
    '\"results\":['+
    '{'+
    '\"providedLocation\":{'+
    '\"location\":\"Kalyani,Nagar,India\"'+
    '},'+
    '\"locations\":['+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Henry County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"TN\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283496253\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":36.332557,'+
    '\"lng\":-88.258097'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":36.332557,'+
    '\"lng\":-88.258097'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-1,36.332557,-88.258097,0,0,|¢er=36.332557,-88.258097&zoom=12&rand=-999589114\"'+
    '},'+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Stone County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"MS\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283486711\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":30.817134,'+
    '\"lng\":-89.11116'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":30.817134,'+
    '\"lng\":-89.11116'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-2,30.817134,-89.11116,0,0,|¢er=30.817134,-89.11116&zoom=12&rand=-190055589\"'+
    '},'+
    '{'+
    '\"street\":\"\",'+
    '\"adminArea6\":\"\",'+
    '\"adminArea6Type\":\"Neighborhood\",'+
    '\"adminArea5\":\"India\",'+
    '\"adminArea5Type\":\"City\",'+
    '\"adminArea4\":\"Ellis County\",'+
    '\"adminArea4Type\":\"County\",'+
    '\"adminArea3\":\"TX\",'+
    '\"adminArea3Type\":\"State\",'+
    '\"adminArea1\":\"US\",'+
    '\"adminArea1Type\":\"Country\",'+
    '\"postalCode\":\"\",'+
    '\"geocodeQualityCode\":\"A5XBX\",'+
    '\"geocodeQuality\":\"CITY\",'+
    '\"dragPoint\":false,'+
    '\"sideOfStreet\":\"N\",'+
    '\"linkId\":\"283417432\",'+
    '\"unknownInput\":\"\",'+
    '\"type\":\"s\",'+
    '\"latLng\":{'+
    '\"lat\":32.525138,'+
    '\"lng\":-96.616103'+
    '},'+
    '\"displayLatLng\":{'+
    '\"lat\":32.525138,'+
    '\"lng\":-96.616103'+
    '},'+
    '\"mapUrl\":\"http://www.mapquestapi.com/staticmap/v4/getmap?key=CarMSF6E9Pq6e77VsutM8A1mAtDGVWPl&type=map&size=225,160&pois=purple-3,32.525138,-96.616103,0,0,|¢er=32.525138,-96.616103&zoom=12&rand=-1087421438\"'+
    '}'+
    ']'+
    '}'+
    ']'+
    '}';
    system.assertNotEquals(response, null);
    return response;
  }  
}