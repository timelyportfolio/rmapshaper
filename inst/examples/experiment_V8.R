library(V8)

# get a place to work
ctx <- new_context()

# source the browserified mapshaper
#  created in the mapshaper directory by
#  browserify mapshaper.js -o mapshaper_standalone.js
ctx$source('./inst/js/mapshaper/mapshaper_browserify.js')

# check to make sure mapshaper is there
ctx$get('Object.keys(mapshaper)')

# run the example from issue #2
ctx$eval(
'var poly = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-114.345703125, 39.4369879],
            [-116.4534998, 37.18979823791],
            [-118.4534998, 38.17698709],
            [-115.345703125, 43.576878],
            [-106.611328125, 43.4529188935547],
            [-105.092834092, 46.20938402],
            [-106.66859, 39.4389646],
            [-103.6117867, 36.436756],
            [-114.34579879, 39.4361929]
            ]
          ]
      },
      "properties": {"id":"foobar"}
    }
    ]
}
'
)

# see if poly is there
ctx$get('poly')

# manipulate poly with mapshaper
#  which will give us setTimeout is not defined
ctx$get(
'
mapshaper.applyCommands(
  "-simplify 0.4 visvalingam",
  poly,
  function(err, data) {
    console.log(data);
  }
)
'
)

# try to break applyCommands down
ctx$eval('var command = mapshaper.internal.parseCommands("-simplify 0.4 visvalingam")')
# callback does not actually return the data
ctx$get(
'
  mapshaper.runCommand(
    command[0],
    mapshaper.internal.importFileContent(poly, null, {}),
    function(err,data){
      //
      console.log(data);
      return data;
    }
  )
'
)
# to set can do something ugly like this
ctx$eval(
'
var return_data = {};
  mapshaper.runCommand(
  command[0],
  mapshaper.internal.importFileContent(poly, null, {}),
  function(err,data){return_data = data}
  )
  return_data;
'
)
ctx$get("return_data")
