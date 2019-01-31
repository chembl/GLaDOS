from django.db import models


class Parentsmile(models.Model):
    n_parent = models.IntegerField(primary_key=True)
    parent_smiles = models.CharField(max_length=4000)
    inchikey = models.CharField(max_length=30)

    class Meta:
        db_table = u'PARENTSMILES'
        managed = False

    def __str__(self):
        return self.parent_smiles
