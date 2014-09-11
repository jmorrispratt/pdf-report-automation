from django.shortcuts import render_to_response
from django.http import HttpResponse
import time


def home(request):
    return HttpResponse('<h1>This is a phony yahoo finance website for tests</h1>')


# def get_azteca_csv(request):
#     return render_to_response('azteca-bas.csv', {}, content_type='text/csv')


def get_terra_csv(request):
    return render_to_response('terra-13.csv', {}, content_type='text/csv')