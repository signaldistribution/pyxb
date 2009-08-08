PYTHONPATH=../..
export PYTHONPATH
URI='http://www.weather.gov/forecasts/xml/DWMLgen/schema/DWML.xsd'
PREFIX='DWML'

rm -rf uriArchive
rm -rf raw ${PREFIX}.py
mkdir -p raw
touch raw/__init__.py
../../scripts/pyxbgen \
   -u "${URI}" \
   -m "${PREFIX}" \
   --uri-content-archive-directory=uriArchive \
   -r || exit
if [ ! -f ${PREFIX}.py ] ; then
  echo "from raw.${PREFIX} import *" > ${PREFIX}.py
fi

# Retrieve the wsdl.  Heck, show it off even.  Just not using it yet.
WSDL_URI='http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl'
if [ ! -f ndfdXML.wsdl ] ; then
  wget ${WSDL_URI}
fi
rm -f raw/ndfd.py
../../scripts/pyxbgen \
   -W "${WSDL_URI}" \
   -m ndfd \
   --uri-content-archive-directory=uriArchive \
   -r || exit

../../scripts/pyxbwsdl file:ndfdXML.wsdl

# Get an example query
if [ ! -f NDFDgen.xml ] ; then
  wget http://www.weather.gov/forecasts/xml/docs/SOAP_Requests/NDFDgen.xml
fi
