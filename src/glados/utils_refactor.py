from django.views.generic import TemplateView
import traceback
from django.utils import translation

# This class allows to render template html files directly
class DirectTemplateView(TemplateView):

  translation.activate('en')
  extra_context = None
  def get_context_data(self, **kwargs):
    context = super(self.__class__, self).get_context_data(**kwargs)
    if self.extra_context is not None:
      for key, value in self.extra_context.items():
        if callable(value):
          context[key] = value()
        else:
          context[key] = value
    return context


def print_server_error(e):
  """
  prints the error to the logs
  :param e: error to print
  """

  print('Error:')
  print('>>>')
  print(e)
  print('^^^')
  print('Traceback:\n\n')
  traceback.print_exc()
  print('^^^')
  print('\n\n\n')