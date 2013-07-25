/******************************************************************************
 * jquery.i18n.properties
 * 
 * Dual licensed under the GPL (http://dev.jquery.com/browser/trunk/jquery/GPL-LICENSE.txt) and 
 * MIT (http://dev.jquery.com/browser/trunk/jquery/MIT-LICENSE.txt) licenses.
 * 
 * @version     1.0.x
 * @author      Nuno Fernandes
 * @url         www.codingwithcoffee.com
 * @inspiration Localisation assistance for jQuery (http://keith-wood.name/localisation.html)
 *              by Keith Wood (kbwood{at}iinet.com.au) June 2007
 * 
 *****************************************************************************/

(function($) {
$.i18n = {};

/** Map holding bundle keys (if mode: 'map') */
$.i18n.map = {};

/**
 * Load and parse message bundle files (.properties),
 * making bundles keys available as javascript variables.
 * 
 * i18n files are named <name>.js, or <name>_<language>.js or <name>_<language>_<country>.js
 * Where:
 *      The <language> argument is a valid ISO Language Code. These codes are the lower-case, 
 *      two-letter codes as defined by ISO-639. You can find a full list of these codes at a 
 *      number of sites, such as: http://www.loc.gov/standards/iso639-2/englangn.html
 *      The <country> argument is a valid ISO Country Code. These codes are the upper-case,
 *      two-letter codes as defined by ISO-3166. You can find a full list of these codes at a
 *      number of sites, such as: http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html
 * 
 * Sample usage for a bundles/Messages.properties bundle:
 * $.i18n.properties({
 *      name:      'Messages', 
 *      language:  'en_US',
 *      path:      'bundles'
 * });
 * @param  name			(string/string[], required) names of file to load (eg, 'Messages' or ['Msg1','Msg2'])
 * @param  language		(string, optional) language/country code (eg, 'en', 'en_US', 'pt_PT'). if not specified, language reported by the browser will be used instead.
 * @param  path			(string, optional) path of directory that contains file to load
 * @param  mode			(string, optional) whether bundles keys are available as JavaScript variables/functions or as a map (eg, 'vars' or 'map')
 * @param  callback     (function, optional) callback function to be called after script is terminated
 */
$.i18n.properties = function(settings) {
	// set up settings
    var defaults = {
        name:           'Messages',
        language:       '',
        path:           '',  
        mode:           'vars',       
        callback:       function(){}
    };
    settings = $.extend(defaults, settings);    
    if(settings.language === null || settings.language == '') {
	   settings.language = $.i18n.browserLang();//normaliseLanguageCode(navigator.language /* Mozilla */ || navigator.userLanguage /* IE */);
	}
	if(settings.language === null) {settings.language='';}
	
	// load and parse bundle files
	var files = getFiles(settings.name);
	for(i=0; i<files.length; i++) {
		// 1. load base (eg, Messages.properties)
		loadAndParseFile(settings.path + files[i] + '.properties', settings.language, settings.mode);
        // 2. with language code (eg, Messages_pt.properties)
		if(settings.language.length >= 2) {
            loadAndParseFile(settings.path + files[i] + '_' + settings.language.substring(0, 2) +'.properties', settings.language, settings.mode);
		}
		// 3. with language code and country code (eg, Messages_pt_PT.properties)
        if(settings.language.length >= 5) {
            loadAndParseFile(settings.path + files[i] + '_' + settings.language.substring(0, 5) +'.properties', settings.language, settings.mode);
        }
	}
	
	// call callback
	if(settings.callback){ settings.callback(); }
};


/**
 * When configured with mode: 'map', allows access to bundle values by specifying its key.
 * Eg, jQuery.i18n.prop('com.company.bundles.menu_add')
 */
$.i18n.prop = function(key, placeHolderValues) {
	var value = $.i18n.map[key];
	if(value == null) { return '[' + key + ']'; }
	if(!placeHolderValues) {
    //if(key == 'spv.lbl.modified') {alert(value);}
		return value;
	}else{
		for(var i=0; i<placeHolderValues.length; i++) {
			var regexp = new RegExp('\\{('+i+')\\}', "g");
			value = value.replace(regexp, placeHolderValues[i]);
		}
		return value;
	}
};

/** Language reported by browser, normalized code */
$.i18n.browserLang = function() {
	return normaliseLanguageCode(navigator.language /* Mozilla */ || navigator.userLanguage /* IE */);
}


/** Load and parse .properties files */
function loadAndParseFile(filename, language, mode) {
    $.ajax({
        url:        filename,
        async:      false,
        contentType: "text/plain;charset=UTF-8",
        dataType:   'text',
        success:    function(data, status) {
                       var parsed = '';
                       var parameters = data.split( /\n/ );
                       var regPlaceHolder = /(\{\d+\})/g;
                       var regRepPlaceHolder = /\{(\d+)\}/g;
                       var unicodeRE = /(\\u.{4})/ig;
                       for(var i=0; i<parameters.length; i++ ) {
                           parameters[i] = parameters[i].replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim
                           if(parameters[i].length > 0 && parameters[i].match("^#")!="#") { // skip comments
                               var pair = parameters[i].split('=');
                               if(pair.length > 0) {
                                   /** Process key & value */
                                   var name = unescape(pair[0]).replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim
                                   var value = pair.length == 1 ? "" : pair[1];
                                   for(var s=2;s<pair.length;s++){ value +='=' + pair[s]; }
                                   value = value.replace( /"/g, '\\"' ); // escape quotation mark (")
                                   value = value.replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim  
                                   
                                   /** Mode: bundle keys in a map */
                                   if(mode == 'map' || mode == 'both') {
                                       // handle unicode chars possibly left out
                                       var unicodeMatches = value.match(unicodeRE);
                                       if(unicodeMatches) {
                                         for(var u=0; u<unicodeMatches.length; u++) {
                                            value = value.replace( unicodeMatches[u], unescapeUnicode(unicodeMatches[u]));
                                         }
                                       }
                                       // add to map
                                       $.i18n.map[name] = value;
                                   }
                                   
                                   /** Mode: bundle keys as vars/functions */
                                   if(mode == 'vars' || mode == 'both') {
                                       // make sure namespaced key exists (eg, 'some.key') 
                                       checkKeyNamespace(name);
                                       
                                       // value with variable substitutions
                                       if(regPlaceHolder.test(value)) {
                                           var parts = value.split(regPlaceHolder);
                                           // process function args
                                           var first = true;
                                           var fnArgs = '';
                                           var usedArgs = [];
                                           for(var p=0; p<parts.length; p++) {
                                               if(regPlaceHolder.test(parts[p]) && usedArgs.indexOf(parts[p]) == -1) {
                                                   if(!first) {fnArgs += ',';}
                                                   fnArgs += parts[p].replace(regRepPlaceHolder, 'v$1');
                                                   usedArgs.push(parts[p]);
                                                   first = false;
                                               }
                                           }
                                           parsed += name + '=function(' + fnArgs + '){';
                                           // process function body
                                           var fnExpr = '"' + value.replace(regRepPlaceHolder, '"+v$1+"') + '"';
                                           parsed += 'return ' + fnExpr + ';' + '};';
                                           
                                       // simple value
                                       }else{
                                           parsed += name+'="'+value+'";';
                                       }
                                   }
                               }
                           }
                       }
                       eval(parsed);
                   }
    });
}

/** Make sure namespace exists (for keys with dots in name) */
function checkKeyNamespace(key) {
	var regDot = /\./;
	if(regDot.test(key)) {
		var fullname = '';
		var names = key.split( /\./ );
		for(var i=0; i<names.length; i++) {
			if(i>0) {fullname += '.';}
			fullname += names[i];
			if(eval('typeof '+fullname+' == "undefined"')) {
				eval(fullname + '={};');
			}
		}
	}
}

/** Make sure filename is an array */
function getFiles(names) {
	return (names && names.constructor == Array) ? names : [names];
}

/** Ensure language code is in the format aa_AA. */
function normaliseLanguageCode(lang) {
    lang = lang.toLowerCase();
    if(lang.length > 3) {
        lang = lang.substring(0, 3) + lang.substring(3).toUpperCase();
    }
    return lang;
}

/** Unescape unicode chars ('\u00e3') */
function unescapeUnicode(str) {
  // unescape unicode codes
  var codes = [];
  var code = parseInt(str.substr(2), 16);
  if (code >= 0 && code < Math.pow(2, 16)) {
     codes.push(code);
  }
  // convert codes to text
  var unescaped = '';
  for (var i = 0; i < codes.length; ++i) {
    unescaped += String.fromCharCode(codes[i]);
  }
  return unescaped;
}

})(jQuery);
