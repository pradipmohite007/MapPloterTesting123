@deprecated

global with sharing class Encoder {
  
  private static final String[] HTML_DECODED  = new String[]{ '&', '<', '>', '"', '\''};
  private static final String[] HTML_ENCODED  = new String[]{ '&amp;', '&lt;', '&gt;', '&quot;', '&#39;' };
  
  private static final String[] JS_DECODED = new String[] { '\\', '\'', '\n', '\r', '"', '!--', '/', '<', '>' };
  private static final String[] JS_ENCODED = new String[] { '\\\\', '\\\'', '\\n', '\\r', '\\"', '\\!--', '\\/', '\\u003C', '\\u003E' };
    
  private static final String[] JSINHTML_DECODED = new String[] { '&', '\\', '\'', '"', '\r', '\n', '<', '>' };
  private static final String[] JSINHTML_ENCODED = new String[] { '&amp;', '\\\\', '\\\'', '\\&quot;', '\\r', '\\n', '&lt;', '&gt;' };

  
   /* Similar to the VisualForce HTMLENCODE function. 
   * Example:
   * //htmlstr is going to be sent to visualforce as html code
   * htmlstr = '&lt;div&gt;' + Encoder.SFDC_HTMLENCODE(unsafe_text) + '&lt;/div&gt;';
   */
  global static String SFDC_HTMLENCODE(String input) {
    return ENCODE(input, HTML_DECODED, HTML_ENCODED);
  }

   /* Similar to the VisualForce JSENCODE function. 
   * Example:
   * //htmlstr is going to be sent to visualforce as html code
   * htmlstr = '&lt;script&gt; var str = "' + Encoder.SFDC_JSENCODE(unsafe_text) + '";&lt;/script&gt;';
   */
  global static String SFDC_JSENCODE(String input) {
    return ENCODE(input, JS_DECODED, JS_ENCODED);
  }

   /* Similar to the VisualForce JSINHTMLENCODE function. <br><br>
   * Example:<br>
   * //htmlstr is going to be sent to visualforce as html code
   * htmlstr = '&lt;div onclick=\'alert("' + Encoder.SFDC_JSINHTMLENCODE(unsafe_text) + '");\'&gt;some text&lt;/div&gt;';
   */
  global static String SFDC_JSINHTMLENCODE(String input) {
    return ENCODE(input, JSINHTML_DECODED, JSINHTML_ENCODED);
  }

  /**
   * Similar to the VisualForce URLENCODE function. 
   * 
   * Note : This function always encodes into UTF-8 URL encoding
   *  - if you need another encoding type,
   *  use the second function which allows to set the encoding. 
   *  
   * Note : Even when using this function you should still not trust the input as a full 
   *  URL because it may have JS or load data from other domains. this function just makes 
   *  sure the input is encoded as proper URL. 
   * 
   * Example:
   * //htmlstr is going to be sent to visualforce as html code
   * htmlstr = '&lt;img src=\'http://domain/' + Encoder.SFDC_URLENCODE(unsafe_text) + '\' /&gt;';
   */
  global static String SFDC_URLENCODE(String input) {
    return EncodingUtil.urlEncode(input, 'UTF-8');
  }

  /**
   * Similar to {@link #SFDC_URLENCODE(String) SFDC_URLENCODE}(String&nbsp;input) but 
   *  allows to set specific encoding type.
   * 
   * Example:
   * //htmlstr is going to be sent to visualforce as html code
   * htmlstr = '&lt;img src=\'http://domain/' + Encoder.SFDC_URLENCODE(unsafe_text, 'ISO-8859-1') + '\' /&gt;';
   * 
   */
  global static String SFDC_URLENCODE(String input, String encoding) {
    return EncodingUtil.urlEncode(input, encoding);
  }

  private static String ENCODE(String input, String[] fromArr, String[] toArr) {
    if (input == null || input.length() == 0)
      return input;

    for (Integer i = 0; i < fromArr.size(); ++i) {
      input = input.replace(fromArr[i], toArr[i]);
    }
    
    return input;
  }
}