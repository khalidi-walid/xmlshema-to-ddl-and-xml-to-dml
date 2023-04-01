from django import forms

class xmlForm(forms.Form):
    xmlText = forms.CharField(widget=forms.Textarea(attrs={'placeholder': 'Type your XML file...'}), label="")
    xsdText = forms.CharField(widget=forms.Textarea(attrs={'placeholder': 'Type your XML Schema...'}), label="")