
from django.shortcuts import render
from .forms import xsdForm
from lxml import etree


# Create your views here.
def ddl_funct(request):
    # if this is a POST request we need to process the form data
    ddl = ""
    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form = xsdForm(request.POST)
        # check whether it's valid:
        if form.is_valid():
            xsdText = form.cleaned_data['xsdText']
            xsd = xsdText.encode()
            xsd_doc = etree.fromstring(xsd)

            xslt = open('C:\\xampp\\htdocs\\project\\ddl\\ddl.xsl', 'r')
            xslt_doc = etree.parse(xslt) 
            transform = etree.XSLT(xslt_doc) 
            #transform the XSD file
            tab = transform(xsd_doc) 
            #ddl = etree.tostring(tab).split(";")
            s = str(tab)
            ddl = s.split('|')
    else:
        form = xsdForm()

    context = {
        'form': form,
        'ddl': ddl
    }
    return render(request, 'ddl.html', context)