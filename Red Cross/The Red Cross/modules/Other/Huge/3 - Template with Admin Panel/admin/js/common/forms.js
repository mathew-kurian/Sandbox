		function ShowHideFormsFields(value , fields) {

			for ( i in fields[value] ) {
				document.getElementById("XML_BODY_FIELD_" + i).style.display = fields[value][i];
				document.getElementById("XML_BODY_FIELD_" + i).style.width = "100%";
			}
		} 


		function XMLFormsPhone( part , id , max1 , max2 , max3) {
			var part_1 = document.getElementById(id + "_1");
			var part_2 = document.getElementById(id + "_2");
			var part_3 = document.getElementById(id + "_3");

			if ((part == 1) && (part_2.value.length !=max2) && (part_1.value.length == max1))
				part_2.focus();

			if ((part == 2) && (part_3.value.length !=max3) && (part_2.value.length == max2))
				part_3.focus();
		}


		function XMLFormSelectAll( form , from , to ) {
			var xform = document.forms[form];
			var img = document.getElementById(form + '_check_button');	
			var current = document.getElementById(form + '_current').value;	

			var source_check = "images/common/button_checked.gif";
			var source_uncheck = "images/common/button_unchecked.gif";

			for (var i = from ; i <= to ; i++ ) {		
				if (current == 0)
					document.getElementById(form + "_multiple_" + i ).checked = true;
				else
					document.getElementById(form + "_multiple_" + i ).checked = false;

			}
			if (current == 0) {
				img.src = source_uncheck;
				document.getElementById(form + '_current').value = 1;
			} else {
				img.src = source_check;
				document.getElementById(form + '_current').value = 0;
			}
		}

		function XMLFormsDoubleSelectAdd( source , destination , end) {
			source = document.getElementById(source);
			destination = document.getElementById(destination);

			var count = destination.options.length;

			for (var i = 0; i < source.options.length; i++) {          
				if ( source.options[i].selected == true ){
					
					found = false;
					for ( j=0; j<destination.options.length ; j++ ) {
						if (destination.options[j].value == source.options[i].value ) {
							found = true;
						}
					}

					if ((!found) && source.options[i].value && source.options[i].text) {
						destination.options[count] = new Option(source.options[i].text , source.options[i].value);
						count++;
					}
					
				}
			}

			XMLFormsDoubleSelectUpdate( destination , end );
		}

		function XMLFormsDoubleSelectRem( source , end ) {
			source = document.getElementById(source);
			for (var i = source.options.length - 1; i >= 0 ; i--) {          
				if ( source.options[i].selected == true ){
					source.options[i] = null;
				}
			}

			XMLFormsDoubleSelectUpdate( source , end );
		}


		function XMLFormsDoubleSelectUpdate( source , end){

			var values = new Array(source.options.length);
			var count = 0;

			for (var i = 0; i<source.options.length ;  i++) {
				if (source.options[i].value && source.options[i].text) {
					values[count] = source.options[i].value;
					count ++;
				}
			}

			document.getElementById(end).value = values.join(',');
		}


		function XMLFormsShowElements(value , fields) {
			for ( i in fields[value] ) {
				document.getElementById("XML_BODY_FIELD_" + i).style.display = fields[value][i];
				document.getElementById("XML_BODY_FIELD_" + i).style.width = "100%";
			}
		} 
