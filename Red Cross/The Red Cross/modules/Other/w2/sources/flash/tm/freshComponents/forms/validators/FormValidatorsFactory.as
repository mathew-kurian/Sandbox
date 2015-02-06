class tm.freshComponents.forms.validators.FormValidatorsFactory
{
	function FormValidatorsFactory () {
	}
	static function create(type) {
		switch (type) {
			case tm.freshComponents.forms.validators.FormValidatorType["STRING"] : 
				return(new tm.freshComponents.forms.validators.StringValidator());
			case tm.freshComponents.forms.validators.FormValidatorType["NUMBER"] : 
				return(new tm.freshComponents.forms.validators.NumberValidator());
			case tm.freshComponents.forms.validators.FormValidatorType.EMAIL : 
				return(new tm.freshComponents.forms.validators.EmailValidator());
			case tm.freshComponents.forms.validators.FormValidatorType["DATE"] : 
				return(new tm.freshComponents.forms.validators.DateValidator());
		}
		return(null);
	}
}
