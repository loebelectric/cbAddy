## cbAddy
cbAddy is an address validation module which accepts input structs of addresses
and tells you if they are valid or not. As it is based on the UPS, USPS, and Avalara APIs,
cbAddy requires credentials from these services to be used. To receive credentials for 
these services, please refer to the links below:


UPS: https://www.ups.com/upsdeveloperkit?loc=en_US (Free)

USPS: https://www.usps.com/business/web-tools-apis/ (Free)

Avalara: https://www.avalara.com/us/en/products/calculations.html (Need to have an Avatax account to use the API, which costs money)


### Example of use

Define your API access information in the coldbox.cfc module settings

``` 
moduleSettings = {
    cbaddy = {
                defaultApi = "avalara",
                uspsUserId = "XXXXX",
                upsUsername = "XXXXX",
                upsPassword = "XXXXX",
                upsApiKey = "XXXXX",
                avalaraAuthorization = "XXXXX",
                .
                .
                .
            }
}
```

Inject cbAddy into ithin one of your handlers with wirebox

```
property name="cbAddy"      inject="cbAddy@addressValidationClient";


inputAddress = {
    "addressLine1" : "1800 E 5th Avenue",
    "city" : "Columbus",
    "stateOrProvince" : "Ohio",
    "zipCode" : "43219",
    "countryCode" : "US"
};

validationResult = cbAddy.validate(inputAddress);
```


### To install:

Run the following command to install cbaddy into your coldbox project (commandbox must be installed):

```
box install cbaddy
```

## User Guide

Users of cbAddy will primarily use the following function:

```
struct function validate(required struct address, validationService="avalara", string output="standardized")
```

PARAMETERS:
@address - A struct containing the address that you want to validate. It should contain the following key-value pairs (all strings):

    "consigneeName" :   Name of the business, company or person associated with the address.
    
    "buildingName" :    Name of the building associated with the address
    
    "addressLine1" :    Address line (contains street number, name, and type)
    
    "addressLine2" :    2nd address line
    
    "addressLine3" :    3rd address line
    
    "region" :          Combination of city, state, and zip code. If included, will override validation of what is input for "city", "state", "zipCode", and "zipExt".
    
    "city" :            City or town name
    
    "stateOrProvince" : State or province/territory name
    
    "zipCode" :         Postal code
    
    "zipExt" :          4 digit postal code extension. For US use only
    
    "prUrbanization" :  Political division 3. Only valid for Puerto Rico.
    
    "countryCode" :     Country code. United states = US. A list of more valid values can be found in the back of
                        UPS street level address validation API guide found here: https://www.ups.com/upsdeveloperkit?loc=en_US


@validationService - A string which names the type of address validation service you wish to access. The following are
                    a list of valid values for this parameter. Some of these services will provide suggested addresses
                    if the one you tried to validate was found to be invalid. "Avalara" is default, but can be changed
                    in the module settings.
                    
                    "usps"
                    
                        -Provides a robust set of corrections to submitted addresses
                        
                        -Only supports US and Puerto Rico
                        
                        -Validates down to street level
                        
                        
                    "upsCityStateZip"
                    
                        -Supports suggestions
                        
                        -Only US and Puerto Rico
                        
                        -Only validates city, state, and zip code combinations
                        
                        -If city, state, or zip is missing from the request, there may be errors or inaccuracy in your validation
                        
                        
                    "upsStreetLevel"
                    
                        -Supports suggestions
                        
                        -Only US and Puerto Rico
                        
                        -Validates down to street level
                        
                        
                    "avalara"
                    
                        -Validates down to street level
                        
                        -Only US and Canada
                        
                        -Provides tax authority information
                        

@output The format with which to format the output data. There are several valid options for output:

        "standardized"
        
            -The standardized form of output between all API clients in cbaddy
            
            -The default option
            
            -A struct with the following members:
            
                            "valid" : boolean indicating whether or not the address was valid 
                            "clientSpecific" : struct containing all of the response variables unique to the specific API client
                            "messages" : array of messages containing any information relevant to validation, errors, etc.
                            
                            
        "struct" / "structure"
        
            -The filecontent of the API response casted to a struct
            
        "raw"
        
            -The raw API response with all of the HTTP request metadata
            

Other functions available for you to use in cbaddy:

```
pingAvalara()
```

    -No Parameters
    
    -Pings the Avalara API to test the state of the client's connection


### Author
Jeff Stevens

Software Developer @ Loeb Electric, your trusted electrical distributor: https://loebelectric.com/

Independent Game Developer @ Bucephalus Studios: https://bucephalus.itch.io/

Linkedin: https://www.linkedin.com/in/jeff-s-819217123/
