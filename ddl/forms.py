from django import forms

class xsdForm(forms.Form):
    xsdText = forms.CharField(widget=forms.Textarea(attrs={'placeholder': 'Type your XML Schema...'}), label="")


# class UploadFileForm(forms.Form):
#     xsdFile = forms.FileField(label="",allow_empty_file=True)