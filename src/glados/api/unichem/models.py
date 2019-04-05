from django.db import models


class UciInchi(models.Model):
    uci = models.CharField(max_length=20, primary_key=True)
    standardinchi = models.CharField(max_length=4000)
    standardinchikey = models.CharField(max_length=30)

    class Meta:
        db_table = u'uc_inchi'
        managed = False

    def __str__(self):
        return self.uc_inchi
