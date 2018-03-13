from django.db import models
from .es_models import TinyURLIndex


class Acknowledgement(models.Model):

  FUNDING = 'FUNDING'
  CATEGORY_CHOICES = (
    (FUNDING, 'Funding'),
  )

  YES = '1'
  NO = '0'
  NA = '-1'
  IS_CURRENT_CHOICES = (
    ('1', 'Yes'),
    ('0', 'No'),
    ('-1', 'N/A')
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
  position = models.PositiveSmallIntegerField(default='0')
  ordering = ['position']

  class Meta:
    db_table = 'faq_categories'

  def __str__(self):
    return '%s' % (self.category_name)


class FaqSubcategory(models.Model):

  subcategory_name = models.CharField(max_length=100, blank=True, null=True)

  class Meta:
    db_table = 'faq_subcategories'

  def __str__(self):
    return '%s' % (self.subcategory_name)


class Faq(models.Model):

  category = models.ForeignKey(FaqCategory, on_delete=models.CASCADE)
  subcategory = models.ForeignKey(FaqSubcategory, on_delete=models.CASCADE)
  question = models.CharField(max_length=4000, blank=True, null=True, unique=True)
  answer = models.TextField(blank=True, null=True, unique=True)
  deleted = models.BooleanField(default=False)

  def __str__(self):
    return '%s' % (self.question)

class WizardStep(models.Model):

  title = models.CharField(max_length=100)


class WizardOptionType(models.Model):

  name = models.CharField(max_length=20)

class WizardOption(models.Model):

  title = models.CharField(max_length=30)
  icon = models.CharField(max_length=20)
  description = models.CharField(max_length=40)
  is_default = models.BooleanField(default=False)
  parent_step = models.ForeignKey(WizardStep, on_delete=models.CASCADE)
  type = models.ForeignKey(WizardOptionType)
  image_url = models.CharField(max_length=400)

class TinyURL(models.Model):

  long_url = models.TextField()
  hash = models.CharField(max_length=100)

  def indexing(self):
    obj = TinyURLIndex(
      meta={'id': self.id},
      long_url=self.long_url,
      hash=self.hash,
    )
    obj.save()
    return obj.to_dict(include_meta=True)


