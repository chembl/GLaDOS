from django.db import models


class Acknowledgement(models.Model):

  FUNDING = 'FUNDING'
  CATEGORY_CHOICES = (
    (FUNDING, 'Funding'),
  )

  YES = '1'
  NO = '0'
  NA = '-1'
  IS_CURRENT_CHOICES = (
    (YES, 'Yes'),
    (NO, 'No'),
    (NA, 'N/A')
  )

  category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default=FUNDING)
  dates = models.CharField(max_length=400, blank=True, null=True)
  content = models.CharField(max_length=400, blank=True, null=True)
  is_current = models.IntegerField(choices=IS_CURRENT_CHOICES, default=YES)

  class Meta:
    db_table = 'acknowledgements'

  def __str__(self):
    return '%s: %s' % (self.dates, self.content)

class FaqCategory(models.Model):

  category_name = models.CharField(max_length=100, blank=True, null=True)

  class Meta:
    db_table = 'faq_categories'


class FaqSubcategory(models.Model):

  subcategory_name = models.CharField(max_length=100, blank=True, null=True)

  class Meta:
    db_table = 'faq_subcategories'


class Faq(models.Model):

  category = models.ForeignKey(FaqCategory, on_delete=models.CASCADE)
  subcategory = models.ForeignKey(FaqSubcategory, on_delete=models.CASCADE)
  question = models.CharField(max_length=4000, blank=True, null=True)
  answer = models.TextField(blank=True, null=True)
  deleted = models.BigIntegerField(blank=True, null=True)
