import codecs
from http.client import HTTPResponse
import io
from django.shortcuts import render
from django.http import HttpResponseRedirect
from .forms import xmlForm
from lxml import etree
import xmlschema as xs


# Create your views here.
def dml_funct(request):
    # if this is a POST request we need to process the form data
    tab = ""
    result = err = ""
    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form = xmlForm(request.POST)
        # check whether it's valid:
        if form.is_valid():
            xmlText = form.cleaned_data['xmlText']
            xml = xmlText.encode()
            xml_doc = etree.fromstring(xml)

            xsdText = form.cleaned_data['xsdText']
            xsd = xsdText.encode()
            xsd_doc = etree.fromstring(xsd)
            schema = etree.XMLSchema(xsd_doc)

            # Validate the XML document
            if schema.validate(xml_doc):
                result = "XML Document is Valid"
                xslt = open(
                'C:\\xampp\\htdocs\\project\\dml\\v2.xsl', 'r')
                cont = xslt.read()
                xslt_doc = etree.fromstring(cont) 
                transform = etree.XSLT(xslt_doc) 
                #transform the XSD file
                r = etree.tostring(transform(xml_doc)).decode('ascii')
                tab = r.split('|')
                # with open('dml.sql', 'w') as f:
                #     for item in tab:
                #         f.write(item)

        
            
            else:
                result = "XML Document is Invalid: "
                error_log = schema.error_log
                # Print the error messages
                for error in error_log:
                    err = error.message
    # if a GET (or any other method) we'll create a blank form
    else:
        form = xmlForm()

    context = {
        'form': form,
        'tab': tab,
        'result': result,
        'err': err
    }
    return render(request, 'dml.html', context)