from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'dj_yahoo_finance.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),

    url(r'^$', 'yahoo_finance.views.home'),
    # url(r'azteca-stocks.csv', 'yahoo_finance.views.get_azteca_csv'),
    url(r'terra-stocks.csv', 'yahoo_finance.views.get_terra_csv'),
    url(r'maxcom-stocks.csv', 'yahoo_finance.views.get_maxcomp_csv'),
)
