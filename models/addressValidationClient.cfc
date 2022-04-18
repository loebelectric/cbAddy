component
{
    //Module settings
    property name="defaultApi" 		        inject="coldbox:setting:defaultApi@cbaddy";
    property name="uspsUserId"              inject="coldbox:setting:uspsUserId@cbaddy";
    property name="upsUsername"             inject="coldbox:setting:upsUsername@cbaddy";
    property name="upsPassword"             inject="coldbox:setting:upsPassword@cbaddy";
    property name="upsApiKey"               inject="coldbox:setting:upsApiKey@cbaddy";
    property name="avalaraAuthorization"    inject="coldbox:setting:avalaraAuthorization@cbaddy";
    property name="avalaraMessages"         type="struct" inject="coldbox:setting:avalaraMessages@cbaddy";
    property name="uspsMessages"            type="struct" inject="coldbox:setting:uspsMessages@cbaddy";
    property name="upsMessages"             type="struct" inject="coldbox:setting:upsMessages@cbaddy";
    property name="upsStreetLevelMessages"  type="struct" inject="coldbox:setting:upsStreetLevelMessages@cbaddy";

    //Modules
    property name = "xmlTool"          inject="xmlTool@formatter";


    //Default constructor
    addressValidationClient function init()
    {
        return this;
    }


    /**
     * Modifies text to make it uniform for the purpose of comparing parts of an address.
     * The process is as follows:
     *  -Remove all punctuation (right now, only periods)
     *  -Removes instances of double or more spaces and changes them to single spaces
     *  -Make it uppercase
     * 
     * @inputString The text to make uniform
     * @return The modified version of the input text such that it is standardized for comparisons within the addressValidationClient
     */
    private string function uniformString(required string inputString)
    {
        //Remove all periods
        arguments.inputString = reReplaceNoCase(arguments.inputString, "\.", '');

        //Remove extra spaces
        arguments.inputString = reReplaceNoCase(arguments.inputString, "/\s+", ' ');

        //Make it uppercase
        arguments.inputString = uCase(arguments.inputString);

        //Trim to remove leading and trailing spaces
        arguments.inputString = trim(arguments.inputString);

        return arguments.inputString;
    }


    /**
     * Modifies text in address lines by replacing words like "avenue" and "drive" with "AVE" and "DR"
     * respectively.
     *
     * @inputString The address line text to modify
     * @return The modified version of the input text such that all recognizable address words are abbreviated
     * 
     */
    private string function abbreviateAddressLine(required string inputString)
    {
        /* Apply a series of reReplace functions for each abbreviation*/ 
        //Avenue to AVE
        arguments.inputString = reReplaceNoCase(arguments.inputString, "avenue", "AVE");
        //Boulevard to BLVD
        arguments.inputString = reReplaceNoCase(arguments.inputString, "boulevard", "BVLD");
        //Center to CTR
        arguments.inputString = reReplaceNoCase(arguments.inputString, "center", "CTR");
        //Circle to CIR
        arguments.inputString = reReplaceNoCase(arguments.inputString, "circle", "CIR");
        //Court to CT
        arguments.inputString = reReplaceNoCase(arguments.inputString, "court", "CT");
        //Drive to DR
        arguments.inputString = reReplaceNoCase(arguments.inputString, "drive", "DR");
        //Expressway to EXPY
        arguments.inputString = reReplaceNoCase(arguments.inputString, "expressway", "EXPY");
        //Heights to HTS
        arguments.inputString = reReplaceNoCase(arguments.inputString, "heights", "HTS");
        //Island to IS
        arguments.inputString = reReplaceNoCase(arguments.inputString, "island", "IS");
        //Junction to JCT
        arguments.inputString = reReplaceNoCase(arguments.inputString, "junction", "JCT");
        //Lake to LK
        arguments.inputString = reReplaceNoCase(arguments.inputString, "lake", "LK");
        //Lane to LN
        arguments.inputString = reReplaceNoCase(arguments.inputString, "lane", "LN");
        //Mountain to MTN
        arguments.inputString = reReplaceNoCase(arguments.inputString, "mountain", "MTN");
        //Parkway to PKWY
        arguments.inputString = reReplaceNoCase(arguments.inputString, "parkway", "PKWY");
        //Place to PL
        arguments.inputString = reReplaceNoCase(arguments.inputString, "place", "PL");
        //Plaza to PLZ
        arguments.inputString = reReplaceNoCase(arguments.inputString, "plaza", "PLZ");
        //Ridge to RDG
        arguments.inputString = reReplaceNoCase(arguments.inputString, "ridge", "RDG");
        //Road to RD
        arguments.inputString = reReplaceNoCase(arguments.inputString, "road", "RD");
        //Square to SQ
        arguments.inputString = reReplaceNoCase(arguments.inputString, "square", "SQ");
        //Street to ST
        arguments.inputString = reReplaceNoCase(arguments.inputString, "street", "ST");
        //Station to STA
        arguments.inputString = reReplaceNoCase(arguments.inputString, "station", "STA");
        //Terrace to TER
        arguments.inputString = reReplaceNoCase(arguments.inputString, "terrace", "TER");
        //Trail to TRL
        arguments.inputString = reReplaceNoCase(arguments.inputString, "trail", "TRL");
        //Turnpike to TPKE
        arguments.inputString = reReplaceNoCase(arguments.inputString, "turnpike", "TPKE");
        //Township to TWP
        arguments.inputString = reReplaceNoCase(arguments.inputString, "township", "TWP");
        //Valley to VLY
        arguments.inputString = reReplaceNoCase(arguments.inputString, "valley", "VLY");
        //Way to WAY
        arguments.inputString = reReplaceNoCase(arguments.inputString, "way", "WAY");
        //Apartment to APT
        arguments.inputString = reReplaceNoCase(arguments.inputString, "apartment", "APT");
        //Room to RM
        arguments.inputString = reReplaceNoCase(arguments.inputString, "room", "RM");
        //Suite to STE
        arguments.inputString = reReplaceNoCase(arguments.inputString, "suite", "STE");
        //North to N
        arguments.inputString = reReplaceNoCase(arguments.inputString, "north", "N");
        //East to E
        arguments.inputString = reReplaceNoCase(arguments.inputString, "east", "E");
        //South to S
        arguments.inputString = reReplaceNoCase(arguments.inputString, "south", "S");
        //West to W
        arguments.inputString = reReplaceNoCase(arguments.inputString, "west", "W");
        //Northeast to NE
        arguments.inputString = reReplaceNoCase(arguments.inputString, "northeast", "NE");
        //Northwest to NW
        arguments.inputString = reReplaceNoCase(arguments.inputString, "northwest", "NW");
        //Southeast to SE
        arguments.inputString = reReplaceNoCase(arguments.inputString, "southeast", "SE");
        //Southwest to SW
        arguments.inputString = reReplaceNoCase(arguments.inputString, "southwest", "SW");

        return arguments.inputString;
    }


    /**
     * Given the  filecontent of a USPS API response, this function analyzes the XML tags which state the validity
     * of an address and any other corrections/important information about the address.
     * 
     * @fileContent The filecontent string from the USPS address validation API response
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     *       
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function analyzeUSPS(required struct apiResponse, string output="standardized")
    {
        if(arguments.output == "standardized")
        {
            local.xml = xmlParse(arguments.apiResponse.fileContent);
            local.processedXmlResponse = xmlTool.convertXMLtoStruct(local.xml);
            if(local.processedXmlResponse.keyExists("address"))
            {
                local.validationData = local.processedXmlResponse.address[2];
                local.returnStruct["clientSpecific"] = local.validationData;
                local.returnStruct["messages"] = [];
                local.returnStruct["valid"] = true; //Begin the validity of the validation response as true, but then change it to false once we find an invalidation
                /* Check for the validity of the address in the response */
                //Check for Errors
                if(isDefined("local.validationData.Error"))
                {
                    //Address not found
                    if(uniformString(local.validationData["Error"][2]["Description"][1]) == "ADDRESS NOT FOUND")
                    {
                        local.returnStruct["valid"] = false;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg1"]);
                    }
                    //Invalid state code
                    else if(uniformString(local.validationData["Error"][2]["Description"][1]) == "INVALID STATE CODE")
                    {
                        local.returnStruct["valid"] = false;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg2"]);
                    }
                    //Invalid city
                    else if(uniformString(local.validationData["Error"][2]["Description"][1]) == "INVALID CITY")
                    {
                        local.returnStruct["valid"] = false;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg3"]);
                    }
                    return local.returnStruct;
                }
                else
                {
                    /* If no error is returned, we check for USPS' codes */
                    if(isDefined("local.validationData.Footnotes"))
                    {
                        // Zip code corrected
                        if(listContains(local.validationData.footnotes[1],"A"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg4"]);
                        }
                        // City / State spelling corrected
                        if(listContains(local.validationData.footnotes[1],"B"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg5"]);
                        }
                        // Invalid City / State / Zip
                        if(listContains(local.validationData.footnotes[1],"C"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg6"]);
                        }
                        // No ZIP+4 assigned
                        if(listContains(local.validationData.footnotes[1],"D"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg7"]);
                        }
                        // Zip Code assigned for multiple response
                        if(listContains(local.validationData.footnotes[1],"E"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg8"]);
                        }
                        // Address could not be found in the national directory file database
                        if(listContains(local.validationData.footnotes[1],"F"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg9"]);
                        }
                        // Information in firm line used for matching
                        if(listContains(local.validationData.footnotes[1],"G"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg10"]);
                        }
                        // Missing secondary number
                        if(listContains(local.validationData.footnotes[1],"H"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg11"]);
                        }
                        // Insufficient / Incorrect Address Data
                        if(listContains(local.validationData.footnotes[1],"I"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg12"]);
                        }
                        // Dual Address
                        if(listContains(local.validationData.footnotes[1],"J"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg13"]);
                        }
                        // Multiple response due to Cardinal Rule
                        if(listContains(local.validationData.footnotes[1],"K"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg14"]);
                        }
                        // Address component changed
                        if(listContains(local.validationData.footnotes[1],"L"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg15"]);
                        }
                        // Match has been converted with LACS
                        if(listContains(local.validationData.footnotes[1],"Li"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg16"]);
                        }
                        // Street name changed
                        if(listContains(local.validationData.footnotes[1],"M"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg17"]);
                        }
                        // Address Standardized
                        if(listContains(local.validationData.footnotes[1],"N"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg18"]);
                        }
                        // Lowest +4 Tie-Breaker
                        if(listContains(local.validationData.footnotes[1],"O"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg19"]);
                        }
                        // Better address exists
                        if(listContains(local.validationData.footnotes[1],"P"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg20"]);
                        }
                        // Unique Zip code match
                        if(listContains(local.validationData.footnotes[1],"Q"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg21"]);
                        }
                        // No match due to EWS
                        if(listContains(local.validationData.footnotes[1],"R"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg22"]);
                        }
                        // Incorrect secondary address
                        if(listContains(local.validationData.footnotes[1],"S"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg23"]);
                        }
                        // Multiple response due to magnet street syndrome
                        if(listContains(local.validationData.footnotes[1],"T"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg24"]);
                        }
                        // Unofficial Post Office name
                        if(listContains(local.validationData.footnotes[1],"U"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg25"]);
                        }
                        // Unverifiable City / State
                        if(listContains(local.validationData.footnotes[1],"V"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg26"]);
                        }
                        // Invalid Delivery Address
                        if(listContains(local.validationData.footnotes[1],"W"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg27"]);
                        }
                        // No match due to out of range alias
                        if(listContains(local.validationData.footnotes[1],"X"))
                        {
                            local.returnStruct["valid"] = false;
                            local.returnStruct["messages"].append(variables.uspsMessages["msg28"]);
                        }
                        // Military match
                        if(listContains(local.validationData.footnotes[1],"Y"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg29"]);
                        }
                        // Match made using the ZIPMOVE product data
                        if(listContains(local.validationData.footnotes[1],"Z"))
                        {
                            local.returnStruct["messages"].append(variables.uspsMessages["msg30"]);
                        }
                    }
                }
                //Used to determine if the address is considered deliverable or undeliverable
                if(isDefined("local.validationData.DPVConfirmation")) 
                {
                    // Address was DPV confirmed for both primary and (if present) secondary numbers
                    if(find("Y",local.validationData.DPVConfirmation[1],1))
                    {
                        local.returnStruct["valid"] = true;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg31"]);
                    }
                    // Address was DPV confirmed for the primary number only and the secondary number information was missing
                    else if(find("D",local.validationData.DPVConfirmation[1],1))
                    {
                        local.returnStruct["valid"] = true;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg32"]);
                    }
                    // Address was DPV confirmed for the primary number only and the secondary number information was present by not confirmed
                    else if(find("S",local.validationData.DPVConfirmation[1],1))
                    {
                        local.returnStruct["valid"] = true;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg33"]);
                    }
                    // Both primary and (if present) seocndary number information failed to DPV confirm.
                    else if(find("N",local.validationData.DPVConfirmation[1],1))
                    {
                        local.returnStruct["valid"] = false;
                        local.returnStruct["messages"].append(variables.uspsMessages["msg34"]);
                    }
                }
                return returnStruct;
            }
            else
            {
                //The API response in XML had a problem being read
                local.returnStruct["clientSpecific"] = local.processedXmlResponse;
                local.returnStruct["messages"] = ["There was an error parsing the XML of the API request."];
                local.returnStruct["valid"] = false;
                return local.returnStruct;
            }
        }
        else if(arguments.output == "struct" || arguments.output == "structure")
        {
            local.xml = xmlParse(arguments.apiResponse.fileContent);
            local.validationData = xmlTool.convertXMLtoStruct(local.xml).address[2];
            return validationData;
        }
        else if(arguments.output == "raw")
        {
            return arguments.apiResponse;
        }
        else
        {
            throw( message = "cbAddy: Unknown analysis output type: #arguments.output#",
                   type = "cbAddyUnknownOutputType");
        }
    }


    /**
     * Uses the USPS address validation API to determine if an address is valid.
     * 
     * @address The address to validate.
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function validateUSPS(required struct fields, required string output)
    {
        local.httpService = new http();

        /* Set attributes using implicit settings */
        local.httpService.setMethod("GET");
        local.httpService.setCharset("utf-8");

        /* Create the XML for the API request */
        local.xmlText = "
                        <AddressValidateRequest USERID='#variables.uspsUserId#'>
                            <Revision>1</Revision>
                            <Address ID='0'>
                        ";
        //Address line 1 is REQUIRED
        if(isDefined("arguments.fields.addressLine1"))
        {
            local.xmlText &= "<Address1>#arguments.fields.addressLine1#</Address1>";
        }
        else
        {
            throw(
                message = "addressLine1 not found",
                type = "missingAddressLine1"
            );
        }
        //Address line 2 is not required
        if(isDefined("arguments.fields.addressLine2"))
        {
            local.xmlText &= "<Address2>#arguments.fields.addressLine2#</Address2>";
        }
        else
        {
            local.xmlText &= "<Address2/>";
        }
        //City is REQUIRED
        if(isDefined("arguments.fields.city"))
        {
            local.xmlText &= "<City>#arguments.fields.city#</City>";
        }
        else
        {
            local.xmlText &= "<City/>";
        }
        //State
        if(isDefined("arguments.fields.stateOrProvince"))
        {
            local.xmlText &= "<State>#arguments.fields.stateOrProvince#</State>";
        }
        else
        {
            local.xmlText &= "<State/>";
        }
        //Urbanization (Puerto Rico only)
        if(isDefined("arguments.fields.prUrbanization"))
        {
            local.xmlText &= "<Urbanization>#arguments.fields.prUrbanization#</Urbanization>";
        }
        else
        {
            local.xmlText &= "<Urbanization/>";
        }
        //Zip 5
        if(isDefined("arguments.fields.zip5"))
        {
            local.xmlText &= "<Zip5>#arguments.fields.zipExt#</Zip5>";
        }
        else
        {
            local.xmlText &= "<Zip5/>";
        }
        //Zip 4
        if(isDefined("arguments.fields.zip4"))
        {
            local.xmlText &= "<Zip4>#arguments.fields.zipCode#</Zip4>";        
        }
        else
        {
            local.xmlText &= "<Zip4/>";
        }
        //Close out the API request
        local.xmlText &= "</Address></AddressValidateRequest>";

        /* Set the target of the request to be */
        local.httpService.setUrl("https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=#local.xmlText#");
        /* Send the API request */
        local.response = local.httpService.send().getPrefix();

        /* Analyze the response to see if it is valid */
        /**
         * Check pages 5 - 8 of this guide:
         * https://www.usps.com/business/web-tools-apis/address-information-api.pdf
         * We need to determine if we should return true or false based on the DPV confirmation.
         */
        local.responseStruct = analyzeUSPS(local.response, arguments.output);
        //TODO: Bug where  the client specific response says that the XML request could not be parsed
        return responseStruct;
    }


    /**
     * Given the filecontent of a UPS API response, this function analyzes it and returns it in
     * a developer friendly format.
     * 
     * @response The API response from the upsStreetLevelClient
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function analyzeUpsStreetLevel(required struct apiResponse, required string output)
    {
        if(arguments.output == "standardized")
        {
            local.processedXmlResponse = xmlTool.convertXMLtoStruct(xmlParse(arguments.apiResponse.fileContent));
            local.returnStruct["clientSpecific"] = {};
            local.returnStruct["messages"] = [];
            //Did the request return an address validation?
            if(local.processedXmlResponse["SoapEnv:Body"][2].keyExists("xav:XAVResponse"))
            {
                local.validationData = local.processedXmlResponse["soapEnv:Body"][2]["xav:XAVResponse"][2];
                local.returnStruct["clientSpecific"] = local.validationData;
                local.returnStruct["messages"] = [];
                /* Check the validation data to see if the address successfully validated */
                if(isDefined("local.validationData['xav:NoCandidatesIndicator']"))
                {
                    local.returnStruct["valid"] = false;
                    local.returnStruct["messages"] = [variables.upsMessages["msg1"]];
                }
                else if(isDefined("local.validationData['xav:AmbiguousAddressIndicator']"))
                {
                    local.returnStruct["valid"] = false;
                    local.returnStruct["messages"] = [variables.upsMessages["msg2"]];
                }
                else if(isDefined("local.validationData['xav:validAddressIndicator']"))
                {
                    local.returnStruct["valid"] = true;
                    local.returnStruct["messages"] = [variables.upsMessages["msg3"]];
                }
                else
                {
                    local.returnStruct["valid"] = false;
                }
                return local.returnStruct;
            }
            //Check to see if an error occurred
            else if(local.processedXmlResponse["SoapEnv:Body"][2].keyExists("soapenv:Fault"))
            {
                writeDump(local.processedXmlResponse);
                local.returnStruct["clientSpecific"] = local.processedXmlResponse["soapenv:Body"][2]["soapenv:Fault"][2]["detail"][2]["err:Errors"][2]["err:ErrorDetail"][2]["err:PrimaryErrorCode"];
                local.error = local.processedXmlResponse["soapenv:Body"][2]["soapenv:Fault"][2]["detail"][2]["err:Errors"][2]["err:ErrorDetail"][2]["err:PrimaryErrorCode"][2]["err:Code"][1];

                /* Output custom error messages, please refer to page 24 and onward of the UPS street address developer guide "C_Cover_Address_Street_WS" */
                /* ---------------------------------------------------------------------
                                                Common Errors
                   --------------------------------------------------------------------- */
                //The request is not well formed
                if(local.error == "10001")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg4"]);
                }
                //The request is well formed but the request is not valid
                else if(local.error == "10002")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg5"]);
                }
                //The request is either empty or null
                else if(local.error == "10003")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg6"]);
                }
                //Although the document is well formed and valid, the element content contains values which do not conform to the rules and constraints contained in this specification
                else if(local.error == "10006")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg7"]);
                }
                //The message is too large to be processed by the application
                else if(local.error == "10013")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg8"]);
                }
                //General process failure
                else if(local.error == "20001")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg9"]);
                }
                //The specified service name, {0}, and version number, {1}, combination is invalid
                else if(local.error == "20002")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg10"]);
                }
                //Please check the server environment for the proper J2EEws apis
                else if(local.error == "20003")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg11"]);
                }
                //Invalid request action
                else if(local.error == "20006")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg12"]);
                }
                //Missing Required field, {0}
                else if(local.error == "20007")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg13"]);
                }
                //The field, {0}, contains invalid data, {1}.
                else if(local.error == "20008")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg14"]);
                }
                //The client information exceeds its maximum limit
                else if(local.error == "20012")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg15"]);
                }
                //No XML declaration in the xml of the document
                else if(local.error == "250000")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg16"]);
                }
                //Invalid access license for the tool. Please re-license.
                else if(local.error == "250001")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg17"]);
                }
                //Invalid UserId/Password
                else if(local.error == "250002")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg18"]);
                }
                //Invalid access license number
                else if(local.error == "250003")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg19"]);
                }
                //Incorrect UserId or Password
                else if(local.error == "250004")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg20"]);
                }
                //No access and authentication credentials provided
                else if(local.error == "250005")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg21"]);
                }
                //The maximum number of user access attempts was exceeded
                else if(local.error == "250006")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg22"]);
                }
                //The UserID is currently locked out, please try again in 30 minutes.
                else if(local.error == "250007")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg23"]);
                }
                //License number not found in the UPS database.
                else if(local.error == "250009")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg24"]);
                }
                //Invalid Field value
                else if(local.error == "250019")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg25"]);
                }
                //License system not available
                else if(local.error == "250050")
                {
                    local.returnStruct["messages"].append(variables.upsMessages["msg26"]);
                }
                /* ----------------------------------------------------------------------------
                                        Street Level WS Specific Errors 
                   ---------------------------------------------------------------------------- */
                //Invalid or missing request element
                else if(local.error == "250065")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg1"]);
                }
                //XAV web service currently unavailable
                else if(local.error == "260000")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg2"]);
                }
                //AV service is not available
                else if(local.error == "264001")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg3"]);
                }
                //Country code is invalid or missing
                else if(local.error == "264002")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg4"]);
                }
                //The maximum allowable candidate list size has been exceeded within the user request
                else if(local.error == "264003")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg5"]);
                }
                //The maximum validation query time has be exceeded due to poor address data
                else if(local.error == "264004")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg6"]);
                }
                //Address classification is not valid for a regional request
                else if(local.error == "264005")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg7"]);
                }
                //Invalid candidate list size
                else if(local.error == "264006")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg8"]);
                }
                //Address classification is not allowed for the country requested
                else if(local.error == "264007")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg9"]);
                }
                //Country code and address format combination is not allowed
                else if(local.error == "264008")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg10"]);
                }
                //Additional address fields are needed to perform the request operation
                else if(local.error == "264027")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg11"]);
                }
                //Invalid XAV request document
                else if(local.error == "9261000")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg12"]);
                }
                //Invalid or missing request option
                else if(local.error == "9264028")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg13"]);
                }
                //Missing address key format
                else if(local.error == "9264029")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg14"]);
                }
                //The state is not supported in the customer integration environment
                else if(local.error == "9264030")
                {
                    local.returnStruct["messages"].append(variables.upsStreetLevelMessages["msg15"]);
                }

                local.returnStruct["valid"] = false;
                return local.returnStruct;
            }
            //If something else happened, then we return an unrecognized error
            else
            {
                local.returnStruct["clientSpecfic"] = local.processedXmlResponse;
                local.returnStruct["messages"] = ["An unidentified error occurred. Please refer to clientSpecific key-value pair for more information."]
                local.returnStruct["valid"] = false;
                return local.returnStruct;
            }
        }
        else if(arguments.output == "struct" || arguments.output == "structure")
        {
            local.validationData = xmlTool.convertXMLtoStruct(xmlParse(arguments.apiResponse.fileContent));
            return local.validationData["soapenv:Body"][2]["xav:XAVResponse"][2];
        }
        else if(arguments.output == "raw")
        {
            return arguments.apiResponse;
        }
        else
        {
            throw( message = "cbAddy: Unknown analysis output type: #arguments.output#",
                   type = "cbAddyUnknownOutputType");
        }
    }


    /**
     * Uses UPS address validation to determine if an address is valid.
     * Created referring to the C_Cover_Address_Street_WS Guide
     * 
     * @address The address to validate.
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function validateUpsStreetLevel(required struct address, required string output)
    {
        /* Create an HTTP service and set attributes using implicit setters */
        local.httpService = new http();
        local.httpService.setMethod("POST");
        local.httpService.setCharset("utf-8");
        local.targetURL = "https://onlinetools.ups.com/webservices/XAV";
        local.httpService.setUrl(local.targetURL);

        /* Create SOAP format API request */
        local.fileContent = 
        '
        <envr:Envelope
            xmlns:auth="http://www.ups.com/schema/xpci/1.0/auth"
            xmlns:envr="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:upss="http://www.ups.com/XMLSchema/XOLTWS/UPSS/v1.0"
            xmlns:common="http://www.ups.com/XMLSchema/XOLTWS/Common/v1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <envr:Header>
                <upss:UPSSecurity>
                    <upss:UsernameToken>
                        <upss:Username>#variables.upsUsername#</upss:Username>
                        <upss:Password>#variables.upsPassword#</upss:Password>
                    </upss:UsernameToken>
                    <upss:ServiceAccessToken>
                        <upss:AccessLicenseNumber>#variables.upsApiKey#</upss:AccessLicenseNumber>
                    </upss:ServiceAccessToken>
                </upss:UPSSecurity>
            </envr:Header>
            <envr:Body>
                <XAV:XAVRequest xsi:schemaLocation="http://www.ups.com/XMLSchema/XOLTWS/xav/v1.0"
                    xmlns:XAV="http://www.ups.com/XMLSchema/XOLTWS/xav/v1.0">
                    <common:Request>
                        <common:RequestOption>1</common:RequestOption>
                        <common:TransactionReference>
                            <common:CustomerContext>cbAddy API Call</common:CustomerContext>
                        </common:TransactionReference>
                    </common:Request>
                    <XAV:MaximumListSize>10</XAV:MaximumListSize>
                    <XAV:AddressKeyFormat>
                        <XAV:ConsigneeName>#arguments.address.consigneeName#</XAV:ConsigneeName>
                        <XAV:BuildingName>#arguments.address.buildingName#</XAV:BuildingName>
                        <XAV:AddressLine>#arguments.address.addressLine1 & ' ' & arguments.address.addressLine2  & ' ' & arguments.address.addressLine3#</XAV:AddressLine>
                        <XAV:PoliticalDivision2>#arguments.address.city#</XAV:PoliticalDivision2>
                        <XAV:PoliticalDivision1>#arguments.address.stateOrProvince#</XAV:PoliticalDivision1>
                        <XAV:PostcodePrimaryLow>#arguments.address.zipCode#</XAV:PostcodePrimaryLow>
                        <XAV:CountryCode>#arguments.address.countryCode#</XAV:CountryCode>
                    </XAV:AddressKeyFormat>
                </XAV:XAVRequest>
            </envr:Body>
        </envr:Envelope>
        ';

        /* Give the API request to the http request object and send it */
        local.httpService.addParam(type="body", name="requestBody", value=local.fileContent);
        local.response = local.httpService.send().getPrefix();

        /* Returned a parsed version of the response that will be friendly to users of the client */
        local.analyzedResponse = analyzeUpsStreetLevel(local.response, arguments.output); 

        return local.analyzedResponse;
    }


    /**
     * Analyzes the response from UPS and returns a friendly struct for developers to
     * work with.
     * 
     * @apiResponse The API response passed in from the UPS address validation API.
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function analyzeUpsCityStateZip(required struct apiResponse, required string output)
    {
        if(arguments.output == "standardized")
        {

            local.processedJsonResponse = deserializeJSON(apiResponse.fileContent);
            //Did the request return an address validation?
            if(local.processedJsonResponse.keyExists("XAVResponse"))
            {
                local.validationData = local.processedJsonResponse["XAVResponse"];
                local.returnStruct["clientSpecific"] = local.validationData;
                local.returnStruct["messages"] = []
                /* Check the validation data to see if the address successfully validated */
                if(local.validationData.keyExists("NoCandidatesIndicator"))
                {
                    local.returnStruct["valid"] = false;
                    local.returnStruct["messages"] = [variables.upsMessages["msg1"]];
                }
                else if(local.validationData.keyExists("AmbiguousAddressIndicator"))
                {
                    local.returnStruct["valid"] = false;
                    local.returnStruct["messages"] = [variables.upsMessages["msg2"]];
                }
                else if(local.validationData.keyExists("ValidAddressIndicator"))
                {
                    local.returnStruct["valid"] = true;
                    local.returnStruct["messages"] = [variables.upsMessages["msg3"]];
                }
                return local.returnStruct;
            }
            else
            {
                //The API request was invalid, so we return the following for errors
                local.returnStruct["clientSpecific"] = local.processedJsonResponse;
                local.returnStruct["messages"] = ["There was an error in processing the API request."];
                local.returnStruct["valid"] = false;
                return local.returnStruct;
            }
        }
        else if(arguments.output == "struct" || arguments.output == "structure")
        {
            local.validationData = deserializeJSON(apiResponse.fileContent)
            return local.validationData;
        }
        else if(arguments.output == "raw")
        {
            return arguments.apiResponse;
        }
        else
        {
            throw( message = "cbAddy: Unknown analysis output type: #arguments.output#",
                   type = "cbAddyUnknownOutputType");
        }
    }


    /**
     * Uses the UPS address validation API to determine if an address is valid.
     * Created referring to the RESTful API developer guide.
     * 
     * @address The address to validate.
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function validateUpsCityStateZip(required struct address, required string output)
    {
        /* Create an HTTP service and set attributes using implicit setters */
        local.httpService = new http();
        local.httpService.setMethod("POST");
        local.httpService.setCharset("utf-8");

        /* Add header elements to authorize and specify the API request */
        local.httpService.addParam(type="header", name="Username", value=variables.upsUsername);
        local.httpService.addParam(type="header", name="Password", value=variables.upsPassword);
        local.httpService.addParam(type="header", name="AccessLicenseNumber", value=variables.upsApiKey);
        local.httpService.addParam(type="header", name="Content-Type", value="application/json");
        local.httpService.addParam(type="header", name="Accept", value="application/json");
        
        /* Add parameters to the request's target URL
           Learn more about these on page 11-12 of the Address Validation RESTful API developer guide from UPS */
        local.targetURL = "https://onlinetools.ups.com/addressvalidation/v1/1?regionalrequestindicator=true&maximumcandidatelistsize=10";
        local.httpService.setUrl(local.targetURL);

        /* Create the body of our request by declaring it as a struct and then serializing it to JSON */
        //Here, we go through the request parameters otlinefsd in the UPS Address Validation Restful API developer guide on page 12. Some are required, while some are optional.
        local.requestStruct = {};
        //Consignee name: Name of business, company or person. Ignored if the user selects RegionalRequestIndicator.
        if(isDefined("arguments.address.consigneeName"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["ConsigneeName"] = arguments.address.consigneeName;
        }
        else 
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["ConsigneeName"] = "";
        }
        //Building name: Name of the building. Ignored if the user selects the RegionalRequestIndicator.
        if(isDefined("arguments.address.buildingName"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["BuildingName"] = arguments.address.buildingName;
        }
        else
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["BuildingName"] = "";
        }
        //AddressLine: Address line (street number, street name, and street type) used for street level information. Applicable to US and PR only. Ignored if the user selects RegionalRequestIndicatoor.
        local.addressLines = ["","",""];
        if(isDefined("arguments.address.addressLine1"))
        {
            local.addressLines[1] = arguments.address.addressLine1;
        }
        else 
        {
            local.addressLines[1] = "";
        }
        if(isDefined("arguments.address.addressLine2"))
        {
            local.addressLines[2] = arguments.address.addressLine2;
        }
        else
        {
            local.addressLines[2] = "";    
        }
        if(isDefined("arguments.address.addressLine3"))
        {
            local.addressLines[3] = arguments.address.addressLine3;
        }
        else
        {
            local.addressLines[3] = "";    
        }
        local.requestStruct["XAVRequest"]["AddressKeyFormat"]["AddressLine"] = local.addressLines;
        // Region: Valid for US and PR origins only.
        if(isDefined("arguments.address.region"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["Region"] = arguments.address.region;
        }
        // PoliticalDivision2: City or town name.
        if(isDefined("arguments.address.city"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PoliticalDivison2"] = arguments.address.city;
        }
        else 
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PoliticalDivison2"] = "";    
        }
        // PoliticalDivision1: State or province name
        if(isDefined("arguments.address.stateOrProvince"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PoliticalDivision1"] = arguments.address.stateOrProvince;
        }
        else 
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PoliticalDivision1"] = "";
        }
        // PostcodePrimaryLow: Postal code
        if(isDefined("arguments.address.zipCode"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PostcodePrimaryLow"] = arguments.address.zipCode;
        }
        else
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PostcodePrimaryLow"] = "";
        }
        // PostcodeExtendedLow: 4 digit postal code extension. For US use only.
        if(isDefined("arguments.address.zipExt"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PostcoodeExtendedLow"] = arguments.address.zipExt;
        }
        else
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["PostcoodeExtendedLow"] = "";
        }
        // Urbanization: Puerto Rico Political Division 3. Only valid for Puerto Rico.
        if(isDefined("arguments.address.prUrbanization"))
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["Urbanization"] = arguments.address.prUrbanization;
        }
        else 
        {
            local.requestStruct["XAVRequest"]["AddressKeyFormat"]["Urbanization"] = "";
        }
        //Country code is required
        local.requestStruct["XAVRequest"]["AddressKeyFormat"]["CountryCode"] = arguments.address.countryCode;
    
        /* Give the API request to the http request object and send it */
        local.requestBody = serializeJSON(local.requestStruct);
        local.httpService.addParam(type="body", name="requestBody", value=local.requestBody);
        local.response = local.httpService.send().getPrefix();

        /* Returned a parsed version of the response that will be friendly to users of the client */
        local.analyzedResponse = analyzeUPSCityStateZip(local.response, arguments.output); 

        return local.analyzedResponse;
    }


    /**
     * Analyze avalara's API responses
     * 
     * @apiResponse The struct returned by the avalara addressResolve API
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation, errors, etc.
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function analyzeAvalara(required struct apiResponse, required string output)
    {
        if(arguments.output == "standardized")
        {
            local.validationData = deserializeJSON(arguments.apiResponse.fileContent);
            local.foundInvalidation = false;
            local.returnStruct["clientSpecific"] = local.validationData;
            local.returnStruct["messages"] = []
            /* Check the validation data to see if the address successfully validated */
            if(local.validationData.keyExists("validatedAddresses"))
            {
                if(len(local.validationData['validatedAddresses']) >= 1)
                {
                    //Search through messages to find any errors
                    if(local.validationData.keyExists("messages"))
                    {
                        for(local.i = 1; local.i <= len(local.validationData['messages']); local.i++)
                        {
                            if(isDefined("local.validationData['messages'][#local.i#]['summary']"))
                            {
                                //Unknown address number invalidation
                                if(local.validationData['messages'][local.i]['summary'] == "The address number is out of range")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg1"]);
                                }
                                //Unable to find street name match invalidation
                                else if(local.validationData['messages'][local.i]['summary'] == "An exact street name match could not be found")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg2"]);
                                }
                                //Address is not delieverable
                                else if(local.validationData["messages"][local.i]["summary"] == "The address is not deliverable.")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg5"]);
                                }
                                //Address is not geocoded 
                                else if(local.validationData["messages"][local.i]["summary"] == "Address not geocoded.")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg6"]);
                                }
                                //City could not be determined
                                else if(local.validationData["messages"][local.i]["summary"] == "The city could not be determined.")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg7"]);
                                }
                                //Address line 1 contraints not met
                                else if(local.validationData["messages"][local.i]["summary"] == "Address.Line1 length must be between 0 and 50 characters.")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg8"]);
                                }
                                //Country not supported
                                else if(local.validationData["messages"][local.i]["summary"] == "Country not supported.")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg12"]);
                                }
                                //Not enough address information was given to perform a validation
                                else if(local.validationData["messages"][local.i]["summary"] == "Insufficient address information")
                                {
                                    local.foundInvalidation = true;
                                    local.returnStruct["messages"].append(variables.avalaraMessages["msg11"]);
                                }
                            }
                        }
                    }
                    /* Other than checking for messages for validation errors, we also need to check to see if avalara validated the exact address we entered, or if it made corrections */
                    local.foundAddressMismatch = false;
                    //Because cbaddy only sends one validation request at a time, just compare our input address to the validated address that avalara returns
                    //Are the address lines the different?
                    if(uniformString(local.validationData['address']['line1']) != uniformString(local.validationData['validatedAddresses'][1]['line1']))
                    {
                        //Verify that the mismatch is not between abbreviations
                        if(abbreviateAddressLine(uniformString(local.validationData['address']['line1'])) != abbreviateAddressLine(uniformString(local.validationData['validatedAddresses'][1]['line1'])))
                        {
                            local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @addressLine1");
                        }
                    }
                    if(uniformString(local.validationData['address']['line2']) != uniformString(local.validationData['validatedAddresses'][1]['line2']))
                    {
                        //Verify that the mismatch is not between abbreviations
                        if(abbreviateAddressLine(uniformString(local.validationData['address']['line2'])) != abbreviateAddressLine(uniformString(local.validationData['validatedAddresses'][1]['line2'])))
                        {
                            local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @addressLine2");
                        }
                    }
                    if(uniformString(local.validationData['address']['line3']) != uniformString(local.validationData['validatedAddresses'][1]['line3']))
                    {
                        //Verify that the mismatch is not between abbreviations
                        if(abbreviateAddressLine(uniformString(local.validationData['address']['line3'])) != abbreviateAddressLine(uniformString(local.validationData['validatedAddresses'][1]['line3'])))
                        {
                            local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @addressLine3");
                        }
                    }
                    //Is the city different?
                    if(uniformString(local.validationData['address']['city']) != uniformString(local.validationData['validatedAddresses'][1]['city']))
                    {
                        //Verify that the mismatch is not between abbreviations
                        if(abbreviateAddressLine(uniformString(local.validationData['address']['city'])) != abbreviateAddressLine(uniformString(local.validationData['validatedAddresses'][1]['city'])))
                        {
                            local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @city");
                        }
                    }
                    //Is the zip code different?
                    if(uniformString(local.validationData['address']['postalCode']) != uniformString(local.validationData['validatedAddresses'][1]['postalCode']))
                    {
                        //If a zip code is not supplied in the submitted address, we don't count it as a mismatch.
                        if(local.validationData["address"]["postalCode"] !=  "")
                        {
                            local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @postalCode");
                        }
                    }
                    //Is the country different?
                    if(uniformString(local.validationData['address']['country']) != uniformString(local.validationData['validatedAddresses'][1]['country']))
                    {
                        local.returnStruct['messages'].append(variables.avalaraMessages["msg3"] & " @countryCode");
                    }
                }
                //If there were no valid addresses returned, we see if we got an error. If not, we just say that the request did not process correctly.
                else
                {
                    local.foundInvalidation = true;
                    if(local.validationData.keyExists("error"))
                    {
                        local.returnStruct['messages'].append(variables.avalaraMessages["msg10"]);
                    }
                    else
                    {
                        local.returnStruct['messages'].append(variables.avalaraMessages["msg4"]);
                    }
                }
            }
            //If there were no valid addresses returned, we see if we got an error. If not, we just say that the request did not process correctly.
            else
            {
                local.foundInvalidation = true;
                if(local.validationData.keyExists("error"))
                {
                    local.returnStruct['messages'].append(variables.avalaraMessages["msg10"]);
                }
                else
                {
                    local.returnStruct['messages'].append(variables.avalaraMessages["msg4"]);
                }
            }
            /* Based on our tests, is the address valid? */
            if(local.foundInvalidation)
            {
                local.returnStruct["valid"] = false;
            }
            else
            {
                local.returnStruct["valid"] = true;
            }
            return local.returnStruct;    
        }
        else if(arguments.output == "struct" || arguments.output == "structure")
        {
            local.validationData = deserializeJSON(arguments.apiResponse.fileContent)
            return local.validationData;
        }
        else if(arguments.output == "raw")
        {
            return arguments.apiResponse;
        }
        else
        {
            throw( message = "cbAddy: Unknown analysis output type: #arguments.output#",
                   type = "cbAddyUnknownOutputType");
        }
    }


    /**
     * Uses the Avalara API's address validation feature to validate a given address.
     * 
     * Reference for API:
     *  Request Construction
     *  https://www.avalara.com/partner/en/api/calculation/sales-tax/use-cases/address-validation.html
     *  https://developer.avalara.com/api-reference/avatax/rest/v2/methods/Addresses/ResolveAddress/
     *  
     *  Authentication
     *  https://developer.avalara.com/avatax/dev-guide/getting-started-with-avatax/authentication-in-avatax/https://developer.avalara.com/avatax/dev-guide/getting-started-with-avatax/authentication-in-avatax/
     * 
     * @address The address to validate
     * @output The format with which to format the output data. There are 3 valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *              -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation
     *              }    
     *          "struct"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct with formatting dependent upon the output argument defined above.
     */
    private struct function validateAvalara(required struct address, required string output)
    {
        /* Create an HTTP service and set attributes using implicit setters */
        local.httpService = new http();
        local.httpService.setMethod("POST");
        local.httpService.setCharset("utf-8");

        /* Add header elements to authorize and specify the API request */
        local.httpService.addParam(type="header", name="Authorization", value=variables.avalaraAuthorization);
        
        /* Add parameters to the request's target URL */
        local.targetURL = "https://rest.avatax.com/api/v2/addresses/resolve";
        local.httpService.setUrl(local.targetURL);

        /* Build the body of the request as struct */
        local.requestStruct = {};
        // Address lines
        if(isDefined("arguments.address.addressLine1"))
        {
            local.requestStruct["line1"] = arguments.address.addressLine1;
        }
        if(isDefined("arguments.address.addressLine2"))
        {
            local.requestStruct["line2"] = arguments.address.addressLine2;
        }
        if(isDefined("arguments.address.addressLine3"))
        {
            local.requestStruct["line3"] = arguments.address.addressLine3;
        }
        // City
        if(isDefined("arguments.address.city"))
        {
            local.requestStruct["city"] = arguments.address.city;
        }
        // Region
        if(isDefined("arguments.address.stateOrProvince"))
        {
            local.requestStruct["region"] = arguments.address.stateOrProvince;
        }
        // Postal Code
        if(isDefined("arguments.address.zipCode"))
        {
            local.requestStruct["postalCode"] = arguments.address.zipCode;
        }
        // Country
        if(isDefined("arguments.address.countryCode"))
        {
            local.requestStruct["country"] = arguments.address.countryCode;
        }
        // Text case of response
        if(isDefined("arguments.address.textCase"))
        {
            local.requestStruct["textCase"] = arguments.address.textCase;
        }

        /* Give the API request to the http request object and send it */
        local.requestBody = serializeJSON(local.requestStruct);
        local.httpService.addParam(type="body", name="requestBody", value=local.requestBody);
        local.response = local.httpService.send().getPrefix();

        /* Returned a parsed version of the response that will be friendly to users of the client */
        local.analyzedResponse = analyzeAvalara(local.response, arguments.output);

        return local.analyzedResponse;
    }


    /**
     * Pings the Avalara API to test the state of the client's connection
     */
    public struct function pingAvalara()
    {
        /* Create an HTTP service and set attributes using implicit setters */
        local.httpService = new http();
        local.httpService.setMethod("GET");
        local.httpService.setCharset("utf-8");

        /* Add header elements to authorize and specify the API request */
        local.httpService.addParam(type="header", name="Authorization", value=variables.avalaraAuthorization);
        
        /* Add parameters to the request's target URL */
        local.targetURL = "https://rest.avatax.com/api/v2/utilities/ping";
        local.httpService.setUrl(local.targetURL);

        /* Send the HTTP request */
        local.response = local.httpService.send().getPrefix();
        return local.response;
    }


    /**
     * The main function that is called from this library. Routes to one of the address validation
     * APIs that we want to use. By default, we use UPS' API.
     * *Note that USS' address validator only works for US and Puerto Rico.
     * *Check to see if USPS' address validator works for Canada
     * 
     * @address A struct containing the following members:
     * {
     *     "consigneeName" : Name of the business, company or person associated with the address.
     *     "addressLine1" : Address line (contains street number, name, and type)
     *     "addressLine2" : 2nd address line
     *     "addressLine3" : 3rd address line
     *     "region" : Combination of city, state, and zip code. If included, will override validation of what is input for "city", "state", "zipCode", and "zipExt".
     *     "city" : City or town name
     *     "state" : State or province/territory name
     *     "zipCode" : Postal code
     *     "zipExt" : 4 digit postal code extension. For US use only
     *     "prUrbanization" : Political division 3. Only valid for Puerto Rico.
     *     "countryCode" : (Required) Country code. United states = US. A list of more valid values can be found in the back of
     *                    UPS street level address validation API guide found here: https://www.ups.com/upsdeveloperkit?loc=en_US 
     * }
     * @service A string which names the type of address validation service you wish to access. The following are
     *           a list of valid values for this parameter. Some of these services will provide suggested addresses
     *           if the one you tried to validate was found to be invalid. "Avalara" is default.
     *           "usps"
     *               -Provides a robust set of corrections to submitted addresses
     *               -Only US and Puerto Rico
     *               -Validates down to street level
     *           "upsCityStateZip"
     *               -Supports suggestions
     *               -Only US and Puerto Rico
     *               -Only validates city, state, and zip code combinations
     *           "upsStreetLevel"
     *               -Supports suggestions
     *               -Only US and Puerto Rico
     *               -Validates down to street level
     *           "avalara"
     *               -Validates down to street level
     *               -Only US and Canada
     *               -Provides tax authority information
     * @output The format with which to format the output data. There are several valid options for output:
     *          "standardized"
     *              -The standardized form of output between all API clients in cbaddy
     *  `           -The default option
     *              -A struct with the following members:
     *              {
     *                  "valid" : boolean indicating whether or not the address was valid 
     *                  "clientSpecific" : struct containing all of the response variables unique to the specific API client
     *                  "messages" : array of messages containing any information relevant to validation
     *              }    
     *          "struct"/"structure"
     *              -The filecontent of the API response casted as a struct
     *          "raw"
     *              -The raw API response with all of the HTTP request metadata
     * 
     * @return A struct containing the information specified by the output parameter.
     */
    public struct function validate(required struct address, string service="default", string output="standardized")
    {
        //Accept a user defined default API
        if(arguments.service == "default")
        {
            arguments.service = variables.defaultAPI;
        }

        //Choose the API to use
        if(arguments.service =="avalara")
        {
            local.returnStruct = validateAvalara(arguments.address, arguments.output);
        }
        else if(arguments.service == "upsStreetLevel")
        {
            local.returnStruct = validateUpsStreetLevel(arguments.address, arguments.output);
        }
        else if(arguments.service == "upsCityStateZip")
        {
            local.returnStruct = validateUpsCityStateZip(arguments.address, arguments.output);
        }
        else if(arguments.service == "usps")
        {
            local.returnStruct = validateUSPS(arguments.address, arguments.output);
        }
        else
        {
            local.returnStruct = {"messages" : ["Service " & arguments.service & " unrecognized or not supported by cbAddy"]};
        }
        return local.returnStruct;
    }
}