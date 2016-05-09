from django.test import TestCase

# Create your tests here.
from glados.models import Acknowledgement


class AcknowledgementsTests(TestCase):

  def setUp(self):
    # default acknowledgement
    Acknowledgement.objects.create(dates='2016-2020', content='test content!')

  def test_adds_one_ack(self):

    defaultAck = Acknowledgement.objects.get(dates='2016-2020')
    self.assertEqual(defaultAck.content, 'test content!')