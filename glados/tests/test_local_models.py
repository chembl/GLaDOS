from django.test import TestCase
from django.db.utils import IntegrityError

from glados.models import Acknowledgement
from glados.models import FaqCategory
from glados.models import FaqSubcategory
from glados.models import Faq



class AcknowledgementsTests(TestCase):
  def setUp(self):
    # default acknowledgement
    Acknowledgement.objects.create(dates='2016-2020', content='test content!')

  def test_adds_one_ack_with_default_values(self):
    defaultAck = Acknowledgement.objects.get(dates='2016-2020')
    self.assertEqual(defaultAck.content, 'test content!')


class FaqTests(TestCase):
  def setUp(self):
    # default FAQ
    testCat = FaqCategory.objects.create(category_name='Cat1')
    testSubCat = FaqSubcategory.objects.create(subcategory_name='SubCat1')

    testFaq = Faq.objects.create(category=testCat, subcategory=testSubCat,
                                 question="Did you just stuff that Aperture "
                                          "Science thing-we-don't-know-what-"
                                          "it-does into an Aperture Science "
                                          "Emergency Intelligence "
                                          "Incinerator?",
                                 answer="Yes")

  def test_cannot_add_same_question_twice(self):

    testCat = FaqCategory.objects.get(category_name='Cat1')
    testSubCat = FaqSubcategory.objects.get(subcategory_name='SubCat1')

    try:

      Faq.objects.create(category=testCat, subcategory=testSubCat,
                                question="Did you just stuff that Aperture "
                                         "Science thing-we-don't-know-what-"
                                         "it-does into an Aperture Science "
                                         "Emergency Intelligence "
                                         "Incinerator?",
                                answer="Yes")
    except IntegrityError:
      pass
    else:
      self.fail('You are not supposed to be able to add 2 Faqs with the same question')