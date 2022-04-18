component
{
    //Module properties
    this.title          = "cbAddy";
    this.author         = "Jeff Stevens";
    this.description    = "A ColdFusion API client for using several prominent address validation APIs.";
    this.modelNameSpace = "cbaddy";
    this.cfmapping      = "cbaddy";

    function configure()
    {
        //Module settings
        settings = {
                        defaultApi = "avalara",
                        uspsUserId = "XXX",
                        upsUsername = "XXX",
                        upsPassword = "XXX",
                        upsApiKey = "XXX",
                        avalaraAuthorization = "XXX",
                        avalaraMessages = {
                            "msg1" : "1: The address number is out of range.",
                            "msg2" : "2: An exact street name match could not be found.",
                            "msg3" : "3: Address corrected",
                            "msg4" : "4: Avalara did not process the address validation request.",
                            "msg5" : "5: The address is not deliverable.",
                            "msg6" : "6: Address not geocoded.",
                            "msg7" : "7: The city could not be determined.",
                            "msg8" : "8: Address.Line1 length must be between 0 and 50 characters.",
                            "msg9" : "",
                            "msg10" : "10: An error occurred, please see the clientSpecfic struct for more information.",
                            "msg11" : "11: Insufficient address information; you must specify at least Line/ZIP, or Line/City/State.",
                            "msg12" : "12: Address Validation for this country is not supported."
                        },
                        uspsMessages : {
                            "msg1" : "Address not found.",
                            "msg2" : "Invalid state code.",
                            "msg3" : "Invalid city.",
                            "msg4" : "Zip code corrected.",
                            "msg5" : "City / State spelling corrected.",
                            "msg6" : "Invalid City / State / Zip.",
                            "msg7" : "No ZIP+4 assigned.",
                            "msg8" : "Zip Code assigned for multiple response.",
                            "msg9" : "Address could not be found in the national directory file database.",
                            "msg10" : "Information in firm line used for matching.",
                            "msg11" : "Missing secondary number.",
                            "msg12" : "Insufficient / Incorrect Address Data.",
                            "msg13" : "Dual Address.",
                            "msg14" : "Multiple response due to Cardinal Rule.",
                            "msg15" : "Address component changed.",
                            "msg16" : "Match has been converted with LACS.",
                            "msg17" : "Street name changed.",
                            "msg18" : "Address Standardized.",
                            "msg19" : "Lowest +4 Tie-Breaker.",
                            "msg20" : "Better address exists.",
                            "msg21" : "Unique Zip code match.",
                            "msg22" : "No match due to EWS.",
                            "msg23" : "Incorrect secondary address.",
                            "msg24" : "Multiple response due to magnet street syndrome.",
                            "msg25" : "Unofficial Post Office name.",
                            "msg26" : "Unverifiable City / State.",
                            "msg27" : "Invalid Delivery Address.",
                            "msg28" : "No match due to out of range alias.",
                            "msg29" : "Military match.",
                            "msg30" : "Match made using the ZIPMOVE product data.",
                            "msg31" : "Address was DPV confirmed for both primary and (if present) secondary numbers.",
                            "msg32" : "Address was DPV confirmed for the primary number only and the secondary number information was missing.",
                            "msg33" : "Address was DPV confirmed for the primary number only and the secondary number information was present by not confirmed.",
                            "msg34" : "Both primary and (if present) seocndary number information failed to DPV confirm."
                        },
                        upsMessages : {
                            "msg1" : "No candidate addresses.",
                            "msg2" : "Ambiguous address provided; suggested addresse(s) returned.",
                            "msg3" : "Valid address.",
                            "msg4" : "The request is not well formed.",
                            "msg5" : "The request is well formed, but the request is not valid.",
                            "msg6" : "The request is either empty or null.",
                            "msg7" : "Although the document is well formed and valid, the element content contains values which do not conform to the rules and constraints contained in this specification.",
                            "msg8" : "The message is too large to be processed by the application.",
                            "msg9" : "General process failure.",
                            "msg10" : "The specified service name, {0}, and version number, {1}, combination is invalid",
                            "msg11" : "Please check the server environment for the proper J2EEws apis.",
                            "msg12" : "Invalid request action.",
                            "msg13" : "Missing required field, {0}.",
                            "msg14" : "The field, {0}, contains invalid data, {1}.",
                            "msg15" : "The client information exceeds its maximum limit.",
                            "msg16" : "No XML declaration in the XML of the document.",
                            "msg17" : "Invalid access license for the tool. Please re-license.",
                            "msg18" : "Invalid UserId/Password.",
                            "msg19" : "Invalid access license number.",
                            "msg20" : "Incorrect UserId/Password.",
                            "msg21" : "No access and authentication credentials provided.",
                            "msg22" : "The maximum number of user access attempts was exceeded.",
                            "msg23" : "The UserId is currently locked out, please try again in 30 minutes.",
                            "msg24" : "License number not found in the UPS database.",
                            "msg25" : "Invalid field value.",
                            "msg26" : "License system not available."
                        },
                        upsStreetLevelMessages : {
                            "msg1" : "Invalid or missing request element.",
                            "msg2" : "XAV web service currently available.",
                            "msg3" : "AV service is not available.",
                            "msg4" : "Country code is invalid or missing.",
                            "msg5" : "The maximum allowable candidate list size has been exceeded within the user request.",
                            "msg6" : "The maximum validation query time has be exceeded due to poor address data.",
                            "msg7" : "Address classification is not valid for a regional request.",
                            "msg8" : "Invalid candidate list size.",
                            "msg9" : "Address classification is not allowed for the country requested.",
                            "msg10": "Country code and address format combination is not allowed.",
                            "msg11": "Additional address fields are needed to perform the request operation.",
                            "msg12": "Invalid XAV request document.",
                            "msg13": "Invalid or missing request option.",
                            "msg14": "Missing address key format.",
                            "msg15": "The state is not supported in the customer integration environment"
                        }
                    };
    }
}