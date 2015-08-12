component {

  private void function loadDataSet() {
    var dataset_json = FileRead(expandPath('./dataset.json'));
    var dataset = DeserializeJSON(dataset_json);
    this.countries = dataset['countries'];
    this.regions = dataset['regions'];
    this.manufacturers = dataset['manufacturers'];
    this.yearCodes1980 = dataset['yearCodes1980'];
    this.yearCodes2010 = dataset['yearCodes2010'];
  }

  private string function getRegion() {
    var regionCode = this.vin.charAt(0);
    if (StructKeyExists(this.regions, regionCode)) {
      return this.regions[regionCode];
    }
  }
  
  private string function getCountry() {
    var countryCode = this.vin.substring(0, 2);
    if (StructKeyExists(this.countries, countryCode)) {
      return this.countries[countryCode];
    }
  }
 
  private string function getManufacturer() {
    var manufacturerCode = this.vin.substring(0, 3);
    if (StructKeyExists(this.manufacturers, manufacturerCode)) {
      return this.manufacturers[manufacturerCode];
    }
    var manufacturerCodeShort = this.vin.substring(0, 2);
    if (StructKeyExists(this.manufacturers, manufacturerCodeShort)) {
      return this.manufacturers[manufacturerCodeShort];
    }
  }

  private string function getYear() {
    var yearCodes = this.yearcodes2010;  
    // pre-2010 models have a digit at pos 7
    if (isNumeric(this.vin.charAt(6))) {
      yearCodes = this.yearcodes1980;
    }
    var yearCode = this.vin.charAt(9);
    if (StructKeyExists(yearCodes, yearCode)) {
      return yearCodes[yearCode];
    }
  }

  remote any function decode(required string vin) {
    this.vin = arguments.vin.toUpperCase();
    var obj = {};
    obj['valid'] = false;
    if (Len(this.vin) != 17) {
      obj['invalid_reason'] = "must be 17 characters";
      return obj;
    }
    if (FindOneOf('IOQ', this.vin)) {
        obj['invalid_reason'] = "I, O, and Q are not a valid VIN characters";
        return obj;
    }
    if (FindOneOf(this.vin.charAt(9), 'UZ0')) {
        obj['invalid_reason'] = "U, Z, and 0 may not be in position 10";
        return obj;
    }
    obj['valid'] = true;
    obj['wmi'] = this.vin.substring(0, 3);
    obj['region'] = getRegion();
    obj['country'] = getCountry();
    obj['manufacturer'] = getManufacturer();
    obj['year'] = getYear();
    return obj;
  }
  
  // we would normally connect to a datastore
  loadDataSet();
}
