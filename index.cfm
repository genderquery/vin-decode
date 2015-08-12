<!DOCTYPE html>
<html lang="en">
  <head>
    <title>VIN Decode</title>
    <style>
      label { display: inline-block; width: 150px; }
      #error { color: red; }
    </style>
  </head>
  <body>
    <input type="text" id="vin" />
    <input type="button" id="submit" value="Check VIN" />
    <div id="error">&nbsp;</div>
    <label for="region">SAE Region</label>
    <input type="text" id="region" readonly="readonly" />
    <br>
    <label for="country">SAE Country</label>
    <input type="text" id="country" readonly="readonly" />
    <br>
    <label for="manufacturer">Manufacturer</label>
    <input type="text" id="manufacturer" readonly="readonly" />
    <br>
    <label for="year">Model Year</label>
    <input type="text" id="year" readonly="readonly" />
    <br>
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script>
      function processRequest(vin) {
        if (!vin.valid) {
          $("#error").html("Invalid VIN: " + vin.invalid_reason);
        } else {
          $("#error").html("&nbsp;");
          $("#region").val(vin.region);
          $("#country").val(vin.country);
          $("#manufacturer").val(vin.manufacturer);
          $("#year").val(vin.year);
        }
      }
      $(document).ready(function() {
        $("#submit").click(function() {
          var vin = $("#vin").val();
          $.ajax({
            url: "vin.cfc",
            data: {
              method: "decode",
              returnformat: "json",
              vin: vin
            },
            dataType: "json",
            success: processRequest,
            error: function(jqXHR, textStatus, errorThrown) {
              $("#error").html(textStatus);
            }
          });
        });
      });
    </script>
  </body>
</html>
